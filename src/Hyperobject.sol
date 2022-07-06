// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/**

    Luxury rap, the Hermés of verses
    Sophisticated ignorance, write my curses in cursive
    I get it custom, you a customer
    You ain't accustomed to going through customs, you ain't been nowhere, huh?

*/

import "./Exchange.sol";
import {ERC1155Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import {IERC1155Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC1155Upgradeable.sol";
import {IERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC165Upgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {IHyperobject} from "./interfaces/IHyperobject.sol";
import {IOwnable} from "./interfaces/IOwnable.sol";

import {OwnableSkeleton} from "./utils/OwnableSkeleton.sol";
import {FundsReceiver} from "./utils/FundsReceiver.sol";
import {Version} from "./utils/Version.sol";
import {FactoryUpgradeGate} from "./FactoryUpgradeGate.sol";


/// @title Hyperobject
/// @author neuroswish
/// @notice NFT with an autonomous exchange

contract Hyperobject is 
    ERC1155Upgradeable,
    UUPSUpgradeable,
    ReentrancyGuardUpgradeable,
    AccessControlUpgradeable,
    OwnableSkeleton,
    FundsReceiver
{

    // ======== Storage ========

    address public exchange; // Exchange token pair address
    address public immutable factory; // Pair factory address
    string public baseURI; // NFT base URI
    uint256 currentTokenId; // Counter keeping track of last minted token id

    // ======== Errors ========

	/// @notice Thrown when function caller is unauthorized
	error Unauthorized();

	/// @notice Thrown when transfer recipient is invalid
	error InvalidRecipient();

    /// @notice Thrown when token id is invalid
	error InvalidTokenId();

    // ======== Constructor ========

    /// @notice Set factory address
    /// @param _factory Factory address
    constructor(address _factory) initializer {
        factory = _factory;
     }

    // ======== Initializer ========

    /// @notice Initialize a new exchange
    /// @param _name Hyperobject name
    /// @param _symbol Hyperobject symbol
    /// @param _baseURI Token base URI
    /// @param _exchange Exchange address
    /// @dev Called by factory at time of deployment
    function initialize(
        string calldata _name,
        string calldata _symbol,
        string calldata _baseURI,
        address _exchange
    ) external {
        if (msg.sender != factory) revert Unauthorized();
       
    }

    // ======== Functions ========



    /// @notice ERC165 supports interface
    /// @param interfaceId interface id to check if supported
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(
            ERC1155Upgradeable,
            AccessControlUpgradeable
        )
        returns (bool)
    {
        return
            super.supportsInterface(interfaceId) ||
            type(IOwnable).interfaceId == interfaceId ||
            type(IHyperobject).interfaceId == interfaceId;
    }



}

