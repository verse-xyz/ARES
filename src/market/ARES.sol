// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { wadExp, wadLn, wadMul, wadDiv, unsafeWadMul, toWadUnsafe, unsafeWadDiv } from "./utils/SignedWadMath.sol";
import { IARES } from "./interfaces/IARES.sol";
import { Initializable } from "../utils/Initializable.sol";

/// @title Autonomous Reactive Emissions System (ARES)
/// @author neuroswish
/// @notice Rearchitected Linear VRGDA that enables fully autonomous, programmable markets inside NFTs
/// @notice Credit to transmissions11 <t11s@paradigm.xyz> and FrankieIsLost <frankie@paradigm.xyz> for the original VRGDA architecture (https://github.com/transmissions11/VRGDAs)

contract ARES is IARES, Initializable {
  /*//////////////////////////////////////////////////////////////
                          STORAGE
  //////////////////////////////////////////////////////////////*/

  /// @notice Target price for a token, to be scaled according to sales pace
  /// @dev Represented as an 18 decimal fixed point number
  int256 public targetPrice;

  /// @dev Precomputed constant that allows us to rewrite a pow() as an exp()
  /// @dev Represented as an 18 decimal fixed point number
  int256 internal decayConstant;

  /// @dev The total number of tokens to target selling every full unit of time
  /// @dev Represented as an 18 decimal fixed point number
  int256 internal perTimeUnit;

  /*//////////////////////////////////////////////////////////////
                            INITIALIZER
  //////////////////////////////////////////////////////////////*/

  /// @notice Sets target price and per period price decrease for the ARES
  /// @param _targetPrice The target price for a token if sold on pace, scaled by 1e18
  /// @param _priceDecreasePercent Percent price decrease per unit of time, scaled by 1e18
  /// @param _perTimeUnit The total number of tokens to target selling every full unit of time
  function __ARES_init(int256 _targetPrice, int256 _priceDecreasePercent, int256 _perTimeUnit) internal initializer {
      targetPrice = _targetPrice;
      decayConstant = wadLn(1e18 - _priceDecreasePercent);

      // The decay constant must be negative for VRGDAs to work.
      if (decayConstant < 0) revert NON_NEGATIVE_DECAY_CONSTANT();
      perTimeUnit = _perTimeUnit;
  }

  /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
  //////////////////////////////////////////////////////////////*/

  /// @notice Calculate the price of a token according to the VRGDA formula.
  /// @param timeSinceStart Time passed since the VRGDA began, scaled by 1e18.
  /// @param sold The total number of tokens that have been sold so far.
  function getVRGDAPrice(int256 timeSinceStart, uint256 sold) public view returns (uint256) {
      unchecked {
          // prettier-ignore
          return uint256(
              wadMul(
                  targetPrice,
                  wadExp(
                      unsafeWadMul(
                          decayConstant,
                          // Theoretically calling toWadUnsafe with sold can silently overflow but under
                          // any reasonable circumstance it will never be large enough. We use sold + 1
                          // as VRGDA's n param represents the nth token and sold is the n-1th token.
                          timeSinceStart - getTargetSaleTime(toWadUnsafe(sold + 1))
                      )
                  )
              )
          );
      }
  }

  /// @dev Given a number of tokens sold, return the target time that number of tokens should be sold by.
  /// @param sold A number of tokens sold, scaled by 1e18, to get the corresponding target sale time for.
  function getTargetSaleTime(int256 sold) public view returns (int256) {
      return unsafeWadDiv(sold, perTimeUnit);
  }

  /// @notice Given a number of tokens sold, return the minimum ETH required in the contract to facilitate autonomous selling.
  /// @param sold A number of tokens sold, scaled by 1e18, to get the corresponding required ETH reserves for.
  /// @dev We determine this value by calculating the minimum amount of ETH required to facilitate the instant selling (& subsequent burning)
  /// of all circulating tokens if all tokens happened to be sold in the same block. We are assuming that each seller receives the token spot price
  /// (as calculated by getVRGDAPrice) in exchange for sending a single token back to the contract.
  ///
  /// To calculate the amount of ETH a seller receives for one token, we simply input the current circulating token supply into the getVRGDAPrice function.
  /// To calculate the amount of ETH required to facilitate the selling of all tokens, we take the summation of the linear VRGDA formula from n=1 to n=sold.
  /// The closed form solution to this summation is given by the following equation: https://www.wolframalpha.com/input?i=sum+from+n%3D1+to+n%3DN+of+p_0+*+%281+-+k%29%5E%28t+-+n%2Fr%29

  function getMinimumReserves(int256 timeSinceStart, uint256 sold) public view returns (uint256) {
      unchecked {
        // prettier-ignore
        return uint256(
          wadDiv(
            wadMul(
              wadMul(
                targetPrice,
                wadExp(
                    unsafeWadMul(
                        decayConstant,
                        // Theoretically calling toWadUnsafe with sold can silently overflow but under
                        // any reasonable circumstance it will never be large enough. We use sold + 1
                        // as VRGDA's n param represents the nth token and sold is the n-1th token.
                        -getTargetSaleTime(toWadUnsafe(sold + 1))
                    )
                ) - 1e18
              ),
              wadExp(
                  unsafeWadMul(
                      decayConstant,
                      // Theoretically calling toWadUnsafe with sold can silently overflow but under
                      // any reasonable circumstance it will never be large enough. We use sold + 1
                      // as VRGDA's n param represents the nth token and sold is the n-1th token.
                      timeSinceStart - getTargetSaleTime(toWadUnsafe(sold + 1))
                  )
              )
            ),
            wadExp(
                unsafeWadMul(
                    decayConstant,
                    timeSinceStart - getTargetSaleTime(toWadUnsafe(1))
                )
            )
          )
        );
      }
  }
}