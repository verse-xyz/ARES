// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title ImageTypes
/// @author neuroswish
/// @notice Types for the image contract
interface ImageTypes {
    /// @notice Full attributes for an image
    struct Image {
        string imageURI;
        address creator;
        uint256 timestamp;
        bytes32 imageHash;
    }

    /// @notice Configuration for an image contract
    struct Config {
        address token;
        string name;
    }
}
