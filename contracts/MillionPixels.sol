pragma solidity ^0.4.21;


contract MillionPixels {
    address public owner;

    // Number of pixels that are available to sell
    uint32 private pixelsAvailable = 1000000;

    // Number of sold pixels
    uint32 public pixelsSold = 0;

    // Price for one pixel
    uint256 public pixelPrice = 1 ether;

    // Mapping from pixel number to owner
    mapping (uint32 => address) private pixelOwner;

    // Mapping from pixel number to pixel color
    mapping (uint32 => string) private pixelColor;

    modifier isSold(uint32 _pixelNumber) {
        require(pixelOwner[_pixelNumber] != address(0));
        _;
    }

    function MillionPixels() public {
        owner = msg.sender;
    }

    function buyPixel(uint32 _pixelNumber) public payable {
        require(msg.sender != address(0));
        require(msg.value == pixelPrice);
        require(pixelOwner[_pixelNumber] == address(0));

        pixelOwner[_pixelNumber] = msg.sender;
        pixelsSold++;
    }

    function removePixel(uint32 _pixelNumber) public payable isSold(_pixelNumber) {
        require(msg.sender == owner);

        // reset and transfer funds back to buyer
        address _pixelOwner = pixelOwner[_pixelNumber];
        pixelOwner[_pixelNumber] = 0;
        pixelColor[_pixelNumber] = "";
        _pixelOwner.transfer(pixelPrice);
        pixelsSold--;
    }

    function setPixelColor(uint32 _pixelNumber, string _pixelColor) public isSold(_pixelNumber) {
        require(pixelOwner[_pixelNumber] == msg.sender);
        validateColorString(_pixelColor);
        pixelColor[_pixelNumber] = _pixelColor;
    }

    function getFreePixelCount() public view returns (uint32) {
        return (pixelsAvailable - pixelsSold);
    }

    function getPixelOwner(uint32 _pixelNumber) public view isSold(_pixelNumber) returns (address) {
        return pixelOwner[_pixelNumber];
    }

    function getPixelColor(uint32 _pixelNumber) public view isSold(_pixelNumber) returns (string) {
        return pixelColor[_pixelNumber];
    }

    // validate that the color is in hex format e.g. (#c5cef7)
    function validateColorString(string str) private pure {
        bytes memory strBytes = bytes(str);
        require(strBytes.length == 6);

        for (uint8 i; i < 6; i++) {
            require(
                strBytes[i] >= 48 && strBytes[i] <= 57 ||
                strBytes[i] >= 97 && strBytes[i] <= 102
            );
        }
    }
}
