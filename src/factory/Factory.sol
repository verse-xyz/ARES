// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { Ownable } from "../utils/Ownable.sol";
import { ERC1967Proxy } from "../proxy/ERC1967Proxy.sol";
import { IImage } from "../image/interfaces/IImage.sol";
import { IToken } from "../token/interfaces/IToken.sol";
import { IUniversalImageStorage } from "../image/interfaces/IUniversalImageStorage.sol";
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

        // hash of proxy bytecode and image implementation
        imageHash = keccak256(abi.encodePacked(type(ERC1967Proxy).creationCode, abi.encode(_image, ""))); 
    }

    /*//////////////////////////////////////////////////////////////
                          INITIALIZER
    //////////////////////////////////////////////////////////////*/
    /// @notice Initializes ownership of the factory contract
    /// @param _owner The address of the owner (transferred to Verse once deployed)

    function initialize(address _owner) external initializer {
        // Ensure owner is specified
        if (_owner == address(0)) revert ADDRESS_ZERO();
        // Set contract owner
        __Ownable_init(_owner);
    }

    /*//////////////////////////////////////////////////////////////
                          HYPERIMAGE DEPLOY
    //////////////////////////////////////////////////////////////*/
    function deploy(TokenParams calldata _tokenParams) external returns (address token, address image) {
        // Deploy the hyperimage's token
        token = address(new ERC1967Proxy(tokenImpl, ""));

        // Use the token address to precompute the hyperimage's remaining addresses
        bytes32 salt = bytes32(uint256(uint160(token)) << 96);

        // Deploy the hyperimage's image contract using the salt 
        image = address(new ERC1967Proxy{ salt: salt }(imageImpl, ""));

        // Initialize instances with provided config
        // initStrings is just going to be name and imageURI
        IToken(token).initialize( 
            _tokenParams.initStrings,
            msg.sender,
            image,
            _tokenParams.targetPrice,
            _tokenParams.priceDecayPercent,
            _tokenParams.perTimeUnit
        );

        IImage(image).initialize(_tokenParams.initStrings, msg.sender, token);

        emit HyperimageDeployed(token, image);
    }

    /*//////////////////////////////////////////////////////////////
                          HYPERIMAGE ADDRESSES
    //////////////////////////////////////////////////////////////*/
    function getAddresses(address _token) external view returns (address image) {
        bytes32 salt = bytes32(uint256(uint160(_token)) << 96);
        image = address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xff), address(this), salt, imageHash)))));
    }

    /*//////////////////////////////////////////////////////////////
                          NETWORK UPGRADES
    //////////////////////////////////////////////////////////////*/
    /// @notice If an implementation is registered by Verse as an optional upgrade
    /// @param _baseImpl The base implementation address
    /// @param _upgradeImpl The upgrade implementation address
    function isRegisteredUpgrade(address _baseImpl, address _upgradeImpl) external view returns (bool) {
        return isUpgrade[_baseImpl][_upgradeImpl];
    }

    /// @notice Called by Verse to offer implementation upgrades for created DAOs
    /// @param _baseImpl The base implementation address
    /// @param _upgradeImpl The upgrade implementation address
    function registerUpgrade(address _baseImpl, address _upgradeImpl) external onlyOwner {
        isUpgrade[_baseImpl][_upgradeImpl] = true;
        emit UpgradeRegistered(_baseImpl, _upgradeImpl);
    }

    /// @notice Called by Verse to remove an upgrade
    /// @param _baseImpl The base implementation address
    /// @param _upgradeImpl The upgrade implementation address
    function removeUpgrade(address _baseImpl, address _upgradeImpl) external onlyOwner {
        delete isUpgrade[_baseImpl][_upgradeImpl];
        emit UpgradeRemoved(_baseImpl, _upgradeImpl);
    }

    // /*//////////////////////////////////////////////////////////////
    //                       FACTORY UPGRADES
    // //////////////////////////////////////////////////////////////*/
    // /// @notice Ensures the caller is authorized to upgrade the contract
    // /// @dev This function is called in `upgradeTo` & `upgradeToAndCall`
    // /// @param _newImpl The new implementation address
    // function _authorizeUpgrade(address _newImpl) internal override onlyOwner {}
}
