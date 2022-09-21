// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {UUPS} from "../proxy/UUPS.sol";
import {ReentrancyGuard} from "../utils/ReentrancyGuard.sol";
import {ERC721} from "../token/ERC721.sol";
import {TokenStorage} from "./storage/TokenStorage.sol";
import {IToken} from "./interfaces/IToken.sol";
import {IImage} from "../image/interfaces/IImage.sol";
import {Image} from "../image/Image.sol";
import {LinearVRGDA} from "../market/LinearVRGDA.sol";

import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {toDaysWadUnsafe} from "solmate/utils/SignedWadMath.sol";

contract Token is IToken, ERC721, LinearVRGDA, UUPS, ReentrancyGuard, TokenStorage {
    /*//////////////////////////////////////////////////////////////
                          STORAGE
  //////////////////////////////////////////////////////////////*/
    /// @notice Total number of tokens minted
    /// @dev This is used to generate the next token id
    uint256 public totalMinted;

    /// @notice Total number of tokens currently circulating in the market
    /// @dev This is used to track net supply at any given time, calculated as totalMinted - number of tokens burned
    uint256 public circulatingSupply;

    /// @notice Time of market initialization
    uint256 public immutable startTime = block.timestamp;

    /*//////////////////////////////////////////////////////////////
                          CONSTRUCTOR
  //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                          INITIALIZER
  //////////////////////////////////////////////////////////////*/
    function initialize(
        bytes calldata _initStrings,
        address _creator,
        address _image,
        int256 _targetPrice,
        int256 _priceDecayPercent,
        int256 _perTimeUnit
    ) external initializer {
        __ReentrancyGuard_init();
        (string memory _name, string memory _symbol, string memory _initImageURI) =
            abi.decode(_initStrings, (string, string, string));

        // setup ERC721 and Linear VRGDA
        __ERC721_init(_name, _symbol);
        __LinearVRGDA_init(_targetPrice, _priceDecayPercent, _perTimeUnit);

        // setup token config
        config.image = _image;
        config.creator = _creator;
        config.targetPrice = _targetPrice;
        config.priceDecayPercent = _priceDecayPercent;
        config.perTimeUnit = _perTimeUnit;
    }

    /*//////////////////////////////////////////////////////////////
                          FUNCTIONS
  //////////////////////////////////////////////////////////////*/

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
        }
    }

    function mirror(uint256 mirrorTokenId) public payable returns (uint256 tokenId) {
        unchecked {
            uint256 price = getVRGDAPrice(toDaysWadUnsafe(block.timestamp - startTime), tokenId = totalMinted++);
            circulatingSupply++;
            require(msg.value >= price, "Token: Insufficient payment");
            Image(config.image).mirrorToken(tokenId, mirrorTokenId);
            _mint(msg.sender, tokenId);
            // Note: We do this at the end to avoid creating a reentrancy vector.
            // Refund the user any ETH they spent over the current price of the NFT.
            // Unchecked is safe here because we validate msg.value >= price above.
            SafeTransferLib.safeTransferETH(msg.sender, msg.value - price);
        }
    }

    function burn(uint256 tokenId) public {
        unchecked {
            require(ownerOf(tokenId) == msg.sender, "Token: Not owner");
            uint256 price = getVRGDAPrice(toDaysWadUnsafe(block.timestamp - startTime), circulatingSupply--);
            _burn(tokenId);
            SafeTransferLib.safeTransferETH(msg.sender, price);
        }
    }

    // function withdraw() public {
    //   // calculate amount of ETH required to facilitate sale of all NFTs in one block
    //   uint256 price = getVRGDAPrice(toDaysWadUnsafe(block.timestamp - startTime), tokenId = totalMinted++);
    // }
}
