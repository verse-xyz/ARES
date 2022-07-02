// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface IMetadataRenderer {
  function tokenURI(uint256) external view returns (string memory);
  function initializeWithData(bytes memory data, uint256) external;
}