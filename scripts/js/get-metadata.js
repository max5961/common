#!/usr/bin/env node

const assert = require("node:assert");
const { exec } = require("node:child_process");
const path = require("node:path");

const file = path.resolve(process.argv[2]);
assert(file, "Provide an argument bro");

exec(`mediainfo --Output=JSON "${file}"`, (err, stdout, stderr) => {
    if (err || stderr) {
        return console.error("error brah");
    }
    try {
        console.log(JSON.parse(stdout).media.track[0]);
    } catch (err) {
        console.error("Bro another error");
    }
});
