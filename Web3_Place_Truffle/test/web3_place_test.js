const Web3Place = artifacts.require("Web3Place");
const truffleAssert = require('truffle-assertions');

contract("Web3Place", accounts => {
    
    it("constructor should set pixels to initial values", async () => {
        let instance = await Web3Place.deployed();
        let pixel = await instance.pixels(680, 245);
        assert.equal(pixel.colour, 0x000000);
        assert.equal(pixel.soldPrice, 0x00000);
        assert.equal(pixel.owner, 0x00000);
    });
    
    it("owner should be accounts[0]", async () => {
        let instance = await Web3Place.new();
        let owner = await instance.owner();
        assert.equal(owner, accounts[0]);
    });
    
    it("testing buyPixel", async () => {
        let instance = await Web3Place.new();
        await instance.buyPixel(1, 2, {value: web3.utils.toWei("1", "Ether"), from: accounts[1]});
        await instance.buyPixel(1, 2, {value: web3.utils.toWei("2", "Ether"), from: accounts[3]});
        let pixel = await instance.pixels(1, 2);
        assert.equal(pixel.owner, accounts[3]);
    });

    it("testing changePixelColour", async () => {
        let instance = await Web3Place.new();
        await instance.buyPixel(43, 987, {value: web3.utils.toWei("1", "Ether"), from: accounts[1]});
        await instance.changePixelColour(43, 987, web3.utils.numberToHex(web3.utils.hexToNumber('0xeaff08')), {from: accounts[1]});
        let pixel = await instance.pixels(43, 987);
        assert.equal(pixel.colour, 0xeaff08);
    });
    
    it("testing withdrawProfit", async () => {
        let instance = await Web3Place.new();
        await instance.buyPixel(1, 2, {value: web3.utils.toWei("1", "Ether"), from: accounts[1]});
        await instance.buyPixel(1, 2, {value: web3.utils.toWei("3", "Ether"), from: accounts[3]});
        await instance.withdrawProfit({from: accounts[1]});
        //check account value in network. Should have incremented by 2 from original value. 
    });
    
});