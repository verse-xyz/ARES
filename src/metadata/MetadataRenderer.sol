// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {IMetadataRenderer} from "../interfaces/IMetadataRenderer.sol";
import {IHyperobject} from "../interfaces/IHyperobject.sol";
import {IERC1155MetadataURIUpgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC1155MetadataURIUpgradeable.sol";
import {SharedNFTLogic} from "../utils/SharedNFTLogic.sol";
import {MetadataRenderAdminCheck} from "../metadata/MetadataRenderAdminCheck.sol";

contract MetadataRenderer is IMetadataRenderer, MetadataRenderAdminCheck {
  /// @notice Storage for token information
  struct TokenInfo {
    uint256 tokenId;
    string name;
    string description;
    string imageUrl;
    string animationUrl;
  }

  /// @notice Event for updated media Urls
  event MediaUrlsUpdated(
    address indexed target,
    address sender,
    uint256 tokenId,
    string imageUrl,
    string animationUrl
  );

  /// @notice Event for a new token initialized
  /// @dev Admin function indexer feedback
  event TokenInitialized(
    address indexed target,
    uint256 tokenId,
    string name,
    string description,
    string imageUrl,
    string animationUrl
  );

  /// @notice Description updated for this token
  event DescriptionUpdated(
    address indexed target,
    address sender,
    uint256 tokenId,
    string newDescription
  );

  /// @notice Name updated for this token
  event NameUpdated(
    address indexed target,
    address sender,
    uint256 tokenId,
    string newName
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

  /// @notice Admin function to update media Urls
  /// @param target target for contract to update metadata for
  /// @param tokenId tokenId for target contract token to update metadata for
  /// @param imageUrl new image Url address
  /// @param animationUrl new animation Url address
  function updateMediaUrls(
    address target,
    uint256 tokenId,
    string memory imageUrl,
    string memory animationUrl
  ) external requireSenderAdmin(target) {
    bytes32 tokenSpec = keccak256(abi.encodePacked(target,tokenId));
    tokenInfos[tokenSpec].imageUrl = imageUrl;
    tokenInfos[tokenSpec].animationUrl = animationUrl;
    emit MediaUrlsUpdated({
      target: target, 
      sender: msg.sender, 
      tokenId: tokenId, 
      imageUrl: imageUrl, 
      animationUrl: animationUrl
    });
  }

  /// @notice Admin function to update description
  /// @param target target for contract to update description for
  /// @param tokenId tokenId for target contract to update description for
  /// @param newDescription new description
  function updateDescription(address target, uint256 tokenId, string memory newDescription)
    external
    requireSenderAdmin(target)
    {
      bytes32 tokenSpec = keccak256(abi.encodePacked(target,tokenId));
      tokenInfos[tokenSpec].description = newDescription;

      emit DescriptionUpdated({
        target: target,
        tokenId: tokenId,
        sender: msg.sender,
        newDescription: newDescription
      });
    }

    /// @notice Admin function to update name
    /// @param target target for contract to update name for
    /// @param tokenId tokenId for target contract to update name for
    /// @param newName new name
    function updateName(address target, uint256 tokenId, string memory newName)
      external
      requireSenderAdmin(target)
      {
        bytes32 tokenSpec = keccak256(abi.encodePacked(target,tokenId));
        tokenInfos[tokenSpec].name = newName;

        emit NameUpdated({
          target: target,
          tokenId: tokenId,
          sender: msg.sender,
          newName: newName
        });
      }

  /// @notice Default initializer for token data from a specific contract
  /// @param data data to init with
  function initializeWithData(bytes memory data, uint256 tokenId) external {
    // data format: name, description, imageUrl, animationUrl
    (
      string memory name,
      string memory description,
      string memory imageUrl,
      string memory animationUrl
    ) = abi.decode(data, (string, string, string, string));

    bytes32 tokenSpec = keccak256(abi.encodePacked(msg.sender,tokenId));
    tokenInfos[tokenSpec] = TokenInfo({
      tokenId: tokenId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      animationUrl: animationUrl
    });

    emit TokenInitialized({
      target: msg.sender,
      tokenId: tokenId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      animationUrl: animationUrl
    });
  }

  /// @notice Token URI information getter
  /// @param tokenId to get URI for
  /// @return contract URI (if set)
  function tokenURI(uint256 tokenId)
    external
    view
    override
    returns (string memory) {
      address target = msg.sender;

      bytes32 tokenSpec = keccak256(abi.encodePacked(target,tokenId));
      TokenInfo memory info = tokenInfos[tokenSpec];
      IHyperobject hyperobject = IHyperobject(msg.sender);

      // For uncapped supply, this value will be 0
      uint256 maxSupply = hyperobject.marketDetails().maxSupply;
      
      return sharedNFTLogic.createMetadata({
        name: info.name,
        description: info.description,
        imageUrl: info.imageUrl,
        animationUrl: info.animationUrl,
        tokenId: info.tokenId,
        maxSupply: maxSupply
      });
    }
}