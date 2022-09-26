// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { Initializable } from "../utils/Initializable.sol";
import { MetadataRenderer } from "./utils/MetadataRenderer.sol";
import { IImage } from "./interfaces/IImage.sol";
import { ImageStorage } from "./storage/ImageStorage.sol";
import { IUniversalImageStorage } from "./interfaces/IUniversalImageStorage.sol";
import { IFactory } from "../factory/interfaces/IFactory.sol";

contract Image is IImage, ImageStorage, Initializable {
    /*//////////////////////////////////////////////////////////////
                            IMMUTABLES
    /////////////////////////////////////////////////////////////*/

    IFactory private immutable factory;
    IUniversalImageStorage private immutable universalImageStorage;

    /*//////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address _factory, address _universalImageStorage) initializer {
        factory = IFactory(_factory);
        universalImageStorage = IUniversalImageStorage(_universalImageStorage); 
    }

    /*//////////////////////////////////////////////////////////////
                            INITIALIZER
    //////////////////////////////////////////////////////////////*/

    /// @notice Initializes a hyperimage's image contract 
    /// @dev Only callable by the factory contract
    /// @param _initStrings The encoded token and metadata initialization strings
    /// @param _creator The hyperimage creator
    /// @param _token The ERC-721 token address
    function initialize(bytes calldata _initStrings, address _creator, address _token) external initializer {
        // Ensure the caller is the factory contract
        if (msg.sender != address(factory)) revert ONLY_FACTORY();
        // Store initialization variables in configuration storage
        (string memory _name, string memory _initImageURI) = abi.decode(_initStrings, (string, string));
        config.name = _name;
        config.token = _token;
        
        // Create the initial image hash and assign it to the first token
        bytes32 initImageHash = _createImage(_creator, _initImageURI);
        tokenToImage[1] = universalImageStorage.getUniversalImage(initImageHash);
        universalImageStorage.incrementProvenanceCount(initImageHash);
    }

    /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Assign token to a new image
    /// @dev Only callable by the token contract
    /// @param tokenId The token being assigned to a new image
    /// @param creator The creator of the new image
    /// @param imageURI The URI of the new image
    function knitToken(uint256 tokenId, address creator, bytes calldata imageURI) external {
        // Ensure the caller is the token contract
        if (msg.sender != config.token) revert ONLY_TOKEN();
        (string memory _imageURI) = abi.decode(imageURI, (string));

        // Create the new image and assign it to the token
        bytes32 imageHash = _createImage(creator, _imageURI);
        tokenToImage[tokenId] = universalImageStorage.getUniversalImage(imageHash);
        universalImageStorage.incrementProvenanceCount(imageHash);
        emit ImageProvenanceCountUpdated(_imageURI, imageHash, universalImageStorage.getProvenanceCount(imageHash));
    }

    /// @notice Assign token to an existing, propagating image
    /// @dev Only callable by the token contract
    /// @param tokenId The token being assigned to the image
    /// @param imageHash The hash of the image to be mirrored
    function mirrorToken(uint256 tokenId, bytes32 imageHash) external {
        // Ensure the caller is the token contract
        if (msg.sender != config.token) revert ONLY_TOKEN();

        // Image must be alive to be mirrored
        if (universalImageStorage.getProvenanceCount(imageHash) < 1) revert NONEXISTENT_IMAGE();

        // Assign the token to the image
        tokenToImage[tokenId] = universalImageStorage.getUniversalImage(imageHash);
        universalImageStorage.incrementProvenanceCount(imageHash);
        emit ImageProvenanceCountUpdated(universalImageStorage.getUniversalImage(imageHash).imageURI, imageHash, universalImageStorage.getProvenanceCount(imageHash));

    }

    /// @notice Decrement the provenance count of the image assigned to a token being burned
    /// @dev Only callable by the token contract
    /// @param tokenId The token being burned
    function burnToken(uint256 tokenId) external {
        // Decrement the provenance count of the image assigned to the burned token
        bytes32 imageHash = tokenToImage[tokenId].imageHash;
        universalImageStorage.decrementProvenanceCount(imageHash);
        emit ImageProvenanceCountUpdated(universalImageStorage.getUniversalImage(imageHash).imageURI, imageHash, universalImageStorage.getProvenanceCount(imageHash));
    }

    /// @notice Return the URI of a token
    /// @param tokenId The specified token
    /// @return The URI of the token
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        return MetadataRenderer.createMetadata(
            config.name,
            tokenToImage[tokenId].imageURI,
            tokenToImage[tokenId].creator,
            universalImageStorage.getProvenanceCount(tokenToImage[tokenId].imageHash)
        );
    }

    /// @notice Return the URI of the token contract
    /// @return The URI of the token contract
    function contractURI() external view returns (string memory) {
        return MetadataRenderer.encodeMetadataJSON(
            abi.encodePacked('{"name": "', config.name, '", "image": "', tokenToImage[1].imageURI, '"}')
        );
    }

    /// @notice Return the address of the token contract
    /// @return The address of the token contract
    function token() external view returns (address) {
        return config.token;
    }

    /// @notice Return the image attributes assigned to a token
    /// @param tokenId The specified token
    /// @return The attributes of the image assigned to the specified token
    function tokenDetails(uint256 tokenId) external view returns (Image memory) {
        return tokenToImage[tokenId];
    }

    /*//////////////////////////////////////////////////////////////
                            UTILITY
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Create an image and add it to universal image storage
    /// @param _creator The image creator
    /// @param _imageURI The URI for the image to be created
    /// @return The image hash
    function _createImage(address _creator, string memory _imageURI) private returns (bytes32) {
        bytes32 imageHash = bytes32(keccak256(abi.encodePacked(_imageURI, _creator)));
        if (universalImageStorage.getProvenanceCount(imageHash) > 0) revert EXISTING_IMAGE();
        universalImageStorage.addUniversalImage(_imageURI, _creator, imageHash, block.timestamp);
        emit ImageCreated(_creator, _imageURI, imageHash, block.timestamp);
        return imageHash;
    }

}
