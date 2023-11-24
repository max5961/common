const rl = require("readline-sync");
const fs = require("node:fs");
const path = require("node:path");
const exec = require("node:child_process");

const ARGLIST = {
    prettier: "prettier",
    scss: "scss",
    babel: "babel",
    eslint: "eslint",
}

class Arguments {
    constructor() {
        this.possibleArgs = [ARGLIST.prettier, ARGLIST.scss, ARGLIST.babel, ARGLIST.eslint]
        this.chosenArgs = [];
        this.getArgs();
    }

    getArgs() {
        for (const arg of this.possibleArgs) {
            this.promptUser(arg);
        }
    }

    promptUser(arg) {
        const answer = rl.question(`${arg} [y/n] `);
        if (this.checkAnswer(answer)) {
            this.chosenArgs.push(arg);
        }
    }

    checkAnswer(answer) {
        if (
            answer === "" ||
            answer.toLowerCase() === "y" ||
            answer.toLowerCase() === "yes"
        ) {
            return true;
        }

        return false;
    }
}

class WebpackDir {
    constructor(currentDir) {
        this.dir = currentDir;
        this.init();
    }

    init() {
        const args = new Arguments();
        const dotFiles = new DotFiles();
        const webpackConfig = new WebpackConfig();
    }
}

class WebpackConfig {
    constructor() {
        this.configFileContents = rl.readFileSync("./path/to/file", "utf-8")
        this.sassRule = getSassRule();
        this.babelRule = getBabelRule();
    }

    getSassRule() {
        return ``;
    }

    getBabelRule() {
        return ``;
    }

    addRule(configFileContents, rule) {
        
        // get the index of where the new rule will be inserted into the file contents
        const regex = /module:\s*\{\n\s*rules:\s*\[/g;
        const match = regex.exec(configFileContents);
        const index = match.index + match[0].length;

        this.configFileContents = (
            configFileContents.slice(0, index) +
            rule +
            configFileContents.slice(index)
        );
    }
}

class DotFiles {
    constructor() {
        // key is the name of the dot file
        // value is a string of the file contents
        this.files = {};
    }

    getPossibleDotFiles() {
        return {
            ".prettierrc.json": fs.readFileSync("./.prettierrc.json", "utf-8"),
        }
    }

    setDotFiles(args) {
        const possibleDotFiles = this.getPossibleDotFiles();
        const chosenArgs = this.convertToFileName(args.chosenArgs);

        for (key in possibleDotFiles) {
            for (const arg of chosenArgs) {
                if (key === arg) {
                    this.files[key] = possibleDotFiles[key];
                }
            }
        }
    }

    convertToFileName(chosenArgs) {
        const fileNameArgs = [];
        for (const arg of chosenArgs) {
            switch(arg) {
                case ARGLIST.prettier:
                    fileNameArgs.push(".prettierrc.json");
                    break;
                case ARGLIST.babel:
                    fileNameArgs.push(".babelrc");
                    break;
                case ARGLIST.eslint:
                    fileNameArgs.push(".eslintrc");
                    break;
            }
        }
    }
}

module.exports = {
    Arguments,
    WebpackConfig,
    WebpackDir,
    DotFiles 
}
