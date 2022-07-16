// SPDX-License-Identifier: UNLICENSE
pragma solidity >=0.4.25 <0.9.0;

import "./Song.sol";

contract SongStorage {
    mapping(uint256 => Song.SongInfo) private _songs;
    uint256 private _songIdIndex = 0;

    modifier onlyArtist(uint256 songid) {
        require(_songs[songid].artists[msg.sender]);
        _;
    }

    constructor() {}

    function uploadSong(
        string memory title,
        bytes32 fileHash,
        uint256 expirationDate,
        Song.LicenseType license,
        address[] memory artists
    ) public {
        // TODO: check if msg.sender is an artist
        Song.SongInfo storage newSong = _songs[_songIdIndex++];
        newSong.title = title;
        newSong.fileHash = fileHash;
        newSong.expirationDate = expirationDate;
        newSong.license = license;
        newSong.artistAlive = true;
        for (uint256 i = 0; i < artists.length; i++) {
            newSong.artists[artists[i]] = true;
        }
    }

    function modifySongLicense(
        uint256 songId,
        Song.LicenseType license
    ) public onlyArtist(songId) {
        _songs[songId].license = license;
    }
}
