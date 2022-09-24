// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {IImage} from "./interfaces/IImage.sol";
import {Initializable} from "../utils/Initializable.sol";
import {UUPS} from "../proxy/UUPS.sol";
import {Ownable} from "../utils/Ownable.sol";
import {ImageStorage} from "./storage/ImageStorage.sol";
import {IUniversalImageStorage} from "./interfaces/IUniversalImageStorage.sol";
import {MetadataRenderer} from "./utils/MetadataRenderer.sol";
import { IFactory } from "../factory/interfaces/IFactory.sol";

contract Image is IImage, Initializable, ImageStorage {
    // this is how we're going to render metadata for a given token
    // each token is going to have a name (common), image, caption, like data hash, comment data hash, creator, and an owner
    // we also need a mirror counter

    IFactory private immutable factory;
    IUniversalImageStorage private immutable universalImageStorage;

    /*//////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    // in the initializer we need to specify the hyperobject source and the relevant common data for all NFTs
    constructor(address _factory, address _universalImageStorage) initializer {
        factory = IFactory(_factory);
        universalImageStorage = IUniversalImageStorage(_universalImageStorage); 
    }

    /*//////////////////////////////////////////////////////////////
                            INITIALIZER
    //////////////////////////////////////////////////////////////*/

    /// @notice Initializes a Token's image contract 
    /// @param _initStrings The encoded token and metadata initialization strings
    /// @param _token The associated ERC-721 token address
    function initialize(bytes calldata _initStrings, address _creator, address _token) external initializer {
        (string memory _name, string memory _initImageURI) = abi.decode(_initStrings, (string, string));
        config.name = _name;
        config.token = _token;

        // foundational image added to the network
        bytes32 initImageHash = _createImage(_creator, _initImageURI);
        tokenToImage[1] = universalImageStorage.getUniversalImage(initImageHash);
        universalImageStorage.incrementProvenanceCount(initImageHash);
    }

    /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    // images should only "die" when there are no active nodes propagating them

    /// @notice Assign token to image
    function knitToken(uint256 tokenId, address creator, bytes calldata imageString) external {
        // only token contract can call this function
        (string memory _imageURI) = abi.decode(imageString, (string));
        bytes32 imageHash = _createImage(creator, _imageURI);
        tokenToImage[tokenId] = universalImageStorage.getUniversalImage(imageHash);
        universalImageStorage.incrementProvenanceCount(imageHash);
    }

    function mirrorToken(uint256 tokenId, bytes32 imageHash) external {
        require(imageHash != bytes32(0), "Image: token does not exist");
        // image must be "alive" for it to be mirrored
        require(universalImageStorage.getProvenanceCount(imageHash) > 0, "Image is dead");
        tokenToImage[tokenId] = universalImageStorage.getUniversalImage(imageHash);
        universalImageStorage.incrementProvenanceCount(imageHash);
    }

    function burnToken(uint256 tokenId) external {
        bytes32 imageHash = tokenToImage[tokenId].imageHash;
        universalImageStorage.decrementProvenanceCount(imageHash);
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        return MetadataRenderer.createMetadata(
            config.name,
            tokenToImage[tokenId].imageURI,
            tokenToImage[tokenId].creator,
            universalImageStorage.getProvenanceCount(tokenToImage[tokenId].imageHash)
        );
    }

    function contractURI() external view returns (string memory) {
        return MetadataRenderer.encodeMetadataJSON(
            abi.encodePacked('{"name": "', config.name, '", "image": "', tokenToImage[1].imageURI, '"}')
        );
    }

    function token() external view returns (address) {
        return config.token;
    }

    function tokenDetails(uint256 tokenId) external view returns (Image memory) {
        return tokenToImage[tokenId];
    }

    /*//////////////////////////////////////////////////////////////
                            UTILITY
    //////////////////////////////////////////////////////////////*/

    /// @notice Add new image to network
    function _createImage(address _creator, string memory _imageURI) private returns (bytes32) {
        // only token contract can call this function
        bytes32 imageHash = bytes32(keccak256(abi.encodePacked(_imageURI, _creator)));
        //images[imageHash] = Image({imageURI: _imageURI, creator: _creator, imageHash: imageHash});
        universalImageStorage.addUniversalImage(_imageURI, _creator, block.timestamp, imageHash);
        return imageHash;
    }

}
