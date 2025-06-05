const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const { execSync } = require("node:child_process");

const artist = process.env.ARTIST;
const album = process.env.ALBUM;
const directory = path.join(os.homedir(), "Music", artist, album);

function setMetaData() {
    const dcontents = fs.readdirSync(directory);
    for (const fname of dcontents) {
        const fpath = path.join(directory, fname);
        const metadata = getMetaData(fname);

        const setTrack = `-c 'set track "${metadata.trackNumber}"'`;
        const setTitle = `-c 'set title "${metadata.songName}"'`;
        const setArtist = `-c 'set artist "${metadata.artist}"'`;
        const setAlbum = `-c 'set album "${metadata.album}"'`;

        try {
            execSync(
                `kid3-cli ${setTrack} ${setTitle} ${setArtist} ${setAlbum} "${fpath}"`,
            );
            console.log(`Setting metadata for: '${metadata.songName}'`);
        } catch (err) {
            console.log(`Error setting metadata for: '${metadata.songName}'`);
        }
    }
}

function getMetaData(file) {
    const metaData = {
        artist,
        album,
        songName: null,
        trackNumber: null,
    };

    const split = file.split("<<>>");
    metaData.trackNumber = split[0].trim();
    extractSongName(metaData, split[1].trim());

    return metaData;
}

function extractSongName(metaData, songName) {
    // Trim extension
    const ext = path.extname(songName);
    if (songName.endsWith(ext)) {
        songName = songName.slice(0, songName.length - ext.length);
    }

    const splitHyphen = songName.split("-");
    if (splitHyphen.length > 1) {
        const left = splitHyphen[0].trim();
        const right = splitHyphen[1].trim();
        const artist = metaData.artist.toUpperCase().trim();
        const album = metaData.artist.toUpperCase().trim();

        if (left.toUpperCase() === artist || left.toUpperCase() === album) {
            songName = right;
        }
    }

    songName = songName
        .replace(
            /\([^)]*(official|edition|audio|original|video|lyric|music|4k|HD|HQ)[^)]*\)/gi,
            "",
        )
        .trim();
    songName = songName
        .replace(
            /\[[^)]*(official|edition|audio|original|video|lyric|music|4k|HD|HQ)[^\]]*\]/gi,
            "",
        )
        .trim();
    songName = songName.replace(/\'/g, `'\\''`);
    metaData.songName = songName;
    metaData.album = metaData.album.replace(/\'/g, `'\\''`);
}

setMetaData();
