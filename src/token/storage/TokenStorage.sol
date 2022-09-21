// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { TokenTypes } from "../types/TokenTypes.sol";

contract TokenStorage is TokenTypes {
    /// @notice Token config
    Config internal config;
}