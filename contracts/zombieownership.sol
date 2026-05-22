// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./zombieattack.sol";
import "./erc721.sol";


abstract contract ZombieOwnership is ZombieAttack , ERC721{

    mapping (uint256 => address) zombieApprovals;

    function balanceOf(address _owner) external view returns (uint256) {
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return zombieToOwner[_tokenId];
    }

    function _transfer(address _to, uint256 _tokenId) private {
        address beforeOwner = zombieToOwner[_tokenId];
        if(beforeOwner == _to) {
            return;
        }
        ownerZombieCount[beforeOwner]--;
        ownerZombieCount[_to]++;
        zombieToOwner[_tokenId] = _to;
        emit Transfer(beforeOwner, _to, _tokenId);
    }

    // 这里可以发起人持有该 token ，也可以发起人被授权转让该 token
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
        _transfer(_to, _tokenId);
    }
    function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
        zombieApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}