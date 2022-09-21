// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {IPublicSharedMetadata} from "../../interfaces/IPublicSharedMetadata.sol";

/// NFT metadata library for rendering metadata associated with editions
library MetadataRenderer {
    /// Generate edition metadata from storage information as base64-json blob
    /// Combines the media data and metadata
    /// @param name Name of NFT in metadata
    /// @param imageURI URL of image to render for edition
    /// @param creator Token ID for specific token
    /// @param provenanceCount Size of entire edition to show
    function createMetadata(string memory name, string memory imageURI, address creator, uint256 provenanceCount)
        internal
        pure
        returns (string memory)
    {
        bytes memory json = createMetadataJSON(name, imageURI, creator, provenanceCount);
        return encodeMetadataJSON(json);
    }

    /// Function to create the metadata json string for the nft edition
    /// @param name Name of NFT in metadata
    /// @param imageURI Description of NFT in metadata
    /// @param creator Token ID for specific token
    /// @param provenanceCount Size of entire edition to show
    function createMetadataJSON(string memory name, string memory imageURI, address creator, uint256 provenanceCount)
        internal
        pure
        returns (bytes memory)
    {
        return abi.encodePacked(
            '{"name": "',
            name,
            '", "image": "',
            imageURI,
            '", "creator": "',
            Strings.toHexString(uint256(uint160(creator)), 20),
            '", "provenanceCount": "',
            Strings.toString(provenanceCount),
            '"}'
        );
    }

    /// Encodes the argument json bytes into base64-data uri format
    /// @param json Raw json to base64 and turn into a data-uri
    function encodeMetadataJSON(bytes memory json) internal pure returns (string memory) {
        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(json)));
    }
}
