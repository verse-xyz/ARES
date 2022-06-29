// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;

interface IMetadataRenderer {
  function tokenURI(uint256) external view returns (string memory);
  function contractURI() external view returns (string memory);
  function initializeWithData(bytes memory initData) external;
}