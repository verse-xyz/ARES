// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { IOwnable } from "../../interfaces/IOwnable.sol";
import { FactoryTypes } from "../types/FactoryTypes.sol";

interface IFactory is FactoryTypes, IOwnable {
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

  /// @notice Deploys a hyperimage
  /// @param _tokenParams The hyperimage token parameters
  /// @return token The ERC-721 token address
  /// @return image The image rendering address
  function deploy(TokenParams calldata _tokenParams) external returns (address token, address image);

  /// @notice Return a hyperimage's contracts
  /// @param _token The hyperimage's token address
  /// @return image The hyperimage's image rendering address
  function getAddresses(address _token) external view returns (address image);
}
