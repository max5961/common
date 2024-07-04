const fs = require("node:fs/promises");
const path = require("node:path");
const os = require("node:os");
const { exec } = require("node:child_process");

const artist = process.env.ARTIST;
const album = process.env.ALBUM;

const directory = path.join(os.homedir(), "Music", artist, album);

async function setMetaData() {
    const files = await fs.readdir(directory);
    for (const file of files) {
        const pathToFile = path.join(directory, file);
        const config = getMetaData(file);

        const setTrack = `-c 'set track "${config.trackNumber}"'`;
        const setTitle = `-c 'set title "${config.songName}"'`;
        const setArtist = `-c 'set artist "${config.artist}"'`;
        const setAlbum = `-c 'set album "${config.album}"'`;
        const command = `kid3-cli ${setTrack} ${setTitle} ${setArtist} ${setAlbum} "${pathToFile}"`;

        exec(command, (err, stdout, stderr) => {
            if (err) {
                console.log(
                    `Error while setting metadata for track '${config.songName}'`,
                );
                console.error(err);
                return;
            }

            console.log(
                `Successfully set metadata for track '${config.songName}'`,
            );
        });
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
