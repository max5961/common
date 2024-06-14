import { exec } from "node:child_process";
import fs from 'fs/promises';
import path from 'path';

async function runCommands(commands) {
    for (const command of commands) {
        console.log(`Running Command: ${command}`);
        const result = await new Promise((res, rej) => {
            exec(command, (err, stdout, stderr) => {
                if (err) {
                    console.error(`exec error: ${err}`);
                    rej(err);
                    return;
                }

                if (stderr) {
                    rej(stderr);
                }

                res(stdout);
            });
        });
        process.stdout.write(result);
    }
}

async function modifyPackageJson() {
    try {
        // get package.json string
        const packageJson = path.join(process.cwd(), "package.json");
        const content = await fs.readFile(packageJson, "utf-8");
        const packageObj = JSON.parse(content);

        // modify parsed package.json
        packageObj.scripts = {
            "start": "tsc && node ./dist/root.js",
        };
        packageObj.type = "module";

        // rewrite to the package.json file
        const newPackageJson = JSON.stringify(packageObj, null, 4);

        await fs.writeFile(packageJson, newPackageJson);
    } catch (err) {
        console.error(err);
    }

}

async function setup(npmCommands, fileStructureCommands) {
    // run npm commands
    await runCommands(npmCommands);

    // modify package.json
    await modifyPackageJson();

    // copy files
    await runCommands(fileStructureCommands);
}

const npmCommands = [
    "npm init -y",
    "npm install react @types/react ink",
    "npm install --save-dev typescript",
    "npm install --save-dev --save-exact prettier",
    "npm install --save-dev @types/node",
    // "npm install --save-dev jest",
    // "npm install --save-dev @types/jest",
    "npm install --save-dev @babel/preset-env",
    "npm install --save-dev @babel/preset-typescript",
];

const fileStructureCommands = [
    "mkdir dist",
    "cp -r ~/common/scripts/ink/src .",
    "cp ~/common/scripts/ink/file-structure/* .",
    "cp ~/common/templates/dotfiles/.prettierrc.json .",
];

setup(npmCommands, fileStructureCommands);









