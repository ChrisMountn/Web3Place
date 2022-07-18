# Web3Place
Solidity Project - This is the backend for a pixel-auction site like r/place or the million dollar homepage I am creating. Repository is still in testing and subject to change.

The contract holds a 1000x1000 array of pixel structs, which compose the full million-pixel image that is displayed on the browser. Users can buy pixels from the original deployer of the contract, for 1 unit (currently set at 1 ether in the script, but practically speaking, this is too high). Other users can buy currently owned pixels, but must pay the current owner 1 unit more than the pixel was previously bought for. The owner of a pixel can change the colour at any time. I am aiming to build the frontend for this DAPP using web3.js soon. 

The solidity code is contained in Web3Place/Web3_Place_Truffle/contracts/Web3Place.sol. 
The unit tests written in JavaScript are contained in Web3Place/Web3_Place_Truffle/test/web3_place_test.js
