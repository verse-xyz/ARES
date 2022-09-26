// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title TokenTypes
/// @author neuroswish
/// @notice Types for the token contract
interface TokenTypes {
    /// @notice Token configuration settings
    /// @param image The image contract
    /// @param creator The hyperimage creator
    /// @param targetPrice The target price for a token if sold on pace, scaled by 1e18
    /// @param priceDecayPercent Percent price decrease per unit of time, scaled by 1e18
    /// @param perTimeUnit The total number of tokens to target selling every full unit of time
    struct Config {
        address image;
        address creator;
        int256 targetPrice;
        int256 priceDecayPercent;
        int256 perTimeUnit;
    }
}
