// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @notice Factory Storage
/// @author neuroswish
/// @notice Factory storage contract
contract FactoryStorage {
    /// @notice If a contract has been registered as an upgrade
    /// @dev Base impl => Upgrade impl
    mapping(address => mapping(address => bool)) internal isUpgrade;
}
