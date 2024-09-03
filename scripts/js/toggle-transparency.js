#!/usr/bin/env node

const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");

const direction = process.argv[2];

const filePath = path.join(os.homedir(), ".config", "picom", "picom.conf");
const picom = fs.readFileSync(filePath, "utf-8");
const regex = /\b(\d+):class_g\s*=\s*'[^']+'/gm;
const mut = picom.replace(regex, (match, p) => {
    let num = parseInt(p);

    if (direction === "up") {
        num + 1 <= 100 && ++num;
    } else {
        num - 1 > 0 && --num;
    }

    return match.replace(p, num);
});

fs.writeFileSync(filePath, mut, "utf-8");
