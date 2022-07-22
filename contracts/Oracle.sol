// SPDX-License-Identifier: UNLICENSE
pragma solidity >=0.4.25 <0.9.0;

import "./Song.sol";

contract OracleContract{

    bool public isAlive = true; 

    event artistRequest(string name);

    function requestAlive(string memory artistName) private
    {
        emit artistRequest(artistName); 
    }

    function requestPhase(string memory artistName) public {
        requestAlive(artistName);
    }

    function responseAlive(bool alive) public {
        isAlive = alive; 
    }

    function printResponseAlive() public view returns (bool)
    {
        return isAlive; 
    }

    function isAliveorNot() view public returns (bool)
    {
        return isAlive; 
    }

}