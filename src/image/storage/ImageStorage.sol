// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { ImageTypes } from "../types/ImageTypes.sol";

/// @title ImageStorage
/// @author neuroswish
/// @notice The image storage contract
contract ImageStorage is ImageTypes {
  /// @notice The image attributes for a token
  mapping(uint256 => image) internal images;

  /// @notice Mirror counts for a content hash
  mapping(bytes32 => uint256) internal mirrors;
}