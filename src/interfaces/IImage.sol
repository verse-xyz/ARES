// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface IImage {
  function tokenURI(uint256) external view returns (string memory);
  function contractURI() external view returns (string memory);
  function initializeWithData(bytes memory data, uint256) external;
}