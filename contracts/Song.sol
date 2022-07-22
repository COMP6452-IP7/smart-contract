// SPDX-License-Identifier: UNLICENSE
pragma solidity >=0.4.25 <0.9.0;


import "./Oracle.sol";

contract Song {
    enum LicenseType {
        NoLicense, 
        Unlicensed,
        MasterLicense,
        SyncLicense
    }

    struct SongInfo {
        string title;
        address artistAddress;
        string fileHash;
        uint256 expirationDate;
        LicenseType license;
        string artistName; 
    }

    bool public artistAlive = true; 
    SongInfo song; 
    mapping(address => bool) userLicensing;

    constructor(string memory title,
        string memory fileHash,
        uint256 expirationDate,
        Song.LicenseType license,
        string memory artistName,
        address artistAddress) 
    {
        song.title = title;
        song.fileHash = fileHash;
        song.expirationDate = expirationDate;
        song.license = license;
        song.artistName = artistName; 
        song.artistAddress = artistAddress;
    }

    function modifySongLicense(
        Song.LicenseType license
    ) public onlyArtist {
        song.license = license;
    }


    function giveUserLicensing(address userContractAddress) public onlyArtist checkLicense
    {
        userLicensing[userContractAddress] = true; 
    }

    function getUserLicensing(address userContractAddress) public view returns (LicenseType)
    {
        if (userLicensing[userContractAddress])
        {
            return song.license; 
        }
        else
        {
            return LicenseType.NoLicense;
        }
    }

    function isAlive(OracleContract _oracle) public {
        _oracle.requestPhase(song.artistName);
    }

    function stillAlive(OracleContract _oracle) public view returns (bool)
    {
        return _oracle.printResponseAlive();
    }


    modifier onlyArtist() {
        require(song.artistAddress == msg.sender);
        _;
    }

    modifier checkLicense()
    {
        require(song.license == LicenseType.MasterLicense || song.license == LicenseType.SyncLicense);
        _;
    }
}
