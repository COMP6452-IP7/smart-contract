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

    function getSongInformation() public view returns (SongInfo memory)
    {
        return song;
    }

    function modifySongLicense(Song.LicenseType _license) public onlyArtist {
        song.license = _license;
    }

    function giveUserLicensing(address userAddress) public onlyArtist checkLicense
    {
        userLicensing[userAddress] = true;
    }

    function getUserLicensing(address userAddress, Oracle _oracle) public view returns (LicenseType)
    {
        if (userLicensing[userAddress]) {
            if (checkAlive(_oracle)) {
                return song.license;
            } else {
                return LicenseType.Unlicensed;
            }
        } else {
            return LicenseType.NoLicense;
        }
    }

    function updateIsAlive(Oracle _oracle) public returns (bool)
    {
        _oracle.requestPhase(song.artistName);
        return _oracle.printResponseAlive();
    }

    function checkAlive(Oracle _oracle) public view returns (bool)
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
