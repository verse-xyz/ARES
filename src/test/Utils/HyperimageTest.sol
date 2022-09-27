// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { Test } from "forge-std/Test.sol"; 

import { IFactory, Factory } from "../../factory/Factory.sol";
import { IToken, Token } from "../../token/Token.sol";
import { IImage, Image } from "../../image/Image.sol";
import { IARES, ARES } from "../../market/ARES.sol";

contract HyperimageTest is Test {
  /*//////////////////////////////////////////////////////////////
                            BASE SETUP
  //////////////////////////////////////////////////////////////*/

  Factory internal factory;

  address internal tokenImpl;
  address internal imageImpl;

  address internal creator;

  function setUp() public virtual {
    creator = vm.addr(0xA11CE);
    vm.label(creator, "CREATOR");

    
  }
}