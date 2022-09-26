// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { Ownable } from "../utils/Ownable.sol";
import { ERC1967Proxy } from "../proxy/ERC1967Proxy.sol";
import { IImage } from "../image/interfaces/IImage.sol";
import { IUniversalImageStorage } from "../image/interfaces/IUniversalImageStorage.sol";
import { IToken } from "../token/interfaces/IToken.sol";
import { IFactory } from "./interfaces/IFactory.sol";
import { FactoryStorage } from "./storage/FactoryStorage.sol";

contract Factory is IFactory, FactoryStorage, Ownable {
    /*//////////////////////////////////////////////////////////////
                          IMMUTABLES
    //////////////////////////////////////////////////////////////*/
    ///@notice The token implementation address
    address public immutable tokenImpl;

    ///@notice The image implementation address
    address public immutable imageImpl;

    ///@notice The universal image storage address
    address public immutable universalImageStorage;

    ///@notice The image implementation hash
    bytes32 private immutable imageHash;

    /*//////////////////////////////////////////////////////////////
                          CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(address _token, address _image, address _universalImageStorage) {
        tokenImpl = _token;
        imageImpl = _image;
        universalImageStorage = _universalImageStorage;
        imageHash = keccak256(abi.encodePacked(type(ERC1967Proxy).creationCode, abi.encode(_image, ""))); 
    }

    /*//////////////////////////////////////////////////////////////
                          INITIALIZER
    //////////////////////////////////////////////////////////////*/
    /// @notice Initializes ownership of the factory contract
    /// @param _owner The address of the owner (transferred to Verse once deployed)
    function initialize(address _owner) external initializer {
        if (_owner == address(0)) revert ADDRESS_ZERO();
        // Set contract owner
        __Ownable_init(_owner);
    }

    /*//////////////////////////////////////////////////////////////
                          HYPERIMAGE DEPLOY
    //////////////////////////////////////////////////////////////*/
    /// @notice Deploys a hyperimage
    /// @param _tokenParams The hyperimage token parameters
    /// @return token The ERC-721 token address
    /// @return image The image rendering address
    function deploy(TokenParams calldata _tokenParams) external returns (address token, address image) {
        // Deploy the hyperimage's token
        token = address(new ERC1967Proxy(tokenImpl, ""));

        // Use the token address to precompute the hyperimage's remaining addresses
        bytes32 salt = bytes32(uint256(uint160(token)) << 96);

        // Deploy the hyperimage's image contract using the salt 
        image = address(new ERC1967Proxy{ salt: salt }(imageImpl, ""));

        // Initialize the hyperimage's token contract
        IToken(token).initialize( 
            _tokenParams.initStrings,
            msg.sender,
            image,
            _tokenParams.targetPrice,
            _tokenParams.priceDecayPercent,
            _tokenParams.perTimeUnit
        );

        // Initialize the hyperimage's image contract
        IImage(image).initialize(_tokenParams.initStrings, msg.sender, token);

        emit HyperimageDeployed(token, image);
    }

    /*//////////////////////////////////////////////////////////////
                          HYPERIMAGE ADDRESSES
    //////////////////////////////////////////////////////////////*/
    /// @notice Return a hyperimage's contracts
    /// @param _token The hyperimage's token address
    /// @return image The hyperimage's image rendering address
    function getAddresses(address _token) external view returns (address image) {
        bytes32 salt = bytes32(uint256(uint160(_token)) << 96);
        image = address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xff), address(this), salt, imageHash)))));
    }

}
