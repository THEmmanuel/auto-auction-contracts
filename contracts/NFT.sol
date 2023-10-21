// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract NFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Declare the CarDetails struct
    struct CarDetails {
        string carImage;
        string make;
        string vin;
        string transmission;
        string model;
        string engine;
        string horsepower;
    }

    // Declare the storage array with public visibility
    CarDetails[] public carInfo;

    constructor(
        string memory name,
        string memory symbol,
        address initialOwner
    ) ERC721(name, symbol) Ownable() {}

    function mintNFT(
        address recipient,
        CarDetails memory details
    ) external onlyOwner {
        // Get the current value of the counter and increment it by one
        uint256 tokenId = _tokenIds.current();
        _tokenIds.increment();

        // Mint the NFT with the generated token id
        _mint(recipient, tokenId);
        carInfo.push(details);
    }

    function setCarDetails(CarDetails memory details) external onlyOwner {
        // Get the current value of the counter
        uint256 tokenId = _tokenIds.current();
        // Set the car details for the token id
        carInfo[tokenId] = details;
    }

    function getSVG() public view returns (string memory) {
        // Get the current value of the counter
        uint256 tokenId = _tokenIds.current();
        // Get the car details from the mapping
        CarDetails memory details = carInfo[tokenId];
        // Generate the SVG string as before
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
        // require(_exists(tokenId), "NFT: Token ID does not exist");
        safeTransferFrom(from, to, tokenId);
    }
}
