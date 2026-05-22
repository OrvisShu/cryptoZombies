// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    uint levelUpFee = 0.001 ether;

    modifier aboveLevel(uint32 _level, uint256 _zombieId) {
        zombies[_zombieId].level >= _level;
        _;
    }

    function withdraw() external payable {
        address payable _owner = payable((owner()));
        _owner.transfer(address(this).balance);
        // 简介写法：
        // payable(owner()).transfer(address(this).balance);
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function levelUp(uint _zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[_zombieId].level++;
    }

    function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) onlyOwnerOf(_zombieId) {
        zombies[_zombieId].name = _newName;
    }
    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) onlyOwnerOf(_zombieId) {
        require(zombieToOwner[_zombieId] == msg.sender);
        zombies[_zombieId].dna = _newDna;
    }

    function getZombieByOwner(address _owner) external view returns (uint[] memory) {
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;
        for (uint256 _id = 0; _id < zombies.length; _id++) {
            if (zombieToOwner[_id] == _owner) {
                result[counter] = _id;
                counter++;
            }
        }
        return result;
    }


}