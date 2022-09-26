// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { TokenTypes } from "../types/TokenTypes.sol";

/// @title TokenStorage
/// @author neuroswish
/// @notice The token storage contract
contract TokenStorage is TokenTypes {
    /// @notice Token config
    Config internal config;

    /// @notice Boolean tracking whether a token is a mirror
    mapping(uint256 => bool) internal tokenIsMirror;
}
