// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {ImageTypes} from "../types/ImageTypes.sol";

/// @title IUniversalImageStorage
/// @author neuroswish
/// @notice Image errors, events, and functions
interface IUniversalImageStorage is ImageTypes {
    /// @notice Full attributes for an image hash
    function addUniversalImage(string memory imageURI, address creator, bytes32 imageHash) external;

    function getUniversalImage(bytes32 imageHash) external view returns (Image memory);

    /// @notice Mirror counts for a content hash
    function incrementProvenanceCount(bytes32 imageHash) external;

    /// @notice Mirror counts for a content hash
    function decrementProvenanceCount(bytes32 imageHash) external;
}