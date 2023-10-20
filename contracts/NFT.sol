// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, Ownable {
    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) {}

    struct CarDetails {
        string carImage;
        string make;
        string vin;
        string transmission;
        string model;
        string engine;
        string horsepower;
    }

    mapping(uint256 => CarDetails) public carInfo;

    function mintNFT(
        address recipient,
        uint256 tokenId,
        CarDetails memory details
    ) external onlyOwner {
        require(!_exists(tokenId), "NFT: Token ID already exists");
        _mint(recipient, tokenId);
        carInfo[tokenId] = details;
    }

    function setCarDetails(
        uint256 tokenId,
        CarDetails memory details
    ) external onlyOwner {
        require(_exists(tokenId), "NFT: Token ID does not exist");
        carInfo[tokenId] = details;
    }

    function getSVG(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "NFT: Token ID does not exist");
        CarDetails memory details = carInfo[tokenId];
        string memory svg = string(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="700" height="600">',
                '<rect width="100%" height="100%" fill="#000" rx="10" ry="10" />',
                '<image x="20" y="20" width="700" height="300" xlink:href="',
                details.carImage,
                '" />',
                '<text x="120" y="390" font-size="15" fill="#FFF" text-anchor="middle">',
                details.make,
                "</text>",
                '<text x="340" y="390" font-size="15" fill="#FFF" text-anchor="middle">',
                details.vin,
                "</text>",
                '<text x="560" y="390" font-size="15" fill="#FFF" text-anchor="middle">',
                details.transmission,
                "</text>",
                '<text x="120" y="510" font-size="15" fill="#FFF" text-anchor="middle">',
                details.model,
                "</text>",
                '<text x="340" y="510" font-size="15" fill="#FFF" text-anchor="middle">',
                details.engine,
                "</text>",
                '<text x="560" y="510" font-size="15" fill="#FFF" text-anchor="middle">',
                details.horsepower,
                "</text>",
                "</svg>"
            )
        );
        return svg;
    }

    function safeTransferNFT(
        address from,
        address to,
        uint256 tokenId
    ) external onlyOwner {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "NFT: Not approved or owner"
        );
        safeTransferFrom(from, to, tokenId);
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _exists(tokenId);
    }
}
