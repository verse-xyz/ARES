// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { IUniversalImageStorage } from "src/image/interfaces/IUniversalImageStorage.sol";
import { IFactory } from "src/factory/interfaces/IFactory.sol";

/// @title UniversalImageStorage
/// @author neuroswish
/// @notice Universal storage of image hashes
contract UniversalImageStorage is IUniversalImageStorage {
    /*//////////////////////////////////////////////////////////////
                          STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice Factory address
    address private immutable factory;

    /// @notice Full attributes for an image hash
    mapping(bytes32 => Image) internal images;

    /// @notice Provenance count for an image hash
    mapping(bytes32 => uint256) internal provenanceCount;

    /*//////////////////////////////////////////////////////////////
                          CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(address _factory) {
        factory = _factory;
    }

    /*//////////////////////////////////////////////////////////////
                          FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    /// @notice Add an image to universal image storage
    /// @param imageURI The imageURI
    /// @param creator The imageURI
    /// @param imageHash The image hash
    /// @param timestamp The timestamp of creation
    function addUniversalImage(string memory imageURI, address creator, bytes32 imageHash, uint256 timestamp) external {
        if (!IFactory(factory).isAuthorized(msg.sender)) revert NOT_AUTHORIZED();
        images[imageHash] = Image(imageURI, creator, timestamp, imageHash);
    }

    /// @notice Return an image from universal image storage
    /// @param imageHash The image hash
    function getUniversalImage(bytes32 imageHash) external view returns (Image memory) {
        return images[imageHash];
    }

    /// @notice Get the provenance count for an image
    /// @param imageHash The image hash
    function getProvenanceCount(bytes32 imageHash) external view returns (uint256) {
        return provenanceCount[imageHash];
    }
    
    /// @notice Increment the provenance count for an image
    /// @param imageHash The image hash
    function incrementProvenanceCount(bytes32 imageHash) external {
        if (!IFactory(factory).isAuthorized(msg.sender)) revert NOT_AUTHORIZED();
        provenanceCount[imageHash]++;
    }

    /// @notice Decrement the provenance count for an image
    /// @param imageHash The image hash
    function decrementProvenanceCount(bytes32 imageHash) external {
        if (!IFactory(factory).isAuthorized(msg.sender)) revert NOT_AUTHORIZED();
        provenanceCount[imageHash]--;
    }
}