// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { UUPS } from "../proxy/UUPS.sol";
import { ReentrancyGuard } from "../utils/ReentrancyGuard.sol";
import { ERC721 } from "../token/ERC721.sol";
import { TokenStorage } from "./storage/TokenStorage.sol";
import { IToken } from "./interfaces/IToken.sol";
import { IImage } from "../image/interfaces/IImage.sol";


contract Token is IToken, ERC721, UUPS, ReentrancyGuard, TokenStorage {
  /*//////////////////////////////////////////////////////////////
                          CONSTRUCTOR
  //////////////////////////////////////////////////////////////*/

  /*//////////////////////////////////////////////////////////////
                          INITIALIZER
  //////////////////////////////////////////////////////////////*/
  // we need to use the argu
  function initialize(
    bytes calldata _initStrings,
    address creator,
    uint16 rewardBPS,
    address _image
  ) external initializer {
    __ReentrancyGuard_init();
    (string memory _name, string memory _symbol, string memory _initImageURI, string memory _initInteractionsURI) = abi.decode(_initStrings, (string, string, string, string));
    __ERC721_init(_name, _symbol);
    config.image = _image;
  }

  /*//////////////////////////////////////////////////////////////
                          FUNCTIONS
  //////////////////////////////////////////////////////////////*/

  // knit
  // mirror
  // burn
  // creator mint
}