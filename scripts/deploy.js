const hre = require("hardhat");

async function main() {
	const nft = await hre.ethers.getContractFactory('NFT');
	const NFT = await nft.deploy('Auto Auction', 'AutoAuction', '0xC4D4Ad0d298ee6392d0e44030E887B07ED6c6009');
	await NFT.waitForDeployment();
	console.log('NFT contract deployed to:', NFT.target);

	// Uncomment the following lines if you want to deploy the Auction contract
	// const nftauction = await hre.ethers.getContractFactory('NFTAuction');
	// const NFTAuction = await nftauction.deploy();
	// console.log('Auction contract deployed to:', NFTAuction.address);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exitCode = 1;
	});