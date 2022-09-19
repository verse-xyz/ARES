// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { IUUPS } from "../../interfaces/IUUPS.sol";
import { IOwnable } from "../../interfaces/IOwnable.sol";

/// @title IImage
/// @author neuroswish
/// @notice Image errors, events, and functions
interface IImage is IUUPS, IOwnable {

/*//////////////////////////////////////////////////////////////
                            ERRORS
//////////////////////////////////////////////////////////////*/

/*//////////////////////////////////////////////////////////////
                            EVENTS
//////////////////////////////////////////////////////////////*/

/*//////////////////////////////////////////////////////////////
                            FUNCTIONS
//////////////////////////////////////////////////////////////*/
/// @notice Initializes a Token's image contract
/// @param initStrings The encoded token and metadata initialization strings
/// @param token The associated ERC-721 token address
function initialize(
    bytes calldata initStrings,
    address token
) external;

/// @notice The token URI
/// @param tokenId The ERC-721 token id
function tokenURI(uint256 tokenId) external view returns (string memory);

/// @notice The contract URI
function contractURI() external view returns (string memory);

/// @notice The associated token contract
function token() external view returns (address);

}