// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @notice Factory Storage
/// @author neuroswish
/// @notice Factory storage contract
contract FactoryStorage {
    /// @notice Allowed addresses to write to universal image storage
    mapping(address => bool) internal authorizedUIS;
}
