// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { IOwnable } from "../../interfaces/IOwnable.sol";

interface IFactory is IOwnable {
    /*//////////////////////////////////////////////////////////////
                              EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted when a hyperimage is deployed
    /// @param token The ERC-721 token address
    /// @param image The image rendering address
    event HyperimageDeployed(address token, address image);

    /*//////////////////////////////////////////////////////////////
                              STRUCTS
    //////////////////////////////////////////////////////////////*/

    /// @notice The hyperimage token parameters
    /// @param initStrings The encoded token name and initializing image URI
    /// @param targetPrice The target price for a token if sold on pace, scaled by 1e18.
    /// @param priceDecreasePercent Percent price decrease per unit of time, scaled by 1e18.
    /// @param perTimeUnit The number of tokens to target selling in 1 full unit of time, scaled by 1e18.
    struct TokenParams {
        bytes initStrings;
        int256 targetPrice;
        int256 priceDecayPercent;
        int256 perTimeUnit;
    }
}
