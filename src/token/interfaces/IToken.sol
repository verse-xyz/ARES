// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { IImage } from "../../image/interfaces/IImage.sol";
import { TokenTypes } from "../types/TokenTypes.sol";
import { IHyperimageFactory } from "../../factory/interfaces/IHyperimageFactory.sol";

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

    /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @dev Getter for admin role associated with the contract to handle metadata
    /// @return boolean if address is admin
    function isAdmin(address user) external view returns (bool);

    /// @notice This is the public owner setting that can be set by the contract admin
    function owner() external view returns (address);

    // /// @notice Update the metadata renderer
    // /// @param newRenderer new address for renderer
    // /// @param setupRenderer data to call to bootstrap data for the new renderer (optional)
    // function setMetadataRenderer(IMetadataRenderer newRenderer, bytes memory setupRenderer) external;

    function initialize(
        bytes calldata initStrings,
        address creator,
        address image,
        int256 targetPrice,
        int256 priceDecayPercent,
        int256 perTimeUnit
    ) external;

    function knit() external payable returns (uint256);

    function mirror() external payable returns (uint256);

    function burn(uint256 tokenId) external;
}
