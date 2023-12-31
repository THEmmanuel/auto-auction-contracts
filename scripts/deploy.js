const hre = require("hardhat");

async function main() {
	const nft = await hre.ethers.getContractFactory('NFT');
	const NFT = await nft.deploy();
	await NFT.waitForDeployment();
	console.log('NFT contract deployed to:', NFT.target);

	// Uncomment the following lines if you want to deploy the Auction contract
	const nftauction = await hre.ethers.getContractFactory('NFTAuction');
	const NFTAuction = await nftauction.deploy('0x7a694E1B407F4836673D9791A94B9BE9d14b2C71', '0x0000000000000000000000000000000000000000', 1);
	await NFTAuction.waitForDeployment();
	console.log('Auction contract deployed to:', NFTAuction.target);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exitCode = 1;
	});