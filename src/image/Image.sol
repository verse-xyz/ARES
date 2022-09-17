// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {IImage} from "../interfaces/IImage.sol";
import {MetadataRenderAdminCheck} from "../metadata/MetadataRenderAdminCheck.sol";
import {NFTMetadataRenderer} from "../utils/NFTMetadataRenderer.sol";
import {IHyperobject} from "../interfaces/IHyperobject.sol";
import {Hyperobject} from "../Hyperobject.sol";

contract Image is IImage {
  // this is how we're going to render metadata for a given token
  // each token is going to have a name (common), image, caption, like data hash, comment data hash, creator, and an owner
  // we also need a mirror counter

  struct tokenInfo {
    uint256 tokenId;
    string name;
    string imageURI;
    address creator;
    address owner;
    string likesURI;
    string commentsURI;
  }

  /// @notice Storage for token information
  mapping (uint256 => tokenInfo) public tokenInfos;

  // we're going to store the address of the hyperobject contract
  Hyperobject public immutable source;

  constructor(
    IHyperobject _source
  ) {
    source = Hyperobject(payable(address(_source)));
  }

  // what do we need in this contract?
  // in the knit function the caller passes in the relevant data and then we store it in the tokenInfo mapping

  
}