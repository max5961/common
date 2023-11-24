const fs = require("node:fs");

const arguments = [];
for (let i = 2; i < process.argv.length; i++) {
    arguments.push(process.argv[i]) 
}

console.log(arguments);

let webpackConfig = fs.readFileSync("./webpack.config.ts", "utf-8");

const sassRule = 
            ` 
            {
                test: /\\.s[ac]ss$/i,
                use: [
                    "style-loader",
                    "css-loader",
                    "sass-loader"
                ],
            },`;

function unshiftRule(fileContent, rule) {
    // get the index of where the new rule will be inserted into the file contents
    const regex = /module:\s*\{\n\s*rules:\s*\[/g;
    const match = regex.exec(fileContent);
    const index = match.index + match[0].length;

    // write the new rule into the file contents
    return (
        fileContent.slice(0, index) +
        rule +
        fileContent.slice(index)
    );

}

fs.writeFileSync("./webpack.config.ts", unshiftRule(webpackConfig, sassRule));



