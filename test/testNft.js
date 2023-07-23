var {
  loadFixture,
  setBalance,
  impersonateAccount,
} = require("@nomicfoundation/hardhat-network-helpers");
var { expect } = require("chai");
var { ethers } = require("hardhat");
var { toBigInt } = require("ethers");

describe("Testeando un NFT", function () {
  async function deployFixture() {
    var _collectionName = "LEE MARREROS NFT COLLECTION";
    var _collectionSymbol = "LMRRNFTCLL";

    const [owner, alice, bob, carl] = await ethers.getSigners();

    const MiPrimerNft = await ethers.getContractFactory("MiPrimerNft");
    const miPrimerNft = await MiPrimerNft.deploy(
      _collectionName,
      _collectionSymbol
    );

    return { miPrimerNft, owner, alice, bob, carl };
  }

  var miPrimerNft, owner, alice, bob, carl;

  beforeEach(async () => {
    var fixture = await loadFixture(deployFixture);
    miPrimerNft = fixture.miPrimerNft;
    owner = fixture.owner;
    alice = fixture.alice;
    bob = fixture.bob;
    carl = fixture.carl;
  });

  describe("Presentación", function () {
    var _collectionName = "LEE MARREROS NFT COLLECTION";
    var _collectionSymbol = "LMRRNFTCLL";

    it("Verifica nombre de la colección", async function () {
      expect(await miPrimerNft.name()).to.be.equal(_collectionName);
    });

    it("Verifica simbolo de la colección", async function () {
      expect(await miPrimerNft.symbol()).to.be.equal(_collectionSymbol);
    });
  });

  describe("Metadata", () => {
    it("Verifica correcto URI", async () => {
      await miPrimerNft.safeMint(alice.address);
      var tokenId = 0;
      var uriToken0 = await miPrimerNft.tokenURI(tokenId);
      var uri = "ipfs://QmbPzq38aGVrH6JeE6nKTsoG5tSp2mHvQ1Yrx5uP6g8AR5/";
      expect(uriToken0).to.equal(`${uri}${tokenId}`);
    });
  });

  describe("Acuñando NFTs", function () {
    it("Incrementa balance de NFTs", async function () {
      await miPrimerNft.safeMint(alice.address);
      expect(await miPrimerNft.balanceOf(alice.address)).to.equal(1);
      await miPrimerNft.safeMint(alice.address);
      expect(await miPrimerNft.balanceOf(alice.address)).to.equal(2);
      await miPrimerNft.safeMint(alice.address);
      expect(await miPrimerNft.balanceOf(alice.address)).to.equal(3);
    });

    it("Verifica token IDs corrects", async () => {
      await miPrimerNft.safeMint(alice.address);
      await miPrimerNft.safeMint(alice.address);
      await miPrimerNft.safeMint(alice.address);
      expect(await miPrimerNft.ownerOf(0)).to.equal(alice.address);
      expect(await miPrimerNft.ownerOf(1)).to.equal(alice.address);
      expect(await miPrimerNft.ownerOf(2)).to.equal(alice.address);
    });

    it("Emit evento cuando se acuña", async () => {
      var tx = await miPrimerNft.safeMint(alice.address);
      var tokenId = 0;
      await expect(tx)
        .to.emit(miPrimerNft, "Transfer")
        .withArgs(ethers.ZeroAddress, alice.address, tokenId);
    });

    it("No acuña dos NFT con el mismo id", async () => {
      var tokenId = 0;
      var safeMint = miPrimerNft["safeMint(address,uint256)"];
      await safeMint(alice.address, tokenId);
      expect(safeMint(alice.address, tokenId)).to.be.rejectedWith(
        "Ya tiene duenio"
      );
    });
  });

  describe("Transferencia", () => {
    it("Correcto transfer", async () => {
      await miPrimerNft.safeMint(alice.address);

      await miPrimerNft
        .connect(alice)
        .transferFrom(alice.address, bob.address, 0);

      expect(await miPrimerNft.ownerOf(0)).to.equal(bob.address);
      expect(await miPrimerNft.balanceOf(alice.address)).to.equal(0);
      expect(await miPrimerNft.balanceOf(bob.address)).to.equal(1);
    });
  });
});
