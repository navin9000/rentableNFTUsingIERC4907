//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

import "https://github.com/ethereum/EIPs/blob/master/assets/eip-4907/contracts/IERC4907.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

//IERC4907 is like extension to the ERC721
//mainly three functions required
//1.setUser() , userOf()  and userExpries() 

contract ERC4907 is ERC721,IERC4907{
    
    uint tokenId=0;

    struct userInfo{
        address userAddress;
        uint expires;
    }
    mapping(uint => userInfo) rentUsers;

    constructor()ERC721("naveen","pc"){

    }

    //minting function
    function minting()external{
        _mint(msg.sender,tokenId);
        tokenId++;
    }

    function setUser(uint256 _tokenId, address _user, uint64 _expires) public virtual override{
        require(_isApprovedOrOwner(msg.sender,_tokenId), "ERC4907: transfer caller is not owner nor approved");
        userInfo storage info =  rentUsers[_tokenId];
        info.userAddress = _user;
        info.expires = _expires+block.timestamp;
        emit UpdateUser(_tokenId, _user, _expires);
    }

    function userOf(uint256 _tokenId) public view virtual override returns(address ){
        if( block.timestamp <= rentUsers[_tokenId].expires){
            return  rentUsers[_tokenId].userAddress;
        }
        else{
            return address(0);
        }
    }

    function userExpires(uint256 _tokenId) public view virtual override returns(uint256){
        return rentUsers[_tokenId].expires;
    }


}