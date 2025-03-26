#!/usr/bin/env node

/*
 * Replaces the 'latest' value in a package.json with the actual numeric
 * version of the locally installed package.
 */

const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

if (process.argv[2] === "--help") {
    console.log(
        fs.readFileSync("/usr/local/bin/update-package-versions", "utf-8"),
    );
    process.exit(0);
}

const jsonFile = path.join(process.env.PWD, "package.json");
const json = fs.readFileSync(jsonFile, "utf-8");
const data = JSON.parse(json);

function replaceLatest(depType) {
    for (const key in depType) {
        const version = execSync(`npm view ${key} version`, {
            encoding: "utf-8",
        }).trim();
        console.log(`${key}: ^${version}`);
        depType[key] = `^${version}`;
    }
}

console.log(
    "...replacing 'latest' in package.json with downloaded version number",
);
replaceLatest(data.devDependencies);
replaceLatest(data.dependencies);

fs.writeFileSync(jsonFile, JSON.stringify(data, null, 4), {
    encoding: "utf-8",
});
