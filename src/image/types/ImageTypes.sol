// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title ImageTypes
/// @author neuroswish
/// @notice Types for the image contract
interface ImageTypes {
    /// @notice Full attributes for an image
    /// @param imageURI The image URI
    /// @param creator The image creator
    /// @param imageHash The image hash
    /// @param timestamp Timestamp of image creation
    struct Image {
        string imageURI;
        address creator;
        uint256 timestamp;
        bytes32 imageHash;
    }

    /// @notice Configuration for an image contract
    /// @param token The token contract address
    /// @param name The hyperimage name
    struct Config {
        address token;
        string name;
    }
}
