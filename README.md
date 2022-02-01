# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```

# How it got here

1. Initial Setup
```shell
npx create-next-app nft-marketplace-whiskey
cd .\nft-marketplace-whiskey\
npm install ethers hardhat @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers web5modal @openzeppelin/contracts ipfs-http-client axios
npm install add -D tailwindcss@latest postcss@latest autoprefixer@latest
npx tailwindcss init -p
npx hardhat
```
