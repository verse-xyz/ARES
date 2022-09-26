// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { IUniversalImageStorage } from "../interfaces/IUniversalImageStorage.sol";

/// @title UniversalImageStorage
/// @author neuroswish
/// @notice Universal storage of image hashes
contract UniversalImageStorage is IUniversalImageStorage {
    /// @notice Full attributes for an image hash
    mapping(bytes32 => Image) internal images;

    /// @notice Provenance count for an image hash
    mapping(bytes32 => uint256) internal provenanceCount;

    /// @notice Add an image to universal image storage
    /// @param imageURI The imageURI
    /// @param creator The imageURI
    /// @param imageHash The image hash
    /// @param timestamp The timestamp of creation
    function addUniversalImage(string memory imageURI, address creator, bytes32 imageHash, uint256 timestamp) external {
        images[imageHash] = Image(imageURI, creator, timestamp, imageHash);
    }

    /// @notice Return an image from universal image storage
    /// @param imageHash The image hash
    /// @return timestamp Full image attributes for an image hash
    function getUniversalImage(bytes32 imageHash) external view returns (Image memory) {
        return images[imageHash];
    }

    /// @notice Get the provenance count for an image
    /// @param imageHash The image hash
    /// @return provenanceCount The provenance count of the image
    function getProvenanceCount(bytes32 imageHash) external view returns (uint256) {
        return provenanceCount[imageHash];
    }
    
    /// @notice Increment the provenance count for an image
    /// @param imageHash The image hash
    function incrementProvenanceCount(bytes32 imageHash) external {
        provenanceCount[imageHash]++;
    }

    /// @notice Decrement the provenance count for an image
    /// @param imageHash The image hash
    function decrementProvenanceCount(bytes32 imageHash) external {
        provenanceCount[imageHash]--;
    }
}