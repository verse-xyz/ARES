# ARES Protocol Documentation

Documentation for interacting with the ARES Protocol.

## Table of Contents

- [Architecture](#architecture)
- [Interactions](#custom-settings)
- [Subgraph Data](#deploy)
- [Setup](#setup)

## Architecture

```ml
factory
├─ Factory — "Network deployer"
├─ interfaces
│  ├─ IFactory — "Interface for Factory contract"
├─ storage
│  ├─ FactoryStorage — "Storage for Factory contract"
token
├─ Token — "Network token"
├─ interfaces
│  ├─ IToken — "Interface for Token contract"
├─ storage
│  ├─ TokenStorage — "Storage for Token contract"
├─ types
│  ├─ TokenTypes — "Custom data types for Token contract"
image
├─ Image — "Image contract to manage token metadata"
├─ interfaces
│  ├─ IImage — "Interface for Image contract"
│  ├─ IUniversalImageStorage — "Interface for Universal Image Storage contract"
├─ storage
│  ├─ ImageStorage — "Storage for a network's image contract"
│  ├─ UniversalImageStorage — "Universal image registry to store image hashes globallly"
├─ types
│  ├─ Image — "Custom data types for Image contract"
├─ utils
│  ├─ MetadataRenderer — "ERC-721 metadata renderer implementation"
market
├─ ARES — "Automated market for a network's token"
├─ interfaces
│  ├─ IARES — "Interface for ARES contract"
utils
├─ Address — "Address implementation"
├─ EIP721 — "EIP721 implementation"
├─ ERC721 — "ERC721 implementation"
├─ FundsReceiver — "Funds Receiver implementation"
├─ Initializable — "Initializable implementation"
├─ Ownable — "Ownable implementation"
├─ ReentrancyGuard — "Reentrancy Guard implementation"
├─ TokenReceiver — "Token Receiver implementation"
interfaces
├─ IAddress — "Interface for Address implementation"
├─ IEIP721 — "Interface for EIP721 implementation"
├─ IERC721 — "Interface for ERC721 implementation"
├─ IFundsReceiver — "Interface for Funds Receiver implementation"
├─ IInitializable — "Interface for Initializable implementation"
├─ IOwnable — "Interface for Ownable implementation"
├─ IReentrancyGuard — "Interface for Reentrancy Guard implementation"
├─ ITokenReceiver — "Interface for Token Receiver implementation"
```

## Interactions

New networks are deployed through the use of a contract factory implementing a series of proxies.

#### Network deployment parameters

To deploy a new network, call the `deploy` function on the `Factory.sol` contract, supplying the following parameters:

```solidity
 /// @notice The hyperimage token parameters
/// @param initStrings The encoded token name and initializing image URI
/// @param targetPrice The target price for a token if sold on pace, scaled by 1e18
/// @param priceDecreasePercent Percent price decrease per unit of time, scaled by 1e18
/// @param perTimeUnit The number of tokens to target selling in 1 full unit of time, scaled by 1e18
struct TokenParams {
    bytes initStrings;
    int256 targetPrice;
    int256 priceDecayPercent;
    int256 perTimeUnit;
}
```
#### Networks

Deploying a new network will deploy two proxy contracts implementing `Token.sol` and `Image.sol`. The `Token` contract will be the contract which individuals will directly interact with via the `knit`, `mirror`, and `burn` functions. The `Image` contract will operate in the background in tandem with `UniversalImageStorage` to store image hashes and token metadata, tracking the provenance of an image through a network as tokens are knitted, mirrored, and burned. The aforementioned primary `Token` functions are as follows:

```solidity
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
```

The `Token` contract also contains helper functions to query important information about a network's token, such as the current price, circulating supply, and tokenURI for a given token Id.

```solidity
/// @notice The URI for a token
/// @param tokenId The ERC-721 token id
function tokenURI(uint256 tokenId) external view returns (string memory);

/// @notice The URI for the contract
function contractURI() external view returns (string memory);

/// @notice The circulating supply of tokens
function getSupply() external view returns (uint256);

/// @notice The current token price
function getPrice() external view returns (uint256);
```

Combined with data from a network's subgraph, these functions can be used to build a comprehensive interface for interacting with a network. 

#### Image
The `Image` contract for a network contains functions primarily called by the corresponding `Token` contract to manage a network's image metadata. Each image for a network is stored with the following information:

```solidity
/// @notice Full attributes for an image
/// @param imageURI The image URI
/// @param creator The image creator
/// @param imageHash The image hash
/// @param timestamp Timestamp of image creation
struct Image {
    string imageURI;
    address creator;
    uint256 timestamp;
    bytes32 imageHash;
}
```
When a token is knitted or mirrored, the `Image` contract will map the token's ID to the struct, using this information to generate the token's tokenURI.

#### Universal Image Storage
The `UniversalImageStorage` contract is a global registry for all images that are created through the ARES protocol. As each imageHash is a unique hash of the imageURI and the creator, the registry ensures that each image is only stored once to track provenance across networks. This structure also sets up the future possibility of images to be mirrored across networks. 

```solidity
/// @notice Add an image to universal image storage
/// @param imageURI The image URI
/// @param creator The image creator
/// @param imageHash The image hash
/// @param timestamp Timestamp of image creation
function addUniversalImage(string memory imageURI, address creator, bytes32 imageHash, uint256 timestamp) external;

/// @notice Return an image from universal image storage
/// @param imageHash The image hash
function getUniversalImage(bytes32 imageHash) external view returns (Image memory);

/// @notice Get the provenance count for an image
/// @param imageHash The image hash
function getProvenanceCount(bytes32 imageHash) external view returns (uint256);

/// @notice Increment the provenance count for an image
/// @param imageHash The image hash
function incrementProvenanceCount(bytes32 imageHash) external;

/// @notice Decrement the provenance count for an image
/// @param imageHash The image hash
function decrementProvenanceCount(bytes32 imageHash) external;
```
When a token is knitted the `UniversalImageStorage` contract will store the corresponding image hash in the global registry. If this same image is mirrored or burned in the future, the contract will update the image's provenance count accordingly.

## Subgraph Data
A subgraph for the ARES protocol on the Goerli testnet is currently [available](https://api.studio.thegraph.com/query/14759/ares-goerli/v0.0.1) to query. 

Additionally, the protocol contracts can be found on the Goerli testnet at the following addresses:

Factory: https://goerli.etherscan.io/address/0x0ef9f82d527b5d02bd2433e66253c686db770c33
Token: https://goerli.etherscan.io/address/0x44761fec1d1b911fb772b649dc31dbc611a73604
Image: https://goerli.etherscan.io/address/0x047972e161da8605d718eb6cf65e744daa781c09
UniversalImageStorage: https://goerli.etherscan.io/address/0xea0cefb9e3c30c8cd21ad9b9ee47426582fb7c9c

## Setup
Install Dependencies:

```bash
yarn
```

```bash
forge install
```

Run Tests:

```bash
forge test
```

Run Tests with Modifiers:

- (-vv): Logs emitted during tests are also displayed.
- (-vvv): Stack traces for failing tests are also displayed.
- (-vvvv): Stack traces for all tests are displayed, and setup traces for failing tests are displayed.
- (-vvvvv): Stack traces and setup traces are always displayed.

```bash
forge test  -vvvv
```