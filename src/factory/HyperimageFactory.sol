// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { UUPS } from "../proxy/UUPS.sol";
import { Ownable } from "../utils/Ownable.sol";
import { ERC1967Proxy } from "../proxy/ERC1967Proxy.sol";

import { IImage } from "../image/interfaces/IImage.sol";
import { IToken } from "../token/interfaces/IToken.sol";
import { IHyperimageFactory } from "./interfaces/IHyperimageFactory.sol";

contract HyperimageFactory is IHyperimageFactory, UUPS, Ownable {
  /*//////////////////////////////////////////////////////////////
                          IMMUTABLES
  //////////////////////////////////////////////////////////////*/

  ///@notice The token implementation address
  address public immutable tokenImpl;

  ///@notice The image implementation address
  address public immutable imageImpl;

  /*//////////////////////////////////////////////////////////////
                          CONSTRUCTOR
  //////////////////////////////////////////////////////////////*/
  constructor (
    address _token,
    address _image
  ) payable initializer {
    tokenImpl = _token;
    imageImpl = _image;
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
    TokenParams calldata _tokenParams,
    ImageParams calldata _imageParams
  ) external returns (
    address token,
    address image
  ) {
    // Deploy the network's token
    token = address(new ERC1967Proxy(tokenImpl, ""));

    // Use the token address to precompute the network's remaining addresses
    bytes32 salt = bytes32(uint256(uint160(token)) << 96);

    // Deploy the network's image
    image = address(new ERC1967Proxy{ salt: salt }(imageImpl, ""));

    // Initialize instances with provided config
    IToken(token).initialize(
      _tokenParams.initStrings,
      msg.sender,
      image,
      _tokenParams.targetPrice,
      _tokenParams.priceDecayPercent,
      _tokenParams.perTimeUnit
    );

    IImage(image).initialize(
      _tokenParams.initStrings,
      msg.sender,
      token
    );

    emit HyperimageDeployed(token, image);
  }
}