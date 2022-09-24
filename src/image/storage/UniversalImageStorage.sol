// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {ImageTypes} from "../types/ImageTypes.sol";
import { IUniversalImageStorage } from "../interfaces/IUniversalImageStorage.sol";

/// @title UniversalImageStorage
/// @author neuroswish
/// @notice Universal storage of image hashes
contract UniversalImageStorage is IUniversalImageStorage {

    /// @notice Full attributes for an image hash
    mapping(bytes32 => Image) internal images;

    /// @notice Mirror counts for a content hash
    mapping(bytes32 => uint256) internal provenanceCount;

    /// @notice Full attributes for an image hash
    function addUniversalImage(string memory _imageURI, address _creator, uint256 _timestamp, bytes32 _imageHash) external {
        images[_imageHash] = Image(_imageURI, _creator, _timestamp, _imageHash);
    }

    function getUniversalImage(bytes32 imageHash) external view returns (Image memory) {
        return images[imageHash];
    }

    function getProvenanceCount(bytes32 imageHash) external view returns (uint256) {
        return provenanceCount[imageHash];
    }
    
    /// @notice Mirror counts for a content hash
    function incrementProvenanceCount(bytes32 imageHash) external {
        provenanceCount[imageHash]++;
    }

    /// @notice Mirror counts for a content hash
    function decrementProvenanceCount(bytes32 imageHash) external {
        provenanceCount[imageHash]--;
    }
}