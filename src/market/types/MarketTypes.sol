// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface MarketTypes {
  /// @notice The settings type
  /// @param totalSupply The number of tokens minted
  /// @param metadatarenderer The token metadata renderer
  struct MarketConfig {
      int256 targetPrice;
      int256 priceDecayPercent;
      int256 perTimeUnit;
  }
}