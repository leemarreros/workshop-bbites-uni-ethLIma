var { ethers } = require("hardhat");

async function main() {
  const englishAuction = await ethers.deployContract("EnglishAuction");

  // 1 minuto (en milisegundos)
  const delay = 30 * 1000;
  // Demora 1 minuto
  await new Promise((resolve) => setTimeout(resolve, delay));

  const englishAuctionAdd = await englishAuction.getAddress();
  console.log("Subasta Inglesa address:", englishAuctionAdd);

  // VERIFICANDO EL SMART CONTRACT
  console.log("Verificaion de smart contract");
  await hre.run("verify:verify", {
    address: englishAuction.address,
    constructorArguments: [],
  });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
