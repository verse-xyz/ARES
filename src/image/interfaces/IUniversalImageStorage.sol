// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {ImageTypes} from "../types/ImageTypes.sol";

/// @title IUniversalImageStorage
/// @author neuroswish
/// @notice Image errors, events, and functions
interface IUniversalImageStorage is ImageTypes {
    /// @notice Full attributes for an image hash
    function addUniversalImage(string memory imageURI, address creator, uint256 timestamp, bytes32 imageHash) external;

    function getUniversalImage(bytes32 imageHash) external view returns (Image memory);

    function getProvenanceCount(bytes32 imageHash) external view returns (uint256);

    /// @notice Mirror counts for a content hash
    function incrementProvenanceCount(bytes32 imageHash) external;

    /// @notice Mirror counts for a content hash
    function decrementProvenanceCount(bytes32 imageHash) external;
}