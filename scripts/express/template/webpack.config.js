const path = require("path");

module.exports = {
    /* Any additional front end scripts go here */
    entry: {
        homepage: path.resolve(
            __dirname,
            "src",
            "public",
            "homepage",
            "index.ts",
        ),
        messageBoard: path.resolve(
            __dirname,
            "src",
            "public",
            "messageBoard",
            "index.ts",
        ),
    },

    /* Outputs bundled js from the ./src/public directory */
    output: {
        filename: "[name].bundle.js",
        path: path.resolve(__dirname, "src", "views", "bundles"),
    },
    devtool: "inline-source-map",
    mode: "development",
    resolve: {
        extensions: [".tsx", ".ts", ".js"],
    },
    module: {
        rules: [
            {
                test: /\.css$/i,
                use: ["style-loader", "css-loader"],
            },
            {
                test: /\.s[ac]ss$/i,
                use: ["style-loader", "css-loader", "sass-loader"],
            },
            {
                test: /\.tsx?$/,
                use: "ts-loader",
                exclude: /node_modules/,
            },
            {
                test: /\.(png|svg|jpg|jpeg|gif)$/i,
                type: "asset/resource",
            },
            {
                test: /\.(woff|woff2|eot|ttf|otf)$/i,
                type: "asset/resource",
            },
            {
                test: /\.(?:js|mjs|cjs)$/,
                exclude: /node_modules/,
                use: {
                    loader: "babel-loader",
                    options: {
                        presets: [
                            ["@babel/preset-env", { targets: "defaults" }],
                        ],
                    },
                },
            },
        ],
    },
};
