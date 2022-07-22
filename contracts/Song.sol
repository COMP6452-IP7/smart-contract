// SPDX-License-Identifier: UNLICENSE
pragma solidity >=0.4.25 <0.9.0;

contract Song {
    enum LicenseType {
        NoLicense, 
        Unlicensed,
        MasterLicense,
        SyncLicense
    }

    struct SongInfo {
        string title;
        mapping(address => bool) artists;
        bytes32 fileHash;
        uint256 expirationDate;
        LicenseType license;
        bool artistAlive;
    }

    SongInfo song; 
    mapping(address => bool) userLicensing;

    constructor(string memory title,
        bytes32 fileHash,
        uint256 expirationDate,
        Song.LicenseType license,
        address[] memory artists) 
    {
        song.title = title;
        song.fileHash = fileHash;
        song.expirationDate = expirationDate;
        song.license = license;
        song.artistAlive = true;
        for (uint256 i = 0; i < artists.length; i++) {
            song.artists[artists[i]] = true;
        }
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


    modifier onlyArtist() {
        require(song.artists[msg.sender]);
        _;
    }

    modifier checkLicense()
    {
        require(song.license == LicenseType.MasterLicense || song.license == LicenseType.SyncLicense);
        _;
    }

}
