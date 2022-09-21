// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { UUPS } from "../proxy/UUPS.sol";
import { Ownable } from "../utils/Ownable.sol";
import { ERC1967Proxy } from "../proxy/ERC1967Proxy.sol";

import { IImage } from "../image/interfaces/IImage.sol";
import { IToken } from "../token/interfaces/IToken.sol";
import { IHyperimageFactory } from "./interfaces/IHyperimageFactory.sol";

contract HyperimageFactory is IHyperimageFactory UUPS, Ownable {
  /*//////////////////////////////////////////////////////////////
                          IMMUTABLES
  //////////////////////////////////////////////////////////////*/

  ///@notice The token implementation address
  address public immutable token;

  ///@notice The image implementation address
  address public immutable image;

  /*//////////////////////////////////////////////////////////////
                          CONSTRUCTOR
  //////////////////////////////////////////////////////////////*/
  constructor (
    address _token,
    address _image
  ) payable initializer {
    token = _token;
    image = _image;
  }

  /*//////////////////////////////////////////////////////////////
                          INITIALIZER
  //////////////////////////////////////////////////////////////*/
  /// @notice Initializes ownership of the factory contract
  /// @param _owner The address of the owner (transferred to Verse once deployed)

  function initialize(address _owner) external initializer {
    // Ensure owner is specified
    if (_owner == address(0)) revert ADDRESS_ZERO();

    // Set contract owner
    __Ownable_init(_owner);
  }

  /*//////////////////////////////////////////////////////////////
                          HYPERIMAGE DEPLOY
  //////////////////////////////////////////////////////////////*/
  function deploy(
    // need token params and image params
    TokenPara
  )
}