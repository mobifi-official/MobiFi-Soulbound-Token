
const { ethers, upgrades } = require("hardhat");

async function main() {

  // Get the Contract Factory using ethers.js
  const MSBTFac = await ethers.getContractFactory("MSBT");
  const ProxyAdminFac = await ethers.getContractFactory("ProxyAdmin");
  const TransparentUpgradeableProxyFac = await ethers.getContractFactory("TransparentUpgradeableProxy");

  // Specify a higher gas price in wei (e.g., 50 Gwei)
  // only hardcode the gas fee if the estmateGas func 
  // doesn't work (see those commented code below)
  const gasPrice = ethers.utils.parseUnits("126", "gwei");
/*
  // Estimate the gas required to deploy the MSBT contract
  const estimatedGasForMSBT = await MSBTFac.estimateGas.deploy();
  console.log(`Estimated gas for MSBT deployment: ${estimatedGasForMSBT}`);

  // Deploy the MSBT contract, taking into account the estimated gas
  const msbt = await MSBTFac.deploy({ gasLimit: estimatedGasForMSBT.mul(2) }); // Multiplying by 2 for safety
  console.log("MSBT deployed to:", msbt.address);

  // Estimate the gas required to deploy the ProxyAdmin contract
  const estimatedGasForProxyAdmin = await ProxyAdminFac.estimateGas.deploy();
  console.log(`Estimated gas for ProxyAdmin deployment: ${estimatedGasForProxyAdmin}`);

  // Deploy the ProxyAdmin contract
  const proxyAdmin = await ProxyAdminFac.deploy({ gasLimit: estimatedGasForProxyAdmin.mul(2) });
  console.log("ProxyAdmin deployed to:", proxyAdmin.address);
*/

  // Deploy the MSBT contract, ProxyAdmin
  const msbt = await MSBTFac.deploy({ gasPrice: gasPrice });
  const proxyAdmin = await ProxyAdminFac.deploy({ gasPrice: gasPrice });
  console.log("MSBT deployed to:", msbt.address);
  console.log("ProxyAdmin deployed to:", proxyAdmin.address);
  
  // Define initialization data for the MSBT contract
  const initializeData = msbt.interface.encodeFunctionData("initialize", []);

  // Deploy TransparentUpgradeableProxy with initialization data
  const proxy = await TransparentUpgradeableProxyFac.deploy(
    msbt.address, 
    proxyAdmin.address, 
    initializeData,
    { gasPrice: gasPrice }
  );

/*  
// Estimate the gas required to deploy the TransparentUpgradeableProxy contract
const estimatedGasForProxy = await TransparentUpgradeableProxyFac.estimateGas.deploy(
  msbt.address,
  proxyAdmin.address,
  initializeData
);
console.log(`Estimated gas for TransparentUpgradeableProxy deployment: ${estimatedGasForProxy}`);

// Deploy the TransparentUpgradeableProxy contract
const proxy = await TransparentUpgradeableProxyFac.deploy(
  msbt.address,
  proxyAdmin.address,
  initializeData,
  { gasLimit: estimatedGasForProxy.mul(2) } // Multiplying by 2 for safety
);
console.log("TransparentUpgradeableProxy deployed to:", proxy.address);
*/

  // Make sure the ProxyAdmin is the admin of the TransparentUpgradeableProxy
  await proxyAdmin.changeProxyAdmin(proxy.address, proxyAdmin.address, { gasPrice: gasPrice });

  console.log("TransparentUpgradeableProxy deployed to:", proxy.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
