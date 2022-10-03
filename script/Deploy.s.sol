// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "forge-std/Script.sol";
import { Factory } from "../src/factory/Factory.sol";
import { Token } from "../src/token/Token.sol";
import { Image } from "../src/image/Image.sol";
import { UniversalImageStorage } from "../src/image/storage/UniversalImageStorage.sol";

contract DeployScript is Script {
  function run() external {
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    //address factoryImpl = address(new Factory());

    Factory factory = new Factory();
    address tokenImpl = address(new Token(address(factory)));
    address universalImageStorage = address(new UniversalImageStorage(address(factory)));
    address imageImpl = address(new Image(address(factory), address(universalImageStorage)));
    factory.initialize(tokenImpl, imageImpl, universalImageStorage);

    vm.stopBroadcast();
  }
}