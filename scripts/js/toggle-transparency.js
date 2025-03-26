#!/usr/bin/env node

const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");

const direction = process.argv[2];

const fpath = path.join(os.homedir(), ".config", "picom", "picom.conf");
const picom = fs.readFileSync(fpath, "utf-8");
const regex = /\b(\d+):class_g\s*=\s*'[^']+'/gm;
const mod = picom.replace(regex, (match, p) => {
    let num = parseInt(p);

    if (direction === "up") {
        num + 1 <= 100 && ++num;
    } else {
        num - 1 > 0 && --num;
    }

    return match.replace(p, num);
});

if (mod) {
    fs.writeFileSync(fpath, mod, "utf-8");
}
