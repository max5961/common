#!/usr/bin/env node

const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const { execSync } = require("node:child_process");

const musicDir = path.join(os.homedir(), "Music");

const artists = fs.readdirSync(musicDir);
for (const artist of artists) {
    const albums = fs.readdirSync(path.join(musicDir, artist));
    for (const album of albums) {
        const command = `ARTIST="${artist}" ALBUM="${album}" node ~/common/scripts/yt-dlp/albumdl/setMetadata.js`;
        const stdout = execSync(command, { encoding: "utf-8" });
        console.log(stdout);
    }
}

