// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFTAuction is Ownable() {
    ERC721 public nftContract;
    IERC20 public paymentToken;
    address public seller;
    address public highestBidder;
    uint256 public highestBid;
    uint256 public tokenId;
    bool public auctionEnded;


    event AuctionStarted(address indexed seller, uint256 tokenId);
    event NewBid(address indexed bidder, uint256 amount);
    event AuctionEnded(address indexed winner, uint256 amount);

    constructor(
        address _nftAddress,
        address _paymentTokenAddress,
        uint256 _tokenId
    ) {
        nftContract = ERC721(_nftAddress);
        paymentToken = IERC20(_paymentTokenAddress);
        seller = msg.sender;
        tokenId = _tokenId;
    }

    function startAuction() external onlyOwner {
        require(!auctionEnded, "Auction has already ended");
        emit AuctionStarted(seller, tokenId);
    }

    function placeBid(uint256 amount) external {
        require(!auctionEnded, "Auction has ended");
        require(msg.sender != seller, "Seller cannot bid");
        require(
            amount > highestBid,
            "Bid must be higher than the current highest bid"
        );

        // Refund the previous highest bidder.
        if (highestBidder != address(0)) {
            paymentToken.transfer(highestBidder, highestBid);
        }

        highestBidder = msg.sender;
        highestBid = amount;
        emit NewBid(msg.sender, amount);
    }

    function endAuction() external onlyOwner {
        require(!auctionEnded, "Auction has already ended");
        auctionEnded = true;

        // Transfer the NFT to the highest bidder.
        nftContract.safeTransferFrom(seller, highestBidder, tokenId);

        // Transfer the funds to the seller.
        paymentToken.transfer(seller, highestBid);
        emit AuctionEnded(highestBidder, highestBid);
    }

    function withdraw() external {
        require(auctionEnded, "Auction has not ended yet");
        require(
            msg.sender == seller || msg.sender == highestBidder,
            "You are not eligible to withdraw"
        );

        if (msg.sender == highestBidder) {
            // Refund the bid amount to the highest bidder.
            paymentToken.transfer(highestBidder, highestBid);
        } else if (msg.sender == seller) {
            // Withdraw any remaining funds to the seller.
            uint256 remainingFunds = paymentToken.balanceOf(address(this));
            if (remainingFunds > 0) {
                paymentToken.transfer(seller, remainingFunds);
            }
        }
    }
}
