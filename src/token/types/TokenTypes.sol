// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { IImage } from "../../interfaces/IImage.sol";

interface TokenTypes {
  /// @notice The settings type
  /// @param totalSupply The number of tokens minted
  /// @param metadatarenderer The token metadata renderer
  struct Settings {
      uint256 totalSupply;
      //IBaseMetadata metadataRenderer;
  }
}