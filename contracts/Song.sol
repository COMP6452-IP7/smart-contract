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
        bool artistAlive;
        string fileToken;
    }

    struct SongInfoPublic {
        string title;
        address artistAddress;
        string fileHash;
        uint256 expirationDate;
        LicenseType license;
        string artistName;
    }

    SongInfo song;
    mapping(address => bool) userLicensing;

    constructor(
        string memory title,
        string memory fileHash,
        uint256 expirationDate,
        Song.LicenseType license,
        string memory artistName,
        address artistAddress,
        string memory fileToken
    ) {
        song.title = title;
        song.fileHash = fileHash;
        song.expirationDate = expirationDate;
        song.license = license;
        song.artistName = artistName;
        song.artistAddress = artistAddress;
        song.fileToken = fileToken;
    }

    function getSongInformation() public view returns (SongInfoPublic memory) {
        return SongInfoPublic(
            song.title,
            song.artistAddress,
            song.fileHash,
            song.expirationDate,
            song.license,
            song.artistName
        );
    }

    function getSongFileToken() public view onlyLicensed returns (string memory) {
        return song.fileToken;
    }

    function modifySongLicense(Song.LicenseType _license) public onlyArtist {
        song.license = _license;
    }

    function giveUserLicensing(address userAddress)
        public
        onlyArtist
        checkLicense
    {
        userLicensing[userAddress] = true;
    }

    function getUserLicensing(address userAddress)
        public
        view
        returns (LicenseType)
    {
        if (userLicensing[userAddress]) {
            if (checkAlive()) {
                return song.license;
            } else {
                return LicenseType.Unlicensed;
            }
        } else {
            return LicenseType.NoLicense;
        }
    }

    function updateIsAlive(Oracle _oracle) public returns (bool) {
        _oracle.requestPhase(song.artistName);
        song.artistAlive = _oracle.printResponseAlive();
        return _oracle.printResponseAlive();
    }

    function checkAlive() public view returns (bool) {
        return song.artistAlive;
    }

    modifier onlyArtist() {
        require(song.artistAddress == msg.sender);
        _;
    }

    modifier onlyLicensed() {
        bool licensed = false;
        if (song.license == LicenseType.Unlicensed) {
            licensed = true;
        } else {
            if (!song.artistAlive) {
                licensed = true;
            } else {
                if (userLicensing[msg.sender] || msg.sender == song.artistAddress) {
                    licensed = true;
                }
            }
        }
        require(licensed);
        _;
    }

    modifier checkLicense() {
        require(
            song.license == LicenseType.MasterLicense ||
                song.license == LicenseType.SyncLicense
        );
        _;
    }
}
