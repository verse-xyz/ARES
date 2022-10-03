// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface IFactory {
  /*//////////////////////////////////////////////////////////////
                            ERRORS
  //////////////////////////////////////////////////////////////*/

  /// @dev Reverts if token params are invalid
  error INVALID_TOKEN_PARAMS();

  /*//////////////////////////////////////////////////////////////
                            EVENTS
  //////////////////////////////////////////////////////////////*/

  /// @notice Emitted when a hyperimage is deployed
  /// @param token The ERC-721 token address
  /// @param image The image rendering address
  event HyperimageDeployed(address token, address image);

  /*//////////////////////////////////////////////////////////////
                            STRUCTS
  //////////////////////////////////////////////////////////////*/

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

  /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
  //////////////////////////////////////////////////////////////*/

  /// @notice Initializes the factory contract
  /// @param _token The token implementation address
  /// @param _image The image implementation address
  /// @param _universalImageStorage The universal image storage address
  function initialize(address _token, address _image, address _universalImageStorage) external;
  
  /// @notice Deploys a hyperimage
  /// @param _tokenParams The hyperimage token parameters
  /// @return token The ERC-721 token address
  /// @return image The image rendering address
  function deploy(TokenParams calldata _tokenParams) external returns (address token, address image);

  /// @notice Return a hyperimage's contracts
  /// @param _token The hyperimage's token address
  /// @return image The hyperimage's image rendering address
  function getAddresses(address _token) external view returns (address image);

  /// @notice Return authorization status of a contract to write to universal image storage
  /// @param _address The contract address
  function isAuthorized(address _address) external view returns (bool);
}
