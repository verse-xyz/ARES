// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { wadLn } from "solmate/utils/SignedWadMath.sol";
import { Initializable } from "../utils/Initializable.sol";
import { Ownable } from "../utils/Ownable.sol";
import { ERC1967Proxy } from "../proxy/ERC1967Proxy.sol";
import { IImage } from "../image/interfaces/IImage.sol";
import { IUniversalImageStorage } from "../image/interfaces/IUniversalImageStorage.sol";
import { IToken } from "../token/interfaces/IToken.sol";
import { IFactory } from "./interfaces/IFactory.sol";
import { FactoryStorage } from "./storage/FactoryStorage.sol";

contract Factory is IFactory, FactoryStorage, Initializable {
    /*//////////////////////////////////////////////////////////////
                          STORAGE
    //////////////////////////////////////////////////////////////*/

    ///@notice The token implementation address
    address public tokenImpl;
 
    ///@notice The image implementation address
    address public imageImpl;

    ///@notice The universal image storage address
    address public universalImageStorage;

    ///@notice The image implementation hash
    bytes32 private imageHash;

    /*//////////////////////////////////////////////////////////////
                          INITIALIZER
    //////////////////////////////////////////////////////////////*/

    /// @notice Initializes the factory contract
    /// @param _token The token implementation address
    /// @param _image The image implementation address
    /// @param _universalImageStorage The universal image storage address
    function initialize(address _token, address _image, address _universalImageStorage) external initializer {
        tokenImpl = _token;
        imageImpl = _image;
        universalImageStorage = _universalImageStorage;
        imageHash = keccak256(abi.encodePacked(type(ERC1967Proxy).creationCode, abi.encode(_image, ""))); 
    }

    /*//////////////////////////////////////////////////////////////
                          HYPERIMAGE DEPLOY
    //////////////////////////////////////////////////////////////*/

    /// @notice Deploys a hyperimage
    /// @param _tokenParams The hyperimage token parameters
    /// @return token The ERC-721 token address
    /// @return image The image rendering address
    function deploy(TokenParams calldata _tokenParams) external returns (address token, address image) {
        // The decay constant must be negative for the market to work
        int256 decayConstant = wadLn(1e18 - _tokenParams.priceDecayPercent);
        if (decayConstant < 0) revert INVALID_TOKEN_PARAMS();

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

    /*//////////////////////////////////////////////////////////////
                    UNIVERSAL IMAGE STORAGE AUTHORIZATIONS
    //////////////////////////////////////////////////////////////*/
    /// @notice Return authorization status of a contract to write to universal image storage
    /// @param _address The contract address
    function isAuthorized(address _address) external view returns (bool) {
        return authorizedUIS[_address];
    }

}
