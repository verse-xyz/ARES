// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { ImageTypes } from "../types/ImageTypes.sol";

/// @title IImage
/// @author neuroswish
/// @notice Image errors, events, and functions
interface IImage is ImageTypes {
    /*//////////////////////////////////////////////////////////////
                            ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @dev Reverts if the caller was not the factory contract
    error ONLY_FACTORY();

    /// @dev Reverts if the caller was not the token contract
    error ONLY_TOKEN();

    /// @dev Reverts if an image hash already exists
    error EXISTING_IMAGE();

    /// @dev Reverts if an image hash does not exist
    error NONEXISTENT_IMAGE();

    /*//////////////////////////////////////////////////////////////
                            EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted when a new image is created
    /// @param creator The image creator
    /// @param imageURI The image URI
    /// @param imageHash The image hash
    /// @param timestamp Timestamp of image creation
    event ImageCreated(address creator, string imageURI, bytes32 imageHash, uint256 timestamp);

    /// @notice Emitted when an image's provenance count is updated
    /// @param imageURI The image URI
    /// @param imageHash The image Hash
    /// @param updatedProvenanceCount The updated provenance count
    event ImageProvenanceCountUpdated(string imageURI, bytes32 imageHash, uint256 updatedProvenanceCount);
    
    /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Initializes a hyperimage's image contract 
    /// @param _initStrings The encoded token and metadata initialization strings
    /// @param _creator The hyperimage creator
    /// @param _token The ERC-721 token address
    /// @dev Only callable by the factory contract
    function initialize(bytes calldata _initStrings, address _creator, address _token) external;

    /// @notice Assign token to a new image
    /// @param tokenId The token being assigned to a new image
    /// @param creator The creator of the new image
    /// @param imageURI The URI of the new image
    /// @dev Only callable by the token contract
    function knitToken(uint256 tokenId, address creator, bytes calldata imageURI) external;

    /// @notice Assign token to an existing, propagating image
    /// @param tokenId The token being assigned to the image
    /// @param imageHash The hash of the image to be mirrored
    /// @dev Only callable by the token contract
    function mirrorToken(uint256 tokenId, bytes32 imageHash) external;

    /// @notice Decrement the provenance count of the image assigned to a token being burned
    /// @param tokenId The token being burned
    function burnToken(uint256 tokenId) external;

    /// @notice Return the URI of a token
    /// @param tokenId The specified token
    function tokenURI(uint256 tokenId) external view returns (string memory);

    /// @notice Return the URI of the token contract
    function contractURI() external view returns (string memory);

    /// @notice Return the address of the token contract
    function token() external view returns (address); 

    /// @notice Return the image attributes assigned to a token
    /// @param tokenId The specified token
    function tokenDetails(uint256 tokenId) external view returns (Image memory);
}
