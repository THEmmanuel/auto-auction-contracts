// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "hardhat/console.sol";

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSVG =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    event NewNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("CarNFT", "CarNFT") {
        console.log("car nft contract set up");
    }

    function makeNFTStuff() public {
        uint256 newItemId = _tokenIds.current();

        // string memory image = "https://bafybeidisy4efnw2nm5jvudvhrwuizs5vsurvnuzacqxc2nrpbswn4zqsu.ipfs.w3s.link/KDZP4qQ0.qXPtUr9Cd-(edit).jpg";
        string memory carMake = "Mercedes-Benz";
        string memory carModel = "G63 AMG";
        string memory carVin = "WDCYC7DF8GX243083";
        string memory carTransmission = "Automatic (7-Speed)";
        string memory carEngine = "5.5L Turbocharged V8";
        string memory carHorsepower = "700 hp";
        string memory combinedWord = string(
            abi.encodePacked(
                carMake,
                carModel,
                carVin,
                carTransmission,
                carEngine,
                carHorsepower
            )
        );

        string memory finalSVG = string(
            abi.encodePacked(baseSVG, combinedWord, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "A highly acclaimed collection of NFT stuff.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSVG)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
        emit NewNFTMinted(msg.sender, newItemId);
    }
}
