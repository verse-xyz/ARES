// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title TokenTypes
/// @author neuroswish
/// @notice Types for the token contract
interface TokenTypes {
    /// @notice Token configuration settings
    struct Config {
        address image;
        address creator;
        int256 targetPrice;
        int256 priceDecayPercent;
        int256 perTimeUnit;
    }
}
