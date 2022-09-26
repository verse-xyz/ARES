// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {IUUPS} from "../../interfaces/IUUPS.sol";
import {IOwnable} from "../../interfaces/IOwnable.sol";

/// @title IImage
/// @author neuroswish
/// @notice Image errors, events, and functions
interface IImage {
    /*//////////////////////////////////////////////////////////////
                            ERRORS
    //////////////////////////////////////////////////////////////*/
    /// @dev Reverts if the caller was not the associated token contract
    error ONLY_TOKEN();

    /// @dev Reverts if an image hash already exists
    error EXISTING_IMAGE();

    /// @dev Reverts if an image hash does not exist
    error NONEXISTENT_IMAGE();

    /*//////////////////////////////////////////////////////////////
                            EVENTS
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    /// @notice Initializes a hyperimage's image contract
    /// @param initStrings The encoded token and metadata initialization strings
    /// @param token The associated ERC-721 token address
    function initialize(bytes calldata initStrings, address creator, address token) external;

    /// @notice The token URI
    /// @param tokenId The ERC-721 token id
    function tokenURI(uint256 tokenId) external view returns (string memory);

    /// @notice The contract URI
    function contractURI() external view returns (string memory);

    /// @notice The associated token contract
    function token() external view returns (address); 
}
