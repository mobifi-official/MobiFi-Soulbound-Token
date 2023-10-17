require('dotenv').config()
require("@nomiclabs/hardhat-ethers");
require("@openzeppelin/hardhat-upgrades");
require("@nomiclabs/hardhat-etherscan");

const ETHERSCAN_API_KEY = ""
const PRI_KEY = ""

module.exports = {
  solidity: "0.8.9",
  networks: {
    mumbai: {
      url: "your rpc service link",
      accounts: [PRI_KEY],
    },
    polygon: {
      url: "your rpc service link",
      accounts: [PRI_KEY],
  },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
};