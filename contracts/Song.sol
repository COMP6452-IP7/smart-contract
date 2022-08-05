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

    //song info;
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
    
    // song info shown on public;
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

    //song constructor;
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

    //users can get song information from blockchain;
    //return song info;
    function getSongInformation() public view returns (SongInfoPublic memory) {
        return
            SongInfoPublic(
                song.title,
                song.artistAddress,
                song.fileHash,
                song.expirationDate,
                song.license,
                song.artistName
            );
    }

    //user can get song file token to download the song;
    //Require check download permission of the song;
    //Return song file token;
    function getSongFileToken()
        public
        view
        checkDownloadPermisson
        returns (string memory)
    {
        return song.fileToken;
    }

    //Only artists can modify the license of a song;
    function modifySongLicense(Song.LicenseType _license) public onlyArtist {
        song.license = _license;
    }

    //Artists can give license to users;
    //Require only artists can authorise license to users;
    //Require license type is MasterLicense or SyncLicense;
    function giveUserLicensing(address userAddress)
        public
        onlyArtist
        checkLicense
    {
        userLicensing[userAddress] = true;
    }

    //Platforms/users can check if a user is able to use a specific song if:
    //the artist is alive and the user has been authorised the license of the song by the artist;
    //return song's licence type;
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

    //Oracle check if an artist is alive;
    //return bool;
    function updateIsAlive(Oracle _oracle) public returns (bool) {
        _oracle.requestPhase(song.artistName);
        song.artistAlive = _oracle.printResponseAlive();
        return _oracle.printResponseAlive();
    }

    //View ArtistAlive;
    function checkAlive() public view returns (bool) {
        return song.artistAlive;
    }

    //Artist's address is msg.sender;
    modifier onlyArtist() {
        require(song.artistAddress == msg.sender);
        _;
    }
    //A specific song can be downloaded by any user if :
    //the License Type is Unlicensed;
    //the artist has passed away;
    //the user has been authorised license or;
    //the song can be downloaded by the artist self;
    modifier checkDownloadPermisson() {
        bool download = false;
        if (song.license == LicenseType.Unlicensed) {
            download = true;
        } else {
            if (!song.artistAlive) {
                download = true;
            } else {
                if (
                    userLicensing[msg.sender] ||
                    msg.sender == song.artistAddress
                ) {
                    download = true;
                }
            }
        }
        require(download);
        _;
    }
    //check a song's license is either MasterLicense or SyncLicense;
    modifier checkLicense() {
        require(
            song.license == LicenseType.MasterLicense ||
                song.license == LicenseType.SyncLicense
        );
        _;
    }
}
