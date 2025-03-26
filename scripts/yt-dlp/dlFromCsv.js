import fs from "node:fs";
import { execFileSync } from "node:child_process";

const fpath = process.argv[2];

if (!fpath) {
    console.error("Provide an argument to a csv file");
    process.exit(1);
}

const fcontents = fs.readFileSync(fpath, "utf-8");
const lines = fcontents.split("\n");

for (let i = 0; i < lines.length; ++i) {
    const [artist, album, url] = lines[i].split(",");
    if (!artist || !album || !url) {
        console.warn(`Skipping invalid line ${i + 1} in ${fpath}`);
        continue;
    }

    execFileSync("albumdl", [artist, album, url], { stdio: "inherit" });
}
