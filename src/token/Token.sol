// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { UUPS } from "../proxy/UUPS.sol";
import { ReentrancyGuard } from "../utils/ReentrancyGuard.sol";
import { ERC721 } from "../token/ERC721.sol";
import { TokenStorage } from "./storage/TokenStorage.sol";
import { IToken } from "./interfaces/IToken.sol";
import { IImage } from "../image/interfaces/IImage.sol";
import { Image } from "../image/Image.sol";
import { LinearASTRO } from "../market/LinearASTRO.sol";

import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";

import {toDaysWadUnsafe} from "solmate/utils/SignedWadMath.sol";


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
    address _image,
    address _market
  ) external initializer {
    __ReentrancyGuard_init();
    (string memory _name, string memory _symbol, string memory _initImageURI) = abi.decode(_initStrings, (string, string, string));
    __ERC721_init(_name, _symbol);
    config.image = _image;
    config.market = _market;

  }

  /*//////////////////////////////////////////////////////////////
                          FUNCTIONS
  //////////////////////////////////////////////////////////////*/

  function knit() public payable returns (uint256 tokenId) {
    unchecked {

    }
  }

  function burn(uint256 tokenId) public returns (uint256) {
    unchecked {
      uint256 price = LinearASTRO(config.market).getVRGDAPrice(toDaysWadUnsafe(block.timestamp - startTime));
    }
  }

  // knit
  // mirror
  // burn
  // creator knit
  // creator mirror

  // we want to give the creator "equity" 
  // that is, they have the right to mint a certain amount of tokens at no cost
  // show the creator how many "free mints" they have left?

}