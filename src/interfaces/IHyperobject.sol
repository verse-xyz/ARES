// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {IMetadataRenderer} from "./IMetadataRenderer.sol";

/// @notice Interface for Verse Hyperobject Contract
interface IHyperobject {
    // ======== Access Errors ========

    /// @notice Only admin can access this function
    error Access_OnlyAdmin();
    /// @notice Missing the given role or admin access
    error Access_MissingRoleOrAdmin(bytes32 role);

    // ======== Admin Errors ========

    /// @notice Royalty percentage too high
    error Setup_RoyaltyPercentageTooHigh(uint16 maxRoyaltyBPS);
    /// @notice Invalid admin upgrade address
    error Admin_InvalidUpgradeAddress(address proposedAddress);

    // ======== Events ========

    // ======== Structs ========
    /// @notice Configuration for NFT Market
    struct Configuration {
        /// @dev Metadata renderer
        IMetadataRenderer metadataRenderer;
        /// @dev Transaction royalty bps
        uint16 royaltyBPS;
        /// @dev Royalty recipient
        address payable royaltyRecipient;
    }

    /// @notice Market states and configuration
    /// @dev Uses 1 storage slot
    struct MarketConfiguration {
        /// @notice Starting token price
        //TODO check if this is ok to be uint128
        uint256 startingPrice;
    } 

    /// @notice Return value for market details to use with UIs
    struct MarketDetails {
        // Supply params
        /// @dev Total supply in circulation
        uint256 totalSupply;
        // Price params
        uint256 startingPrice;

    }

    // ======== Functions ========

    /// @dev Getter for admin role associated with the contract to handle metadata
    /// @return boolean if address is admin
    function isAdmin(address user) external view returns (bool);

    /// @notice Function to return global market details for contract
    function marketDetails() external view returns (MarketDetails memory);
}