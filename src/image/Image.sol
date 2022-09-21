// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {IImage} from "../interfaces/IImage.sol";
import {UUPS} from "../proxy/UUPS.sol";
import {Ownable} from "../utils/Ownable.sol";
import {ImageStorage} from "./storage/ImageStorage.sol";
import {MetadataRenderer} from "./utils/MetadataRenderer.sol";
//import { Token } from "../token/Token.sol";

contract Image is IImage, UUPS, Ownable, ImageStorage {
    // this is how we're going to render metadata for a given token
    // each token is going to have a name (common), image, caption, like data hash, comment data hash, creator, and an owner
    // we also need a mirror counter

    // we're going to store the address of the associated hyperobject contract

    /*//////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    // in the initializer we need to specify the hyperobject source and the relevant common data for all NFTs
    constructor() {}

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
        bytes32 initContentHash = _createImage(_creator, _initImageURI);
        tokenToImage[1] = images[initContentHash];
        provenanceCount[initContentHash]++;
    }

    /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    // images should only "die" when there are no active nodes propagating them

    /// @notice Assign token to image
    function knitToken(uint256 tokenId, address creator, bytes calldata imageString) external {
        // only token contract can call this function
        (string memory _imageURI) = abi.decode(imageString, (string));
        bytes32 contentHash = _createImage(creator, _imageURI);
        tokenToImage[tokenId] = images[contentHash];
        provenanceCount[contentHash]++;
    }

    function mirrorToken(uint256 tokenId, uint256 mirrorTokenId) external {
        bytes32 contentHashToMirror = tokenToImage[mirrorTokenId].contentHash;
        require(contentHashToMirror != bytes32(0), "Image: token does not exist");
        // image must be "alive" for it to be mirrored
        require(provenanceCount[contentHashToMirror] > 0, "Image is dead");
        tokenToImage[tokenId] = images[contentHashToMirror];
        provenanceCount[contentHashToMirror]++;
    }

    function burnToken(uint256 tokenId) external {
        bytes32 contentHashToBurn = tokenToImage[tokenId].contentHash;
        provenanceCount[contentHashToBurn]--;
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        return MetadataRenderer.createMetadata(
            config.name,
            tokenToImage[tokenId].imageURI,
            tokenToImage[tokenId].creator,
            provenanceCount[tokenToImage[tokenId].contentHash]
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

    /*//////////////////////////////////////////////////////////////
                            UTILITY
    //////////////////////////////////////////////////////////////*/

    /// @notice Add new image to network
    function _createImage(address _creator, string memory _imageURI) private returns (bytes32) {
        // only token contract can call this function
        bytes32 contentHash = bytes32(keccak256(abi.encodePacked(_imageURI, _creator)));
        images[contentHash] = Image({imageURI: _imageURI, creator: _creator, contentHash: contentHash});

        return contentHash;
    }
    // what do we need in this contract?
    // in the knit function the caller passes in the relevant data and then we store it in the tokenInfo mapping
}

// when someone knits, they're gonna pass in the imageURI
// we're gonna store the imageURI in the base mapping
