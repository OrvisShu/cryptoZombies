// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./zombiehelper.sol";

contract ZombieAttack is ZombieHelper {
    uint randNonce = 0;
    uint attackVictoryProbility = 70;

    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        uint _tmp = uint256(keccak256(abi.encodePacked(block.prevrandao, msg.sender, randNonce)));
        return  _tmp % _modulus;
    }

    function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage targetZombie = zombies[_targetId];
        uint rand = randMod(100);
        if(rand >= attackVictoryProbility) {
            myZombie.winCount++;
            myZombie.level++;
            targetZombie.lossCount++;
            feeAndMultiply(_zombieId, targetZombie.dna, "zombie");
        } else {
            myZombie.lossCount++;
            targetZombie.winCount++;
            _triggerCooldown(myZombie);
        }
    }
    


}