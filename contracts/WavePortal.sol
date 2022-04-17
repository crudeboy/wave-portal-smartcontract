// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

      /*
     * We will be using this below to help generate a random number
     */
    uint256 private seed;

    mapping(address => uint256) addressTrack;
    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    Wave[] waves;
    mapping(address => uint256) public lastWavedAt;

    constructor () payable {
        console.log("I AM SMART CONTRACT. POG.");
        console.log("My geez, your gee is running some smart stuffs here!!!");
        console.log(msg.sender, "msg.sender");

         /*
         * Set the initial seed
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(address userAddress, string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 15m"
        );
        lastWavedAt[msg.sender] = block.timestamp;
        addressTrack[userAddress] += 1;
        totalWaves += 1;
        console.log("%s waved w/ message %s", msg.sender, _message);
        console.log("%s has waved!", msg.sender);
        console.log("%s %s %s",msg.sender, _message, block.timestamp);
        waves.push(Wave(msg.sender, _message, block.timestamp));

        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        if(seed <= 50){
            console.log("%s won!", msg.sender);

            //removing ether from the smart contract's launchers address
            uint256 prizeAmount = 0.0001 ether;
            require( //check if balance is adequate
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            console.log( prizeAmount <= address(this).balance, " prizeAmount <= address(this).balance,");

            //interesting way to write smart contracts
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
            console.log(success, "success");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getNumberOfWavesByGee(address userAddress) public view returns (uint256){
        require(addressTrack[userAddress] > 0, "You never wave me be that ooo, u no try at all!!!");
        return addressTrack[userAddress];
    }
}