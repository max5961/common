#!/usr/bin/env node

const fs = require("node:fs");
const path = require("node:path");
const os = require("node:os");
const chproc = require("node:child_process");

const artist = process.env.ARTIST;
const album = process.env.ALBUM;

main(artist, album);

function main(artist, album) {
    if (album) {
        setMetadata(artist, album);
    } else {
        const albums = getDirContents(artist);
        albums.forEach((album) => setMetadata(artist, album));
    }
}

/**
 * @param {string} artist
 * @param {string | undefined} album
 * */
function setMetadata(artist, album) {
    const files = getDirContents(artist, album);

    files.forEach((fname) => {
        const fpath = path.join(getDirectory(artist, album), fname);
        const metadata = getMetaData(fname, album);

        const metaTitle = `-metadata title='${metadata.songName}'`;
        const metaTrack = `-metadata track='${metadata.trackNumber}'`;
        const metaArtist = `-metadata artist='${metadata.artist}'`;
        const metaAlbum = `-metadata album='${metadata.album}'`;

        try {
            const tmp = path.join(os.tmpdir(), `metadata-${fname}`);

            chproc.execSync(
                `ffmpeg -y -i ` +
                    `'${fpath}' ` +
                    `-map_metadata -1 ` +
                    `${metaTrack} ` +
                    `${metaTitle} ` +
                    `${metaArtist} ` +
                    `${metaAlbum} ` +
                    `-codec copy ` +
                    `'${tmp}'`,
                { stdio: "ignore" },
            );

            fs.copyFileSync(tmp, fpath);
            console.log(`Metadata set: \x1b[33m${fname}\x1b[0m`);
        } catch (err) {
            console.log(
                `Error setting metadata for: '${metadata.songName}'\n\t ${err.message}`,
            );
        }
    });
}

function getDirContents(artist, album) {
    return fs.readdirSync(getDirectory(artist, album));
}

function getDirectory(artist, album) {
    const args = album ? ["Music", artist, album] : ["Music", artist];
    return path.join(os.homedir(), ...args);
}

function getMetaData(file, album) {
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
