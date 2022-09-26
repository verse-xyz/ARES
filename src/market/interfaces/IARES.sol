// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title IARES
/// @author neuroswish
/// @notice The ARES events, errors, and functions

interface IARES {
  /*//////////////////////////////////////////////////////////////
                            ERRORS
  //////////////////////////////////////////////////////////////*/

  /// @dev Reverts if a decay constant is non-negative
  error NON_NEGATIVE_DECAY_CONSTANT();

  /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
  //////////////////////////////////////////////////////////////*/

  /// @notice Calculate the price of a token according to the VRGDA formula.
  /// @param timeSinceStart Time passed since the VRGDA began, scaled by 1e18.
  /// @param sold The total number of tokens that have been sold so far.
  function getVRGDAPrice(int256 timeSinceStart, uint256 sold) external view returns (uint256);

  /// @dev Given a number of tokens sold, return the target time that number of tokens should be sold by.
  /// @param sold A number of tokens sold, scaled by 1e18, to get the corresponding target sale time for.
  function getTargetSaleTime(int256 sold) external view returns (int256);

  /// @notice Given a number of tokens sold, return the minimum ETH required in the contract to facilitate autonomous selling.
  /// @param timeSinceStart Time passed since the VRGDA began, scaled by 1e18.
  /// @param sold A number of tokens sold, scaled by 1e18, to get the corresponding required ETH reserves for.
  /// @dev We determine this value by calculating the minimum amount of ETH required to facilitate the instant selling (& subsequent burning)
  /// of all circulating tokens if all tokens happened to be sold in the same block. We are assuming that each seller receives the token spot price
  /// (as calculated by getVRGDAPrice) in exchange for sending a single token back to the contract.
  ///
  /// To calculate the amount of ETH a seller receives for one token, we simply input the current circulating token supply into the getVRGDAPrice function.
  /// To calculate the amount of ETH required to facilitate the selling of all tokens, we take the summation of the linear VRGDA formula from n=1 to n=sold.
  /// The closed form solution to this summation is given by the following equation: https://www.wolframalpha.com/input?i=sum+from+n%3D1+to+n%3DN+of+p_0+*+%281+-+k%29%5E%28t+-+n%2Fr%29
  function getMinimumReserves(int256 timeSinceStart, uint256 sold) external view returns (uint256);
}