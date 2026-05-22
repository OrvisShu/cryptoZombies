// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./zombiefactory.sol";

abstract contract KittyInterface {
    function getKitty(uint256 _id) external view virtual returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
        );
}

contract ZombieFeeding is ZombieFactory {

    KittyInterface kittyContract;

    modifier ownerOf(uint _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }

    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(block.timestamp + cooldownTime);
    }

    function _isReady(Zombie storage _zombie) internal view returns(bool) {
        return _zombie.readyTime <= block.timestamp;
    }


    function feeAndMultiply(uint256 _zombieId, uint256 _targetDna, string memory _species) internal ownerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        require(_isReady(myZombie));
        uint256 newDna = (_targetDna + myZombie.dna) / 2;
        if(keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
            newDna = newDna - newDna % 100 + 99;
        }
        _createZombie("NoName", newDna);
        _triggerCooldown(myZombie);
    }

    function feeOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        (,,,,,,,,,uint256 kittyDna) = kittyContract.getKitty(_kittyId);
        feeAndMultiply(_zombieId, kittyDna, "kitty");
    }

}