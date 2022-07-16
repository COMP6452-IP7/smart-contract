// SPDX-License-Identifier: UNLICENSE
pragma solidity >=0.4.25 <0.9.0;

contract Song {
    enum LicenseType {
        Unlicensed,
        MasterLicense,
        SyncLicense
    }

    struct SongInfo {
        string title;
        // address[] artists;
        mapping(address => bool) artists;
        bytes32 fileHash;
        uint256 expirationDate;
        LicenseType license;
        bool artistAlive;
    }

    constructor() {}
}
