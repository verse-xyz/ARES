// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/**

    Luxury rap, the Hermés of verses
    Sophisticated ignorance, write my curses in cursive
    I get it custom, you a customer
    You ain't accustomed to going through customs, you ain't been nowhere, huh?

*/

import "./Exchange.sol";
import {ERC721AUpgradeable} from  "erc721a-upgradeable/ERC721AUpgradeable.sol";
import {IERC721AUpgradeable} from "erc721a-upgradeable/IERC721AUpgradeable.sol";
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
import {HyperobjectStorage} from "./storage/HyperobjectStorage.sol";


/// @title Hyperobject
/// @author neuroswish
/// @notice NFT with an autonomous exchange

contract Hyperobject is 
    ERC721AUpgradeable,
    UUPSUpgradeable,
    ReentrancyGuardUpgradeable,
    AccessControlUpgradeable,
    OwnableSkeleton,
    FundsReceiver,
    Version(1),
    IHyperobject,
    HyperobjectStorage
{

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @dev Gas limit to send funds
    uint256 internal constant FUNDS_SEND_GAS_LIMIT = 210_000;

    /// @notice Access control roles
    bytes32 public immutable CREATOR_ROLE = keccak256("CREATOR");
    bytes32 public immutable MANAGER_ROLE = keccak256("MANAGER");

    // TODO ZORA V3 transfer helper address for auto-approval
    //address internal immutable zoraERC721TransferHelper;

    /// @dev Factory upgrade gate
    IFactoryUpgradeGate internal immutable factoryUpgradeGate;

    /// TODO Zora Fee Manager address
    //IZoraFeeManager public immutable zoraFeeManager;

    /// @notice Max reward BPS
    uint16 constant MAX_REWARD_BPS = 50_00;

    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/

    /// @notice Only admin can access this function
    modifier onlyAdmin() {
        if (!hasRole(DEFAULT_ADMIN_ROLE, _msgSender())) {
            revert Access_OnlyAdmin();
        }
        _;
    }


    /*//////////////////////////////////////////////////////////////
                                FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice ERC165 supports interface
    /// @param interfaceId interface id to check if supported
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(
            /// TODO add IERC165Upgradeable
            IERC165Upgradeable,
            ERC721AUpgradeable,
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
