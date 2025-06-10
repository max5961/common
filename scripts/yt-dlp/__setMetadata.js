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

        const title = `-metadata title='${metadata.songName}'`;
        const track = `-metadata track='${metadata.trackNumber}'`;
        const artist = `-metadata artist='${metadata.artist}'`;
        const album = `-metadata album='${metadata.album}'`;

        try {
            const tmp = path.join(os.tmpdir(), `metadata-${fname}`);
            execSync(
                `ffmpeg -i "${fpath}" ${track} ${title} ${artist} ${album} -codec copy "${tmp}"`,
                { stdio: "ignore" },
            );
            fs.renameSync(tmp, fpath);
            console.log(`Metadata set: \x1b[33m${fname}\x1b[0m`);
        } catch (err) {
            console.log(
                `Error setting metadata for: '${metadata.songName}', ${err.message}`,
            );
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
