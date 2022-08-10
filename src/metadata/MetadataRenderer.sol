// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {IMetadataRenderer} from "../interfaces/IMetadataRenderer.sol";
import {IHyperobject} from "../interfaces/IHyperobject.sol";
import {IERC721MetadataUpgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC721MetadataUpgradeable.sol";
import {SharedNFTLogic} from "../utils/SharedNFTLogic.sol";
import {MetadataRenderAdminCheck} from "../metadata/MetadataRenderAdminCheck.sol";

contract MetadataRenderer is IMetadataRenderer, MetadataRenderAdminCheck {
  /// @notice Storage for token information
  struct TokenInfo {
    uint256 tokenId;
    string name;
    string description;
    address creator;
    
  }

  /// @notice Event for updated media URIs
  event tokenKnitted(
    address indexed target,
    address sender,
    uint256 tokenId,
    string knitURI
  );

  /// @notice Event for a new token initialized
  /// @dev Admin function indexer feedback
  event TokenInitialized(
    address indexed target,
    string name,
    string description,
    string initialURI
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
  mapping(address => TokenInfo) public tokenInfos;

  /// @notice Reference to shared NFT logic library
  SharedNFTLogic private immutable sharedNFTLogic;

  /// @notice Constructor for library
  /// @param _sharedNFTLogic reference to shared NFT logic library
  constructor(SharedNFTLogic _sharedNFTLogic) {
    sharedNFTLogic = _sharedNFTLogic;
  }

  /// @notice Admin function to update media URIs
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
    tokenInfos[target].imageURI = imageURI;
    tokenInfos[target].animationURI = animationURI;
    emit MediaURIsUpdated({
      target: target, 
      sender: msg.sender, 
      tokenId: tokenId, 
      imageURI: imageURI, 
      animationURI: animationURI
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
      tokenInfos[target].description = newDescription;

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
        tokenInfos[target].name = newName;

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
    // data format: name, description, imageURI, animationURI
    (
      string memory name,
      string memory description,
      string memory imageURI,
      string memory animationURI
    ) = abi.decode(data, (string, string, string, string));
    tokenInfos[msg.sender] = TokenInfo({
      tokenId: tokenId,
      name: name,
      description: description,
      imageURI: imageURI,
      animationURI: animationURI
    });

    emit TokenInitialized({
      target: msg.sender,
      tokenId: tokenId,
      name: name,
      description: description,
      imageURI: imageURI,
      animationURI: animationURI
    });
  }

  /// @notice Contract URI information getter
  /// @return contract uri (if set)
  function contractURI() external view override returns (string memory) {
    address target = msg.sender;
    bytes memory imageSpace = bytes("");
    if (bytes(tokenInfos[target].imageURI).length > 0) {
      imageSpace = abi.encodePacked(
        '", "image": "',
        tokenInfos[target].imageURI
      );
    }
    return string(
      sharedNFTLogic.encodeMetadataJSON(
        abi.encodePacked(
          '{"name": "',
          IERC721MetadataUpgradeable(target).name(),
          '", "description": "',
          tokenInfos[target].description,
          imageSpace,
          '"}'
        )
      )
    );
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
      TokenInfo memory info = tokenInfos[target];
      
      return sharedNFTLogic.createMetadata({
        name: info.name,
        description: info.description,
        imageUrl: info.imageURI,
        animationUrl: info.animationURI,
        tokenId: tokenId
      });
    }
}