// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;


/// @title IToken
/// @author neuroswish
/// @notice Token errors, events, and functions
interface IToken {
    /*//////////////////////////////////////////////////////////////
                            ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @dev Reverts if the caller was not the factory contract
    error ONLY_FACTORY();

    /// @dev Reverts if the caller was not the token owner
    error ONLY_OWNER();

    /// @dev Reverts if the caller was not the hyperimage creator
    error ONLY_CREATOR();

    /// @dev Reverts if the contract contains insufficient reserves
    error INSUFFICIENT_RESERVES();

    /// @dev Reverts if the caller underpays
    error UNDERPAID();

    /*//////////////////////////////////////////////////////////////
                            EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted when a new token is knitted
    /// @param tokenId The ID of the knitted token
    /// @param creator The image creator/knitter
    /// @param imageHash The image hash
    /// @param imageURI The imageURI
    /// @param price The price paid to knit the token
    event Knitted(uint256 tokenId, address creator, bytes32 imageHash, string imageURI, uint256 price);

    /// @notice Emitted when a new token is mirrored
    /// @param tokenId The ID of the mirrored token
    /// @param mirrorer The mirrorer
    /// @param imageHash The image hash of the mirrored token
    /// @param imageURI The image URI of the mirrored token
    /// @param price The price paid to mirror the token
    event Mirrored(uint256 tokenId, address mirrorer, bytes32 imageHash, string imageURI, uint256 price);

    /// @notice Emitted when a token is burned
    /// @param tokenId The ID of the burned token
    /// @param burner The burner
    /// @param imageHash The image hash of the burned token
    /// @param imageURI The image URI of the burned token
    /// @param price The price received for burning the token
    event Burned(uint256 tokenId, address burner, bytes32 imageHash, string imageURI, uint256 price);

    /// @notice Emitted when the creator redeems reward ETH
    /// @param redeemer The redeeming address
    /// @param amount The ETH amount redeemed by the creator
    event Redeemed(address redeemer, uint256 amount);

    /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Initializes a hyperimage's token contract 
    /// @param _initStrings The encoded token and metadata initialization strings
    /// @param _creator The hyperimage creator
    /// @param _image The image contract address
    /// @param _targetPrice The target price for a token if sold on pace, scaled by 1e18
    /// @param _priceDecayPercent Percent price decrease per unit of time, scaled by 1e18
    /// @param _perTimeUnit The total number of tokens to target selling every full unit of time
    /// @dev Only callable by the factory contract
    function initialize(
        bytes calldata _initStrings,
        address _creator,
        address _image,
        int256 _targetPrice,
        int256 _priceDecayPercent,
        int256 _perTimeUnit
    ) external;

    /// @notice Knit a new token to the hyperimage
    /// @param imageURI The URI of the image to knit
    /// @return tokenId The ID of the newly knitted token
    function knit(string memory imageURI) external payable returns (uint256 tokenId);

    /// @notice Mirror a new token to the hyperimage
    /// @param imageHash The hash of the image to mirror
    /// @return tokenId The ID of the newly mirrored token
    function mirror(bytes32 imageHash) external payable returns (uint256 tokenId);

    /// @notice Burn a hyperimage token
    /// @param tokenId The ID of the token to burn
    /// @dev Only callable by token owner
    function burn(uint256 tokenId) external;
    
    /// @notice Redeem reward ETH
    /// @dev Only callable by hyperimage creator
    function redeem() external;

    /// @notice The URI for a token
    /// @param tokenId The ERC-721 token id
    function tokenURI(uint256 tokenId) external view returns (string memory);

    /// @notice The URI for the contract
    function contractURI() external view returns (string memory);

    /// @notice The circulating supply of tokens
    function getSupply() external view returns (uint256);

    /// @notice The current token price
    function getPrice() external view returns (uint256);

    /// @notice The image contract address
    function getImage() external view returns (address);

    /// @notice The hyperimage creator
    function getCreator() external view returns (address);
}
