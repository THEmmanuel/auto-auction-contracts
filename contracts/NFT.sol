// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, Ownable {
    constructor() ERC721("CarNFT", "CAR") {}

    function mintNFT(address recipient, uint256 tokenId) external onlyOwner {
        _mint(recipient, tokenId);
    }
}
