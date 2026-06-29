#!/usr/bin/env node

const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");

const direction = process.argv[2];

const fpath = path.join(os.homedir(), ".config", "picom", "picom.conf");
const picom = fs.readFileSync(fpath, "utf-8");
const regex = /match.*opacity\s=\s(\d.\d+)/gm;

const mod = picom.replace(regex, (match, p) => {
    const d = direction === "up" ? 0.01 : -0.01;
    let num = parseFloat(p) + d;

    num = Math.max(0, num);
    num = Math.min(1, num);

    return match.replace(p, num.toFixed(2));
});

if (mod) {
    fs.writeFileSync(fpath, mod, "utf-8");
}
