const { expect } = require("chai");
const { parseEther } = require("ethers/lib/utils");
const { ethers } = require("hardhat");

describe("WhiskeyMarket", function () {
  it("Should mint and trade NFTs", async function () {
    //Deploying and Getting Contract Addresses
    const MarketContract = await ethers.getContractFactory("WhiskeyMarket");
    const marketContract = await MarketContract.deploy();
    await marketContract.deployed();
    const marketAddress = marketContract.address;

    const NFTContract = await ethers.getContractFactory("Whiskey");
    const nftContract = await NFTContract.deploy(marketAddress);
    await nftContract.deployed();
    const nftAddress = nftContract.address;

    //Getting Prices
    let listingPrice = await marketContract.getListingPrice();
    listingPrice = listingPrice.toString();

    let auctionPrice = ethers.utils.parseEther("100", "ehter");

    //Minting NFTs
    const nft1 = await nftContract.mint_token('http-1');
    const nft2 = await nftContract.mint_token('http-2');
    await marketContract.createMarketItem(nftAddress, 0, auctionPrice, { value: listingPrice });
    await marketContract.createMarketItem(nftAddress, 1, auctionPrice, { value: listingPrice });

    //Get Users
    [ownerAddress, buyerAddress] = await ethers.getSigners();

    //Make Sale
    await marketContract.connect(buyerAddress).createMarketSale(nftAddress, 0, { value: auctionPrice });

    //Get All Items
    console.log('All Items');
    let items = await marketContract.fetchAllMarketItems();
    console.log('items', items);

    //Get ListedItems
    console.log('Listed Items');
    items = await marketContract.fetchListedMarketItems();
    console.log('items', items);

    //Get Buyer's NFTs
    console.log('Buyer', buyerAddress.address, 'Items');
    items = await marketContract.connect(buyerAddress).fetchMyNFTs();
    console.log('items', items);
  });
});
