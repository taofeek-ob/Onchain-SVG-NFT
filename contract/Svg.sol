// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "base64-sol/base64.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract SvgNFT is ERC721Enumerable,  ERC721URIStorage  {
// Magic given to us by OpenZeppelin to help us keep track of tokenIds.
using Counters for Counters.Counter;
Counters.Counter private _tokenIds;
// This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
// So, we make a baseSvg variable here that all our NFTs can use.
string baseSvg = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="500%" fill="grey" /><text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">';
// I create three arrays, each with their own theme of random words.
// Pick some random funny words, names of anime characters, foods you like, whatever!
string[] firstWords = ["TAOFEEK", "FRANK", "YUSSUF", "WANDE", "SHEYI", "JEGA", "MEEDAH","FOOD-PLEXUS", "RXBIU"]; 
 
string[] secondWords = ["RUNS", "ADMIRES", "DISLIKES", "LOVES", "IS", "BELIEVES"];
string[] thirdWords = ["BUTTERFLY", "PINEAPPLE", "WATTERMELON", "APPLE", "PONMO", "MANGO", "TEA"];

// We need to pass the name of our NFTs token and its symbol.
constructor() ERC721 ("SVGNFT", "TVG") {

}


// I create a function to randomly pick a word from each array.
function pickRandomFirstWord(uint256 tokenId) internal view returns (string memory) {
// I seed the random generator. More on this in the lesson.
uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
// Squash the # between 0 and the length of the array to avoid going out of bounds.
rand = rand % firstWords.length;
return firstWords[rand];
}
function pickRandomSecondWord(uint256 tokenId) internal view returns (string memory) {
uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
rand = rand % secondWords.length;
return secondWords[rand];
}
function pickRandomThirdWord(uint256 tokenId) internal view returns (string memory) {
uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
rand = rand % thirdWords.length;
return thirdWords[rand];
}
function random(string memory input) internal pure returns (uint256) {
return uint256(keccak256(abi.encodePacked(input)));
}



function formatTokenURI(string memory imageURI) internal pure returns (string memory) {
        return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "SVG NFT", // You can add whatever name here
                                '", "description":"An NFT based on SVG! Created by TAOFEEK", "attributes":"", "image":"',imageURI,'"}'
                            )
                        )
                    )
                )
            );
    }
function makeAnEpicNFT() public {
uint256 newItemId = _tokenIds.current();
// We go and randomly grab one word from each of the three arrays.
string memory first = pickRandomFirstWord(newItemId);
string memory second = pickRandomSecondWord(newItemId);
string memory third = pickRandomThirdWord(newItemId);
// I concatenate it all together, and then close the <text> and <svg> tags.
string memory finalSvg = string(abi.encodePacked(baseSvg, " ", first, " ", second, " ", third, "</text></svg>"));


 string memory baseURL = "data:image/svg+xml;base64,";
string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(finalSvg))));
string memory imageURI = string(abi.encodePacked(baseURL,svgBase64Encoded));

// Actually mint the NFT to the sender using msg.sender.
_safeMint(msg.sender, newItemId);
// Set the NFTs data.
_setTokenURI(newItemId, formatTokenURI(imageURI));

// Increment the counter for when the next NFT is minted.
_tokenIds.increment();
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
