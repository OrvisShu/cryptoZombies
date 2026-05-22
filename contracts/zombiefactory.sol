// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ownable.sol";

contract ZombieFactory is Ownable {

    /**
     Events are a way for your contract to communicate that something happened on the blockchain to your app front-end,
     which can be 'listening' for certain events and take action when they happen.
     用于前端监听你的智能合约发生了什么事件，并针对事件做出后续处理逻   辑
    **/
    event NewZombie(uint256 zombieId, string name, uint256 dna);

    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10 ** dnaDigits;
    uint256 cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint256 dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;
    mapping (uint256 => address) zombieToOwner;
    mapping (address => uint256) ownerZombieCount;
    
    function _createZombie(string memory _name, uint256 _dna) internal {
        zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
        uint256 id = zombies.length - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    // view it's only viewing the data but not modifying it:
    // pure means you're not even accessing any data in the app. 如果不访问已存储属性，则可以使用 pure 修饰符
    function _generateDna(string memory _str) private view returns (uint256) {
        uint256 rand = (uint256)(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint256 dna = _generateDna(_name);
        _createZombie(_name, dna);
    }

}