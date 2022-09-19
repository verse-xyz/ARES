// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface ImageTypes {
  struct image {
    uint256 tokenId;
    string imageURI;
    address creator;
    address owner;
    string interactionsURI;
    bytes32 contentHash;
  }
}