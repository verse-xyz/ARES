// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { SafeTransferLib } from "solmate/utils/SafeTransferLib.sol";
import { toDaysWadUnsafe } from "solmate/utils/SignedWadMath.sol";
import { ReentrancyGuard } from "../utils/ReentrancyGuard.sol";
import { Initializable } from "../utils/Initializable.sol";
import { UUPS } from "../proxy/UUPS.sol";
import { ERC721 } from "../utils/ERC721.sol";
import { TokenStorage } from "./storage/TokenStorage.sol";
import { IToken } from "./interfaces/IToken.sol";
import { IImage } from "../image/interfaces/IImage.sol";
import { IFactory } from "../factory/interfaces/IFactory.sol";
import { Image } from "../image/Image.sol";
import { ARES } from "../market/ARES.sol";

contract Token is IToken, TokenStorage, ERC721, ARES, ReentrancyGuard {
    /*//////////////////////////////////////////////////////////////
                          STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice Total number of tokens minted
    /// @dev This is used to generate the next token id
    uint256 private totalMinted;

    /// @notice Total number of tokens currently circulating in the market
    /// @dev This is used to track net supply at any given time, calculated as totalMinted - number of tokens burned
    uint256 private circulatingSupply;

    /// @dev Time of market initialization
    uint256 private immutable startTime = block.timestamp;

    /// @dev Address of network factory
    IFactory private immutable factory;

    /*//////////////////////////////////////////////////////////////
                          CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address _factory) {
        factory = IFactory(_factory);
    }

    /*//////////////////////////////////////////////////////////////
                          INITIALIZER
    //////////////////////////////////////////////////////////////*/

    /// @notice Initializes a hyperimage's token contract
    /// @param _initStrings The encoded token and metadata initialization strings
    /// @param _creator The hyperimage creator
    /// @param _image The image contract address
    /// @param _targetPrice The target price for a token if sold on pace, scaled by 1e18
    /// @param _priceDecayPercent Percent price decrease per unit of time, scaled by 1e18
    /// @param _perTimeUnit The total number of tokens to target selling every full unit of time
    /// @dev Only callable by the factory contract
    function initialize(
        bytes calldata _initStrings,
        address _creator,
        address _image,
        int256 _targetPrice,
        int256 _priceDecayPercent,
        int256 _perTimeUnit
    ) external initializer {
        // Ensure the caller is the factory contract
        if (msg.sender != address(factory)) revert ONLY_FACTORY(); 

        __ReentrancyGuard_init();

        (string memory _name, ) =
            abi.decode(_initStrings, (string, string));

        // Setup ERC-721
        __ERC721_init(_name, "");

        // Setup market
        __ARES_init(_targetPrice, _priceDecayPercent, _perTimeUnit);

        // Setup token config
        config.image = _image;
        config.creator = _creator;
        config.targetPrice = _targetPrice;
        config.priceDecayPercent = _priceDecayPercent;
        config.perTimeUnit = _perTimeUnit;
        
        // Mint first token for creator with a tokenId of 1
        _mint(_creator, 1);
        totalMinted++;
    }

    /*//////////////////////////////////////////////////////////////
                          FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Knit a new token to the hyperimage
    /// @param imageURI The URI of the image to knit
    /// @return tokenId The ID of the newly knitted token
    function knit(string memory imageURI) public payable returns (uint256 tokenId) {
        unchecked {
            uint256 price = getVRGDAPrice(toDaysWadUnsafe(block.timestamp - startTime), tokenId = totalMinted++);
            circulatingSupply++;
            require(msg.value >= price, "Token: Insufficient payment");
            Image(config.image).knitToken(tokenId, msg.sender, bytes(imageURI));
            _mint(msg.sender, tokenId);
            // Note: We do this at the end to avoid creating a reentrancy vector.
            // Refund the user any ETH they spent over the current price of the NFT.
            // Unchecked is safe here because we validate msg.value >= price above.
            SafeTransferLib.safeTransferETH(msg.sender, msg.value - price);
            emit Knitted(tokenId, msg.sender, imageURI, price);
        }
        
    }

    /// @notice Mirror a new token to the hyperimage
    /// @param imageHash The hash of the image to mirror
    /// @return tokenId The ID of the newly mirrored token
    function mirror(bytes32 imageHash) public payable returns (uint256 tokenId) {
        unchecked {
            uint256 price = getVRGDAPrice(toDaysWadUnsafe(block.timestamp - startTime), tokenId = totalMinted++);
            circulatingSupply++;
            require(msg.value >= price, "Token: Insufficient payment");
            Image(config.image).mirrorToken(tokenId, imageHash);
            tokenIsMirror[tokenId] = true;
            _mint(msg.sender, tokenId);
            // Note: We do this at the end to avoid creating a reentrancy vector.
            // Refund the user any ETH they spent over the current price of the NFT.
            // Unchecked is safe here because we validate msg.value >= price above.
            SafeTransferLib.safeTransferETH(msg.sender, msg.value - price);
            emit Mirrored(tokenId, msg.sender, imageHash, price);
        }
    }

    /// @notice Burn a hyperimage token
    /// @param tokenId The ID of the token to burn
    /// @dev Only callable by token owner
    function burn(uint256 tokenId) public {
        unchecked {
            if (ownerOf(tokenId) != msg.sender) revert ONLY_OWNER();
            uint256 price = getVRGDAPrice(toDaysWadUnsafe(block.timestamp - startTime), circulatingSupply--);
            if (price > address(this).balance) revert INSUFFICIENT_RESERVES();
            _burn(tokenId);
            // If token is a mirror, split returned ETH evenly between the owner and the original image creator
            if (tokenIsMirror[tokenId]) {
                price = price / 2;
                address payable creator = payable(Image(config.image).tokenDetails(tokenId).creator);
                SafeTransferLib.safeTransferETH(creator, price);
                SafeTransferLib.safeTransferETH(msg.sender, price);
                emit Burned(tokenId, price * 2);
            } else {
                SafeTransferLib.safeTransferETH(msg.sender, price);
                emit Burned(tokenId, price);
            }
            
        }
    }

    /// @notice Redeem reward ETH
    /// @dev Only callable by hyperimage creator
    function redeem() public nonReentrant {
        if(msg.sender != config.creator) revert ONLY_CREATOR();
        uint256 reserves = getMinimumReserves(toDaysWadUnsafe(block.timestamp - startTime), circulatingSupply);
        require(reserves > address(this).balance, "Token: Insufficient reserves");
        SafeTransferLib.safeTransferETH(msg.sender, reserves - address(this).balance);
        emit Redeemed(reserves - address(this).balance);
    }

    /*//////////////////////////////////////////////////////////////
                          UTILITY
    //////////////////////////////////////////////////////////////*/

    /// @notice The URI for a token
    /// @param tokenId The ERC-721 token id
    function tokenURI(uint256 tokenId) public view override(IToken, ERC721) returns (string memory) {
        return IImage(config.image).tokenURI(tokenId);
    }

    /// @notice The URI for the contract
    function contractURI() public view override(IToken, ERC721) returns (string memory) {
        return IImage(config.image).contractURI();
    }

    /// @notice The circulating supply of tokens
    function getSupply() public view returns (uint256) {
        return circulatingSupply;
    }

    /// @notice The current token price
    function getPrice() public view returns (uint256) {
        return getVRGDAPrice(toDaysWadUnsafe(block.timestamp - startTime), circulatingSupply);
    }

    /// @notice The image contract address
    function getImage() public view returns (address) {
        return config.image;
    }

    /// @notice The hyperimage creator
    function getCreator() public view returns (address) {
        return config.creator;
    }
        
}
