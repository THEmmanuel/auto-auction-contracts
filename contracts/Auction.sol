// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./NFT.sol";
import "./Escrow.sol";

contract Auction is Ownable {
    NFT public nftContract;
    Escrow public escrowContract;
    uint256 public auctionCount;
    enum AuctionStatus { Created, Open, Closed }
    struct AuctionInfo {
        address owner;
        uint256 tokenId;
        uint256 reservePrice;
        uint256 endTime;
        AuctionStatus status;
    }
    mapping(uint256 => AuctionInfo) public auctions;

    event AuctionCreated(uint256 auctionId, uint256 tokenId);
    event AuctionEnded(uint256 auctionId, address winner);

    constructor(address _nftAddress, address _escrowAddress) {
        nftContract = NFT(_nftAddress);
        escrowContract = Escrow(_escrowAddress);
    }

    function createAuction(uint256 tokenId, uint256 reservePrice, uint256 duration) external {
        // Ensure the sender is the owner of the NFT.
        require(nftContract.ownerOf(tokenId) == msg.sender, "Only NFT owner can create an auction");

        uint256 auctionEndTime = block.timestamp + duration;
        auctionCount++;

        auctions[auctionCount] = AuctionInfo({
            owner: msg.sender,
            tokenId: tokenId,
            reservePrice: reservePrice,
            endTime: auctionEndTime,
            status: AuctionStatus.Created
        });

        emit AuctionCreated(auctionCount, tokenId);
    }

    function startAuction(uint256 auctionId) external onlyOwner {
        AuctionInfo storage auction = auctions[auctionId];
        require(auction.status == AuctionStatus.Created, "Auction is not in Created status");
        require(auction.endTime > block.timestamp, "Auction has ended");

        auction.status = AuctionStatus.Open;
    }

    function endAuction(uint256 auctionId) external {
        AuctionInfo storage auction = auctions[auctionId];
        require(auction.status == AuctionStatus.Open, "Auction is not in Open status");
        require(auction.endTime <= block.timestamp, "Auction is still open");

        address winner = escrowContract.auctionToHighestBidder(auctionId);
        require(winner != address(0), "No valid bids received");

        auction.status = AuctionStatus.Closed;
        nftContract.safeTransferFrom(auction.owner, winner, auction.tokenId);

        emit AuctionEnded(auctionId, winner);
    }
}