// SPDX-License-Identifier: GPL-3.0
// No need to use SafeMath, as lowest allowed version is 0.8.0
pragma solidity ^0.8.0;

contract Web3Place {

    address public owner;

    struct Pixel {
        address owner;  //initializes to 0x0
        uint soldPrice; //initializes to 0x0
        bytes3 colour;  //initializes to 0x0
    }  

    Pixel[1000][1000] public pixels;    //all pixels will have initial values
    mapping(address => uint) public pendingRefunds; //For implementation of pull payments pattern

    event PixelColourChanged(uint x, uint y, bytes3 color);
    event PixelOwnerChanged(uint x, uint y, address owner, uint soldPrice);

    constructor() {
        owner = msg.sender;
    }

    //Pixel buying logic is as follows. To buy a pixel from someone, you must buy it for 1 "unit" more than they bought it for.
    //This implies the starting price for all pixels is 1 unit.
    //1 Unit will be 1 ether in this function out of convenience, but you could set it to anything. 
    //1 ether is probably too costly in reality.

    function buyPixel(uint x, uint y) public payable{
        Pixel storage pixel = pixels[x][y];
        require(msg.value >= pixel.soldPrice + 1 ether);

        if(pixel.owner != address(0x0)){
            pendingRefunds[pixel.owner] += msg.value;
        }
        else{
            //Initial pixel purchases go to contract owner
            pendingRefunds[owner] += msg.value;
        }

        pixel.owner = msg.sender;
        pixel.soldPrice = msg.value;

        emit PixelOwnerChanged(x, y, pixel.owner, pixel.soldPrice);
    }

    function changePixelColour(uint x, uint y, bytes3 colour) public{
        Pixel storage pixel = pixels[x][y];
        require(pixel.owner == msg.sender);

        pixel.colour = colour;

        emit PixelColourChanged(x, y, pixel.colour);
    }

    function withdrawProfit() public {
        address payee = msg.sender;
        uint payment = pendingRefunds[payee];
        
        require(payment > 0);
        require(address(this).balance >= payment);

        pendingRefunds[payee] = 0;
        payable(payee).transfer(payment);
    }

    /*These functions are for testing. This will be removed from the contract as it can be done in the front end of the implementation (although they are pure so should not affect gas cost either way)*/
    function uint8tohexchar(uint8 i) public pure returns (uint8) {
        return (i > 9) ?
            (i + 87) : // ascii a-f
            (i + 48); // ascii 0-9
    }

    function uint24tohexstr(uint24 i) public pure returns (string memory) {
        bytes memory o = new bytes(6);
        uint24 mask = 0x00000f;
        o[5] = bytes1(uint8tohexchar(uint8(i & mask)));
        i = i >> 4;
        o[4] = bytes1(uint8tohexchar(uint8(i & mask)));
        i = i >> 4;
        o[3] = bytes1(uint8tohexchar(uint8(i & mask)));
        i = i >> 4;
        o[2] = bytes1(uint8tohexchar(uint8(i & mask)));
        i = i >> 4;
        o[1] = bytes1(uint8tohexchar(uint8(i & mask)));
        i = i >> 4;
        o[0] = bytes1(uint8tohexchar(uint8(i & mask)));
        return string(o);
    }

    function colourToHexString(bytes3 i) public pure returns (string memory) {
        uint24 n = uint24(i);
        return uint24tohexstr(n);
    }
}
