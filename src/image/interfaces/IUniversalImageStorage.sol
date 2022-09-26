// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { ImageTypes } from "../types/ImageTypes.sol";

/// @title IUniversalImageStorage
/// @author neuroswish
/// @notice Universal Image Storage errors, events, and functions
interface IUniversalImageStorage is ImageTypes {
    /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    /// @notice Add an image to universal image storage
    /// @param imageURI The imageURI
    /// @param creator The imageURI
    /// @param imageHash The image hash
    /// @param timestamp The timestamp of creation
    function addUniversalImage(string memory imageURI, address creator, bytes32 imageHash, uint256 timestamp) external;

    /// @notice Return an image from universal image storage
    /// @param imageHash The image hash
    /// @return timestamp Full image attributes for an image hash
    function getUniversalImage(bytes32 imageHash) external view returns (Image memory);

    /// @notice Get the provenance count for an image
    /// @param imageHash The image hash
    /// @return provenanceCount The provenance count of the image
    function getProvenanceCount(bytes32 imageHash) external view returns (uint256);

    /// @notice Increment the provenance count for an image
    /// @param imageHash The image hash
    function incrementProvenanceCount(bytes32 imageHash) external;

    /// @notice Decrement the provenance count for an image
    /// @param imageHash The image hash
    function decrementProvenanceCount(bytes32 imageHash) external;
}