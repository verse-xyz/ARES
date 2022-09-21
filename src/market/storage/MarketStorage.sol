// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { MarketTypes } from "../types/MarketTypes.sol";

contract MarketStorage is MarketTypes {
    /// @notice Market settings
    MarketConfig internal marketConfig;
}