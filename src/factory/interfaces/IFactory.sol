// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { IOwnable } from "../../interfaces/IOwnable.sol";
import { FactoryTypes } from "../types/FactoryTypes.sol";

interface IFactory is FactoryTypes {
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
