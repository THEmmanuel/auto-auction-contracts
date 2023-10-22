require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

/** @type import('hardhat/config').HardhatUserConfig */
const {
	ALCHEMY_API_URL,
	PRIVATE_KEY
} = process.env;

module.exports = {
	solidity: "0.8.20",
	defaultNetwork: "goerli",
	networks: {
		goerli: {
			url: ALCHEMY_API_URL,
			accounts: [`0x${PRIVATE_KEY}`]
		},

		scrollTestnet: {
			url: process.env.SCROLL_TESTNET_URL || "",
			accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
		},
	},
}