// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Loyalty is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;   // Counts NFT tokenIds
    Counters.Counter private _firmIdCounter;    // Counts registered firm IDs.

    struct Firm {
        address addr;
        uint256 id;
        uint256[] tokens;
        address[] customers;
        bool registered;
    }

    mapping(address => Firm) public firm;


    constructor() ERC721("Loyalty", "LYL") {}

    function registerFirm(address _firmAddr) public {
        firm[_firmAddr].addr = _firmAddr;
        firm[_firmAddr].id = _firmIdCounter.current();
        _firmIdCounter.increment();
        firm[_firmAddr].registered = true;
    }

    function mintLoyaltyNFT(address firmAddr, address customerAddr, string memory uri) public {
        require(firm[firmAddr].registered, "Firm must be registered!");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(customerAddr, tokenId);
        _setTokenURI(tokenId, uri);

        firm[firmAddr].tokens.push(tokenId);
        firm[firmAddr].customers.push(customerAddr);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
