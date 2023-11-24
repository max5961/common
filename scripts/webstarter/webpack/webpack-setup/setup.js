const { Arguments, Rules, WebpackConfig } = require("./classes");
const path = require("node:path");

const currentDir = process.argv[2];
module.exports = currentDir;

const scssRule = `
            {
                test: /\\.s[ac]ss$/i,
                use: [
                    "style-loader",
                    "css-loader",
                    "sass-loader"
                ],
            },`;




