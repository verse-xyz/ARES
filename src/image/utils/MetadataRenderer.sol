// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";

/// @title MetadataRenderer
/// @author neuroswish
/// @notice Library for rendering hyperimage metadata
library MetadataRenderer {
    /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Create metadata for a token
    /// @param name The image name
    /// @param imageURI The imageURI
    /// @param creator The image creator
    /// @param provenanceCount The image's provenance count
    /// @return The metadata for the token
    function createMetadata(string memory name, string memory imageURI, address creator, uint256 provenanceCount)
        internal
        pure
        returns (string memory)
    {
        bytes memory json = createMetadataJSON(name, imageURI, creator, provenanceCount);
        return encodeMetadataJSON(json);
    }

    /// @notice Create the metadata JSON string for a hyperimage
    /// @param name The image name
    /// @param imageURI The imageURI
    /// @param creator The image creator
    /// @param provenanceCount The image's provenance count
    /// @return The metadata JSON for the token
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
    /// @notice Encode JSON bytes into base64-data URI format
    /// @param json Raw JSON to base64 and turn into a data URI
    /// @return The base64 data URI
    function encodeMetadataJSON(bytes memory json) internal pure returns (string memory) {
        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(json)));
    }
}
