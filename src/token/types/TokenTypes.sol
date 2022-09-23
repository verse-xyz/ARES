// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface TokenTypes {
    /// @notice The token config type
    /// @param image The address of the associated image contract
    struct Config {
        address image;
        address creator;
        int256 targetPrice;
        int256 priceDecayPercent;
        int256 perTimeUnit;
    }
}
