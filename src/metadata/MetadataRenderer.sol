// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {IMetadataRenderer} from "../interfaces/IMetadataRenderer.sol";
import {SharedNFTLogic} from "../utils/SharedNFTLogic.sol";
import {MetadataRenderAdminCheck} from "../metadata/MetadataRenderAdminCheck.sol";

contract MetadataRenderer is IMetadataRenderer, MetadataRenderAdminCheck {
  /// @notice Storage for token information
  struct TokenInfo {
    uint256 tokenId;
    string description;
    string imageURI;
    string animationURI;
  }

  /// @notice Event for updated media URIs
  event MediaURIsUpdated(
    address indexed target,
    address sender,
    uint256 tokenId,
    string imageURI,
    string animationURI
  );

  /// @notice Event for a new token initialized
  /// @dev Admin function indexer feedback
  event TokenInitialized(
    address indexed target,
    uint256 tokenId,
    string description,
    string imageURI,
    string animationURI
  );

  /// @notice Description updated for this token
  event DescriptionUpdated(
    address indexed target,
    address sender,
    uint256 tokenId,
    string newDescription
  );

  /// @notice Token information mapping storage
  /// @dev keccak256(abi.encodePacked(target, tokenId))
  mapping(bytes32 => TokenInfo) public tokenInfos;

  /// @notice Reference to shared NFT logic library
  SharedNFTLogic private immutable sharedNFTLogic;

  /// @notice Constructor for library
  /// @param _sharedNFTLogic reference to shared NFT logic library
  constructor(SharedNFTLogic _sharedNFTLogic) {
    sharedNFTLogic = _sharedNFTLogic;
  }

  /// @notice Update media URIs
  /// @param target target for contract to update metadata for
  /// @param tokenId tokenId for target contract token to update metadata for
  /// @param imageURI new image URI address
  /// @param animationURI new animation URI address
  function updateMediaURIs(
    address target,
    uint256 tokenId,
    string memory imageURI,
    string memory animationURI
  ) external requireSenderAdmin(target) {
    bytes32 tokenSpec = keccak256(abi.encodePacked(target,tokenId));
    tokenInfos[tokenSpec].imageURI = imageURI;
    tokenInfos[tokenSpec].animationURI = animationURI;
    emit MediaURIsUpdated({
      target: target, 
      sender: msg.sender, 
      tokenId: tokenId, 
      imageURI: imageURI, 
      animationURI: animationURI
    });
  }
}