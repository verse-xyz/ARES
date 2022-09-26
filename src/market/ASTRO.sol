// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {wadExp, wadLn, wadMul, wadDiv, unsafeWadMul, toWadUnsafe, unsafeWadDiv} from "./utils/SignedWadMath.sol";
import {IVRGDA} from "./interfaces/IVRGDA.sol";
import {Initializable} from "../utils/Initializable.sol";

/// @title Autonomous Reactive Emissions System (ARES)
/// @author neuroswish
/// @notice Rearchitected Linear VRGDA that enables fully autonomous, programmable markets inside NFTs.
/// @notice Credit to transmissions11 <t11s@paradigm.xyz> and FrankieIsLost <frankie@paradigm.xyz> for the original VRGDA architecture (https://github.com/transmissions11/VRGDAs).


contract ARES is IVRGDA, Initializable {
  /*//////////////////////////////////////////////////////////////
                          ARES PARAMETERS
  //////////////////////////////////////////////////////////////*/

  /// @notice Target price for a token, to be scaled according to sales pace.
  /// @dev Represented as an 18 decimal fixed point number.
  int256 public targetPrice;

  /// @dev Precomputed constant that allows us to rewrite a pow() as an exp().
  /// @dev Represented as an 18 decimal fixed point number.
  int256 internal decayConstant;

  /// @dev Precomputed constant that allows us to rewrite a pow() as an exp().
  /// @dev Represented as an 18 decimal fixed point number.
  int256 internal negDecayConstant;

  /// @dev Precomputed constant that allows us to rewrite a pow() as an exp().
  /// @dev Represented as an 18 decimal fixed point number.
  int256 internal rawDecayConstant;

  /// @dev The total number of tokens to target selling every full unit of time.
  /// @dev Represented as an 18 decimal fixed point number.
  int256 internal perTimeUnit;

  /// @notice Sets target price and per period price decrease for the ARES.
  /// @param _targetPrice The target price for a token if sold on pace, scaled by 1e18.
  /// @param _priceDecreasePercent Percent price decrease per unit of time, scaled by 1e18.
  function __ARES_init(int256 _targetPrice, int256 _priceDecreasePercent, int256 _perTimeUnit) internal onlyInitializing {
      targetPrice = _targetPrice;
      rawDecayConstant = wadLn(_priceDecreasePercent); // (k)
      decayConstant = wadLn(1e18 - _priceDecreasePercent); // (1-k)
      negDecayConstant = wadLn(_priceDecreasePercent - 1e18); // (k-1)
      // The decay constant must be negative for VRGDAs to work.
      if (decayConstant < 0) revert NON_NEGATIVE_DECAY_CONSTANT();
      perTimeUnit = _perTimeUnit;
  }

  /*//////////////////////////////////////////////////////////////
                            PRICING LOGIC
  //////////////////////////////////////////////////////////////*/

  /// @notice Calculate the price of a token according to the VRGDA formula.
  /// @param timeSinceStart Time passed since the VRGDA began, scaled by 1e18.
  /// @param sold The total number of tokens that have been sold so far.
  /// @return The price of a token according to VRGDA, scaled by 1e18.
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
                          // as ASTRO's n param represents the nth token and sold is the n-1th token.
                          timeSinceStart - getTargetSaleTime(toWadUnsafe(sold + 1))
                      )
                  )
              )
          );
      }
  }

  /// @dev Given a number of tokens sold, return the target time that number of tokens should be sold by.
  /// @param sold A number of tokens sold, scaled by 1e18, to get the corresponding target sale time for.
  /// @return The target time the tokens should be sold by, scaled by 1e18, where the time is
  /// relative, such that 0 means the tokens should be sold immediately when the VRGDA begins.
  function getTargetSaleTime(int256 sold) public view override returns (int256) {
      return unsafeWadDiv(sold, perTimeUnit);
  }

  /// @dev Given a number of tokens sold, return the minimum ETH required in the contract to facilitate autonomous selling.
  /// @param sold A number of tokens sold, scaled by 1e18, to get the corresponding required ETH reserves for.
  /// @return The minimum amount of ETH required in the contract to facilitate autonomous selling, where the
  /// creator is able to withdraw all excess reserves.
  function getMinimumReserves(int256 timeSinceStart, uint256 sold) public view returns (uint256) {
      unchecked {
        // prettier-ignore
        return uint256(
          wadDiv(
            // numerator
            wadMul(
              // target * extra expression
              wadMul(
                targetPrice,
                wadExp(
                    unsafeWadMul(
                        decayConstant,
                        // Theoretically calling toWadUnsafe with sold can silently overflow but under
                        // any reasonable circumstance it will never be large enough. We use sold + 1
                        // as ASTRO's n param represents the nth token and sold is the n-1th token.
                        -getTargetSaleTime(toWadUnsafe(sold + 1))
                    )
                ) - 1e18
              ),
              // vrgda price
              wadExp(
                  unsafeWadMul(
                      decayConstant,
                      // Theoretically calling toWadUnsafe with sold can silently overflow but under
                      // any reasonable circumstance it will never be large enough. We use sold + 1
                      // as ASTRO's n param represents the nth token and sold is the n-1th token.
                      timeSinceStart - getTargetSaleTime(toWadUnsafe(sold + 1))
                  )
              )
            ),
            // denominator
            // vrgda price
            wadExp(
                unsafeWadMul(
                    decayConstant,
                    // Theoretically calling toWadUnsafe with sold can silently overflow but under
                    // any reasonable circumstance it will never be large enough. We use sold + 1
                    // as ASTRO's n param represents the nth token and sold is the n-1th token.
                    timeSinceStart - getTargetSaleTime(toWadUnsafe(1))
                )
            )
          )
        );
      }
  }



}