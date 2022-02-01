//SPDX-Lincense-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

contract WhiskeyMarket is ReentrancyGuard, Ownable {
    using Counters for Counters.Counter;

    //Tracks Items
    Counters.Counter private _itemIds;
    //Tracks Items Sold
    Counters.Counter private _itemsUnsold;
    //Tracks listing price
    uint256 private listingPrice = 0.45 ether;

    struct WhiskeyItem {
        uint256 itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    //Mapping to return WhiskeyItem structobject from tokenId
    mapping(uint256 => WhiskeyItem) private itemID_to_Whiskey;

    event WhiskeyItemListed(
        uint256 itemId,
        address nftContract,
        uint256 tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    //Owner Functions
    function getOwnerBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function withdrawBalance() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    function updateListingPrice(uint256 newPrice) public onlyOwner {
        require(
            newPrice != listingPrice,
            "Already the desired listing price - Nothing to Update!!"
        );
        require(
            newPrice > 0,
            "Price Must be greater than 0 wei - No freebies!!"
        );
        listingPrice = newPrice;
    }

    //Create a MarketItem to put to Sale
    function createMarketItem(
        address nftContract_,
        uint256 tokenId_,
        uint256 price_
    ) public payable nonReentrant {
        require(price_ > 0, "Price Must be greater than 0 wei - No freebies!!");
        require(msg.value >= listingPrice, "Must send the listingPrice!!");

        uint256 itemId = _itemIds.current();
        _itemIds.increment();
        _itemsUnsold.increment();

        //Put it up for sale
        itemID_to_Whiskey[itemId] = WhiskeyItem(
            itemId,
            nftContract_,
            tokenId_,
            payable(msg.sender),
            payable(address(0)),
            price_,
            false
        );

        //NFT Transaction
        IERC721(nftContract_).transferFrom(msg.sender, address(this), tokenId_);

        emit WhiskeyItemListed(
            itemId,
            nftContract_,
            tokenId_,
            msg.sender,
            address(0),
            price_,
            false
        );
    }

    // Function to conduct Transactions
    function createMarketSale(address nftContract_, uint256 itemId_)
        public
        payable
        nonReentrant
    {
        uint256 price = itemID_to_Whiskey[itemId_].price;
        uint256 tokenId = itemID_to_Whiskey[itemId_].tokenId;
        require(
            msg.value >= price,
            "Value Sent must not be less than the price"
        );

        // Transfer $$$ from the buyer to seller
        itemID_to_Whiskey[itemId_].seller.transfer(msg.value);
        // Pass the whiskey from the seller to buyer
        IERC721(nftContract_).transferFrom(address(this), msg.sender, tokenId);

        itemID_to_Whiskey[itemId_].sold = true;
        itemID_to_Whiskey[itemId_].owner = payable(msg.sender);
        _itemsUnsold.decrement();
    }

    function fetchAllMarketItems() public view returns (WhiskeyItem[] memory) {
        uint256 itemsCount = _itemIds.current();
        WhiskeyItem[] memory inventoryWhiskey = new WhiskeyItem[](itemsCount);
        for (uint256 i = 0; i < itemsCount; i++) {
            inventoryWhiskey[i] = itemID_to_Whiskey[i];
        }
        return inventoryWhiskey;
    }

    // Function to fetch market items
    function fetchListedMarketItems()
        public
        view
        returns (WhiskeyItem[] memory)
    {
        uint256 itemsCount = _itemIds.current();
        uint256 itemsUnsold = _itemsUnsold.current();
        WhiskeyItem[] memory inventoryWhiskey = new WhiskeyItem[](itemsUnsold);
        uint256 inventoryIndex = 0;
        for (uint256 i = 0; i < itemsCount; i++) {
            if (itemID_to_Whiskey[i].owner == address(0)) {
                inventoryWhiskey[inventoryIndex] = itemID_to_Whiskey[i];
                inventoryIndex += 1;
            }
        }

        return inventoryWhiskey;
    }

    function fetchMyNFTs() public view returns (WhiskeyItem[] memory) {
        uint256 itemsCount = _itemIds.current();
        uint256 userItemCount = 0;
        for (uint256 i = 0; i < itemsCount; i++) {
            if (itemID_to_Whiskey[i].owner == payable(msg.sender)) {
                userItemCount += 1;
            }
        }
        WhiskeyItem[] memory inventoryWhiskey = new WhiskeyItem[](
            userItemCount
        );
        uint256 userItemIndex = 0;
        for (uint256 i = 0; i < itemsCount; i++) {
            if (itemID_to_Whiskey[i].owner == payable(msg.sender)) {
                inventoryWhiskey[userItemIndex] = itemID_to_Whiskey[i];
                userItemIndex += 1;
            }
        }

        return inventoryWhiskey;
    }

    function fetchMyNFTsOnSale() public view returns (WhiskeyItem[] memory) {
        uint256 itemsCount = _itemIds.current();
        uint256 userItemCount = 0;
        for (uint256 i = 0; i < itemsCount; i++) {
            if (itemID_to_Whiskey[i].seller == payable(msg.sender)) {
                userItemCount += 1;
            }
        }
        WhiskeyItem[] memory inventoryWhiskey = new WhiskeyItem[](
            userItemCount
        );
        uint256 userItemIndex = 0;
        for (uint256 i = 0; i < itemsCount; i++) {
            if (itemID_to_Whiskey[i].seller == payable(msg.sender)) {
                inventoryWhiskey[userItemIndex] = itemID_to_Whiskey[i];
                userItemIndex += 1;
            }
        }

        return inventoryWhiskey;
    }
}
