// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
	// const nftauction = await hre.ethers.getContractFactory('NFTAuction');
	// const NFTAuction = await nftauction.deploy();
	// await NFTAuction.deployed()
	// console.log('Auction contract deployed to:', NFTAuction.address);

	const nft = await hre.ethers.getContractFactory('NFT');
	// Add the necessary constructor arguments for the NFT contract
	const NFT = await nft.deploy('My NFT', 'MNFT', '0xC4D4Ad0d298ee6392d0e44030E887B07ED6c6009');
	console.log('NFT contract deployed to:', NFT.address);
}

const runMain = async () => {
	try {
		await main()
		process.exit(0);
	} catch (error) {
		console.log(error);
		process.exit(1);
	}
};

runMain()

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});