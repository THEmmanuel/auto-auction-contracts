const main = async () => {
    const nftContractFamily = await hre.ethers.getContractFactory('NFT');
    const nftContract = await nftContractFamily.deploy();
	await nftContract.waitForDeployment();
	console.log('NFT contract deployed to:', nftContract.target);

    let txn = await nftContract.makeNFTStuff();
    await txn.wait();

    txn = await nftContract.makeNFTStuff()
    await txn.wait()
};

const runMain = async () => {
    try {
        await main()
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();