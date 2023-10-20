// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Escrow is Ownable, ReentrancyGuard {
    IERC20 public token;
    mapping(uint256 => address) public auctionToHighestBidder;
    mapping(uint256 => uint256) public auctionToHighestBid;

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    function createEscrow(uint256 auctionId, uint256 amount) external {
        // Ensure the sender has approved the Escrow contract to spend their tokens.
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        // Store the highest bidder and their bid for the auction.
        auctionToHighestBidder[auctionId] = msg.sender;
        auctionToHighestBid[auctionId] = amount;
    }

    function releaseEscrow(uint256 auctionId, address winner) external onlyOwner {
        address highestBidder = auctionToHighestBidder[auctionId];
        uint256 highestBid = auctionToHighestBid[auctionId];

        require(highestBidder == winner, "Winner must be the highest bidder");

        // Transfer the escrowed funds to the winner.
        require(token.transfer(winner, highestBid), "Transfer failed");

        // Reset the highest bidder and bid for the auction.
        auctionToHighestBidder[auctionId] = address(0);
        auctionToHighestBid[auctionId] = 0;
    }
}
