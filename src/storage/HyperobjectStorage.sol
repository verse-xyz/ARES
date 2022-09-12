// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {IHyperobject} from "../interfaces/IHyperobject.sol";

contract HyperobjectStorage {
  /// @notice Configuration for NFT minting contract storage
  IHyperobject.Configuration public config;

  /// @notice Market configuration
  IHyperobject.MarketConfiguration public marketConfig;

}