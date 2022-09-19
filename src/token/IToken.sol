// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { IImage } from "../interfaces/IImage.sol";
import { TokenTypes } from "./types/TokenTypes.sol";

/// @notice Interface for Verse Hyperobject Contract
interface IToken {
    // ======== Access Errors ========

    /// @notice Only admin can access this function
    error Access_OnlyAdmin();
    /// @notice Missing the given role or admin access
    error Access_MissingRoleOrAdmin(bytes32 role);

    // ======== Admin Errors ========

    /// @notice Reward percentage too high
    error Setup_RewardPercentageTooHigh(uint16 maxRoyaltyBPS);
    /// @notice Invalid admin upgrade address
    error Admin_InvalidUpgradeAddress(address proposedAddress);

    // ======== Market Errors ========

    // ======== Events ========

    // ======== Structs ========

    /// @notice Configuration for token
    /// @param initStrings The encoded token name, symbol, foundational image uri, foundational image caption
    struct TokenConfiguration {
        bytes initStrings;
    }

    /// @notice Market states and configuration
    /// @dev Uses 1 storage slot
    struct MarketConfiguration {
        /// @notice Starting token price
        //TODO check if this is ok to be uint128
        int256 targetPrice;
        int256 priceDecreasePercent;
        int256 perTimeUnit;
        /// @dev Creator reward percentage in basis points
        uint16 rewardBPS;
        /// @dev Reward recipient (new slot, uint160)
        address payable rewardRecipient;
    }

    /// @notice Return value for market details to use with UIs
    struct MarketDetails {
        // Supply params
        /// @dev Total supply in circulation
        uint256 totalSupply;
        // Price params
        int256 targetPrice;
        int256 priceDecreasePercent;
        int256 perTimeUnit;
        int256 currentPrice;
    }

    // ======== Functions ========

    /// @dev Getter for admin role associated with the contract to handle metadata
    /// @return boolean if address is admin
    function isAdmin(address user) external view returns (bool);

    /// @notice This is the public owner setting that can be set by the contract admin
    function owner() external view returns (address);

    /// @notice Function to return global market details for contract
    function marketDetails() external view returns (MarketDetails memory);

    /// @notice Update the metadata renderer
    /// @param newRenderer new address for renderer
    /// @param setupRenderer data to call to bootstrap data for the new renderer (optional)
    function setMetadataRenderer(IMetadataRenderer newRenderer, bytes memory setupRenderer) external;

    function knit() external payable returns (uint256);

    function mirror() external payable returns (uint256);

    function burn(uint256 tokenId) external returns (uint256);
}
