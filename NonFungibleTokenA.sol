// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NonFungibleTokenA is ERC721A,Ownable {
    
    // total 1000 NFTs can be minted
    uint256 constant public MaximumSupply = 20;
    
    //Mint Fee per NFT
    uint256 private firstPhaseFee;
    
    uint256 private secondPhaseFee;
    
    uint256 private thirdPhaseFee;
    //No of NFTs can be minted by one User
    uint256  private maxNFTsPerUser;

    //base URI
    string baseTokenURI;

    constructor() ERC721A("NonFungible Token A","NFA"){}

    mapping(address => uint256) private mintedNFTs;

    function MintInphaseOne(address to, uint256 quantity) external payable {
        isValidAddress(to);
        NFTsMintLimit(to,quantity);
        notBeZero(quantity);
        maxSupply(quantity);
        require(quantity <= 10, "Can't mint more than 10");
        require(_nextTokenId() <=10, "can not mint");
        require(msg.value == quantity*firstPhaseFee, "Invalid total Minting");
        mintedNFTs[to] += quantity;
        _mint(to, quantity);
    }
     function MintInphaseTwo(address to, uint256 quantity) external payable {
        isValidAddress(to);
        NFTsMintLimit(to,quantity);
        notBeZero(quantity);
        maxSupply(quantity);
        require(quantity <= 6, "Can't mint more than 10");
        require(_nextTokenId() >10 &&  _nextTokenId() <= 16, "can not mint");
        require(msg.value == quantity*secondPhaseFee, "Invalid total Minting");
        mintedNFTs[to] += quantity;
        _mint(to, quantity);
    }
     function MintInphaseThree(address to, uint256 quantity) external payable {
        isValidAddress(to);
        NFTsMintLimit(to,quantity);
        notBeZero(quantity);
        maxSupply(quantity);
        require(quantity <= 4, "Can't mint more than 10");
        require(_nextTokenId() >16 &&  _nextTokenId() <= 20, "can not mint");
        require(msg.value == quantity*thirdPhaseFee, "Invalid total Minting");
        mintedNFTs[to] += quantity;
        _mint(to, quantity);
    }

    function isValidAddress(address account) internal pure {
        require(account != address(0), "Invalid address");
    }

    function NFTsMintLimit(address to, uint256 quantity) internal view {
        require(mintedNFTs[to] + quantity <= maxNFTsPerUser, "can't mint more than Limit");
    }

    function notBeZero(uint256 quantity) internal pure {
        require(quantity >0, "invalid Quantity");
    }
     
    function maxSupply(uint256 quantity) internal view {
        require(totalSupply() + quantity <= MaximumSupply,"Exceeds Max Supply");
    }
    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function withdraw() external onlyOwner {
        require(address(this).balance >0, "unsufficient funds");
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer Failed");
    }

    function setPhasesFee(uint256 _phaseOneFee, uint256 _secondPhaseFee, uint256 _thirdPhaseFee) external onlyOwner{
        firstPhaseFee = _phaseOneFee;
        secondPhaseFee = _secondPhaseFee;
        thirdPhaseFee = _thirdPhaseFee;
    }

    function getFirstPhaseFee() external view returns(uint256) {
        return firstPhaseFee;
    }
    
    function getSecondPhaseFee() external view returns(uint256) {
        return firstPhaseFee;
    }
    function getThirdPhaseFee() external view returns(uint256) {
        return firstPhaseFee;
    }
    function setBaseURI(string calldata baseURI) external onlyOwner {
        require(bytes(baseURI).length > 0, "Invalid baseURI");
        baseTokenURI = baseURI;
    }

    function setNFTsPerUser(uint256 _maxNFTsPerUser) external onlyOwner {
        require(_maxNFTsPerUser >0,"invalid NFTs");
        maxNFTsPerUser = _maxNFTsPerUser;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function getNfTsPerUser() external view returns(uint256) {
        return maxNFTsPerUser;
    }
 
}