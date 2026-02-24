const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying with:", deployer.address);

  const Token = await hre.ethers.getContractFactory("AutoTaxToken");

  const initialSupply = 1_000_000; // 1 million
  const treasuryWallet = deployer.address;

  const token = await Token.deploy(initialSupply, treasuryWallet);

  await token.waitForDeployment();

  console.log("Token deployed to:", await token.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
