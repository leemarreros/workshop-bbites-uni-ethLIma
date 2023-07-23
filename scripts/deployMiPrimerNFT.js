var { ethers } = require("hardhat");

async function main() {
  var _collectionName = "LEE MARREROS NFT COLLECTION";
  var _collectionSymbol = "LMRRNFTCLL";

  // 1 - Inicializa el constructor usando '.deploy();
  //     Obtén además una representación de contrato del NFT
  //     Publica el contrato
  const miPrimerNft = await ethers.deployContract("MiPrimerNft", [
    _collectionName,
    _collectionSymbol,
  ]);

  // 2 - Esperamos que se publique el contrato con '.waitForDeployment()'
  await miPrimerNft.waitForDeployment();

  // 1 minuto (en milisegundos)
  const delay = 30 * 1000;

  // Demora 1 minuto
  await new Promise((resolve) => setTimeout(resolve, delay));

  // 3 - Obten el address de tu contrato publicado con '.address'
  var miPrimerNftAddress = await miPrimerNft.getAddress();
  console.log("Addresse NFT", miPrimerNftAddress);

  // VERIFICANDO EL SMART CONTRACT
  console.log("Verificaion de smart contract");
  // 4 - Script de verificación: usa 'hre.run("verify: verify"...'
  await hre.run("verify:verify", {
    address: miPrimerNftAddress,
    constructorArguments: [_collectionName, _collectionSymbol],
  });

  // 5 - Ejecuta el comando desde el terminal y espera la magia
  // npx hardhat --network [network] run scripts/deployMiPrimerNFT.js
}

async function mint() {
  const [owner] = await ethers.getSigners();

  const address = "0xa26e7BB9CBfB16B76Fd7602B51590Ce403480D0E";
  const MiPrimerNft = await ethers.getContractFactory("MiPrimerNft");
  const miPrimerNft = MiPrimerNft.attach(address);

  var tx = await miPrimerNft.safeMint(owner.address);
  var res = await tx.wait();
  console.log("Minted NFT #1", res.hash);
}

// main()
mint()
  //
  .catch((error) => {
    console.error(error);
    process.exitCode = 1; // exitcode quiere decir fallor por error, terminacion fatal
  });
