// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract HyperobjectProxy is ERC1967Proxy {
  constructor(address _logic, bytes memory _data)
    payable
    ERC1967Proxy(_logic, _data)
  {}
}

// ERC1967Upgrade defines the getter and setter functions for EIP1967 slots
// ERC1967Proxy is the actual proxy contract implementation that uses those functions