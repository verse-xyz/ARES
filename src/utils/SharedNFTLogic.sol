// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {StringsUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {IPublicSharedMetadata} from "../interfaces/IPublicSharedMetadata.sol";

/// Shared NFT logic for rendering metadata
/// @dev Can safely be used for generic base64Encode and numberToString functions

contract SharedNFTLogic is IPublicSharedMetadata {
  /// @param unencoded bytes to base64-encode
    function base64Encode(bytes memory unencoded)
        public
        pure
        override
        returns (string memory)
    {
        return Base64.encode(unencoded);
    }

    /// Proxy to openzeppelin's toString function
    /// @param value number to return as a string
    function numberToString(uint256 value)
        public
        pure
        override
        returns (string memory)
    {
        return StringsUpgradeable.toString(value);
    }

    /// Generates NFT metadata from storage information as base64-json blob
    /// Combines the media data and metadata
    /// @param imageUrl URL of image to render
    /// @param animationUrl URL of animation to render
    function tokenMediaData(
        string memory imageUrl,
        string memory animationUrl,
        uint256 tokenId
    ) public pure returns (string memory) {
        bool hasImage = bytes(imageUrl).length > 0;
        bool hasAnimation = bytes(animationUrl).length > 0;
        if (hasImage && hasAnimation) {
            return
                string(
                    abi.encodePacked(
                        'image": "',
                        imageUrl,
                        "?id=",
                        numberToString(tokenId),
                        '", "animation_url": "',
                        animationUrl,
                        "?id=",
                        numberToString(tokenId),
                        '", "'
                    )
                );
        }
        if (hasImage) {
            return
                string(
                    abi.encodePacked(
                        'image": "',
                        imageUrl,
                        "?id=",
                        numberToString(tokenId),
                        '", "'
                    )
                );
        }
        if (hasAnimation) {
            return
                string(
                    abi.encodePacked(
                        'animation_url": "',
                        animationUrl,
                        "?id=",
                        numberToString(tokenId),
                        '", "'
                    )
                );
        }

        return "";
    }

    /// Function to create the metadata json string for the nft 
    /// @param name Name of NFT in metadata
    /// @param description Description of NFT in metadata
    /// @param mediaData Data for media to include in json object
    /// @param tokenId Token ID for specific token
    /// @param maxSupply Max supply of token to show
    function createMetadataJSON(
        string memory name,
        string memory description,
        string memory mediaData,
        uint256 tokenId,
        uint256 maxSupply
    ) public pure returns (bytes memory) {
        bytes memory maxSupplyText;
        if (maxSupply > 0) {
            maxSupplyText = abi.encodePacked(
                numberToString(maxSupply)
            );
        }
        return
            abi.encodePacked(
                '{"name": "',
                name,
                '", "',
                'description": "',
                description,
                '", "',
                mediaData,
                'properties": {"tokenId": ',
                numberToString(tokenId),
                ', "maxTotalSupply": "',
                maxSupplyText,
                ', "name": "',
                name,
                '"}}'
            );
    }

    /// Generate metadata from storage information as base64-json blob
    /// Combines the media data and metadata
    /// @param name Name of NFT in metadata
    /// @param description Description of NFT in metadata
    /// @param imageUrl URL of image to render
    /// @param animationUrl URL of animation to render
    /// @param tokenId Token ID for object
    /// @param maxSupply Size of entire edition to show
    function createMetadata(
        string memory name,
        string memory description,
        string memory imageUrl,
        string memory animationUrl,
        uint256 tokenId,
        uint256 maxSupply
    ) external pure returns (string memory) {
        string memory _tokenMediaData = tokenMediaData(
            imageUrl,
            animationUrl,
            tokenId
        );
        bytes memory json = createMetadataJSON(
            name,
            description,
            _tokenMediaData,
            tokenId,
            maxSupply
        );
        return encodeMetadataJSON(json);
    }


    /// Encodes the argument json bytes into base64-data uri format
    /// @param json Raw json to base64 and turn into a data-uri
    function encodeMetadataJSON(bytes memory json)
        public
        pure
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    base64Encode(json)
                )
            );
    }
}