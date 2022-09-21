// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/**
 * Luxury rap, the Hermés of verses
 * Sophisticated ignorance, write my curses in cursive
 * I get it custom, you a customer
 * You ain't accustomed to going through customs, you ain't been nowhere, huh?
 */

import {ERC721AUpgradeable} from "erc721a-upgradeable/ERC721AUpgradeable.sol";
import {IERC721AUpgradeable} from "erc721a-upgradeable/IERC721AUpgradeable.sol";
import {IERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC165Upgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {IHyperobject} from "./interfaces/IHyperobject.sol";
import {IImage} from "./interfaces/IImage.sol";
import {IFactoryUpgradeGate} from "./interfaces/IFactoryUpgradeGate.sol";
import {IOwnable} from "./interfaces/IOwnable.sol";

import {OwnableSkeleton} from "./utils/OwnableSkeleton.sol";
import {FundsReceiver} from "./utils/FundsReceiver.sol";
import {Version} from "./utils/Version.sol";
import {FactoryUpgradeGate} from "./FactoryUpgradeGate.sol";
import {Image} from "./image/Image.sol";

import {UUPS} from "./proxy/UUPS.sol";
import {ReentrancyGuard} from "./utils/ReentrancyGuard.sol";
import {ERC721} from "./token/ERC721.sol";
import {HyperobjectStorage} from "./storage/HyperobjectStorage.sol";

/// @title Hyperobject
/// @author neuroswish
/// @notice NFT with an autonomous exchange

contract Hyperobject is IHyperobject, ReentrancyGuard, ERC721, HyperobjectStorage {
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

    /// @notice Only a given role can access this function
    /// @param role Role to check alongside admin role
    modifier onlyRoleOrAdmin(bytes32 role) {
        if (!hasRole(role, _msgSender()) && !hasRole(DEFAULT_ADMIN_ROLE, _msgSender())) {
            revert Access_MissingRoleOrAdmin(role);
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                               CORE FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Global constructor - variables will not change with further proxy deploys
    /// @dev Marked as initializer to prevent storage of base implementation being used. Can only be initialized by proxy.
    // constructor(IFactoryUpgradeGate _factoryUpgradeGate)
    //     // TODO transfer helper and fee manager
    //     initializer
    // {
    //     factoryUpgradeGate = _factoryUpgradeGate;
    // }

    function initialize(
        // string memory _networkName,
        // string memory _networkSymbol,
        // address payable _creator,
        // uint16 _rewardBPS,
        bytes calldata _hyperimageInitData, // going to be the above 4 params encoded into a byte string
        IHyperobject.MarketConfiguration calldata _marketConfig, // market params
        IImage _image, // image rederer stuff
        bytes memory _imageInit // first image init data
    ) external initializer {
        // Init ERC721A
        __ERC721_init(_networkName, _networkSymbol);
        // Setup reentrancy guard
        __ReentrancyGuard_init();
        // // Setup the owner role
        // _setupRole(DEFAULT_ADMIN_ROLE, _creator);
        // // Set ownership to original sender of contract call
        // _setOwner(_creator);

        // Reward BPS check
        if (config.rewardBPS > MAX_REWARD_BPS) {
            revert Setup_RewardPercentageTooHigh(MAX_REWARD_BPS);
        }
        // Update marketConfig
        marketConfig = _marketConfig;
        // Setup config variables
        config.image = _image;
        config.rewardBPS = _rewardBPS;
        config.rewardRecipient = _creator;
    }

    /*//////////////////////////////////////////////////////////////
                               UTILITY FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    // /// @notice ERC165 supports interface
    // /// @param interfaceId interface id to check if supported
    // function supportsInterface(bytes4 interfaceId)
    //     public
    //     view
    //     override (
    //         /// TODO add IERC165Upgradeable
    //         ERC721AUpgradeable,
    //         AccessControlUpgradeable
    //     )
    //     returns (bool)
    // {
    //     return super.supportsInterface(interfaceId) || type(IOwnable).interfaceId == interfaceId
    //         || type(IHyperobject).interfaceId == interfaceId;
    // }
}
