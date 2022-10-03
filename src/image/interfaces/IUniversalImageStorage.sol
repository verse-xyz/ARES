// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { ImageTypes } from "src/image/types/ImageTypes.sol";

/// @title IUniversalImageStorage
/// @author neuroswish
/// @notice Universal Image Storage errors, events, and functions
interface IUniversalImageStorage is ImageTypes {
    /*//////////////////////////////////////////////////////////////
                            ERRORS
    //////////////////////////////////////////////////////////////*/
    /// @dev Reverts if caller is not authorized to update universal image storage
    error NOT_AUTHORIZED();

    /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Add an image to universal image storage
    /// @param imageURI The image URI
    /// @param creator The image creator
    /// @param imageHash The image hash
    /// @param timestamp Timestamp of image creation
    function addUniversalImage(string memory imageURI, address creator, bytes32 imageHash, uint256 timestamp) external;

    /// @notice Return an image from universal image storage
    /// @param imageHash The image hash
    function getUniversalImage(bytes32 imageHash) external view returns (Image memory);

    /// @notice Get the provenance count for an image
    /// @param imageHash The image hash
    function getProvenanceCount(bytes32 imageHash) external view returns (uint256);

    /// @notice Increment the provenance count for an image
    /// @param imageHash The image hash
    function incrementProvenanceCount(bytes32 imageHash) external;

    /// @notice Decrement the provenance count for an image
    /// @param imageHash The image hash
    function decrementProvenanceCount(bytes32 imageHash) external;
}