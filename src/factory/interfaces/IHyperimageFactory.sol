// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { IUUPS } from "../../interfaces/IUUPS.sol";
import { IOwnable } from "../../interfaces/IOwnable.sol";

interface HyperimageFactory is IUUPS, IOwnable {
  /*//////////////////////////////////////////////////////////////
                              EVENTS
  //////////////////////////////////////////////////////////////*/

  /// @notice Emitted when a hyperimage is deployed
  /// @param token The ERC-721 token address
  /// @param image The image rendering address

  event HyperimageDeployed(address token, address image);

  /// @notice Emitted when an upgrade is registered by Verse
  /// @param base The base implementation address
  /// @param upgrade The upgrade implementation address
  event UpgradeRegistered(address base, address upgrade);

  /// @notice Emitted when an upgrade is unregistered by Verse
  /// @param base The base implementation address
  /// @param upgrade The upgrade implementation address
  event UpgradeRemoved(address base, address upgrade);

  /*//////////////////////////////////////////////////////////////
                              ERRORS
  //////////////////////////////////////////////////////////////*/

  /*//////////////////////////////////////////////////////////////
                              STRUCTS
  //////////////////////////////////////////////////////////////*/

  /// @notice The ERC-721 token parameters
  /// @param initStrings The encoded token name, symbol, collection description, collection image uri, renderer base uri
  /// @param targetPrice The target price for a token if sold on pace, scaled by 1e18.
  /// @param priceDecreasePercent Percent price decrease per unit of time, scaled by 1e18.
  /// @param perTimeUnit The number of tokens to target selling in 1 full unit of time, scaled by 1e18.
  struct TokenParams {
    bytes initStrings;
    int256 targetPrice;
    int256 priceDecayPercent;
    int256 perTimeUnit;
  }

  /// @notice The Image parameters
  /// @param initStrings The encoded token name, symbol, collection description, collection image uri, renderer base uri
  struct ImageParams {
    bytes initStrings;
  }
}