//SPDX-Lincense-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Whiskey is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;
    address private marketAddress;

    constructor(address contractAddress_) ERC721("Whiskey Token", "JD") {
        marketAddress = contractAddress_;
    }

    function mint_token(string memory tokenURI) public returns (uint256) {
        //Mint NFT and Set its Metadata URI
        uint256 currentTokenId = _tokenId.current();
        _tokenId.increment();
        _safeMint(msg.sender, currentTokenId);
        _setTokenURI(currentTokenId, tokenURI);

        //Approve Marketplace Contract to Manag e NFT
        setApprovalForAll(marketAddress, true);

        //End - Return Minted token_id
        return currentTokenId;
    }
}
