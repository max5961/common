import path from "path";

const src = path.resolve(__dirname, "../../src");

export default {
    src: src,
    views: path.resolve(src, "views"),
    assets: path.resolve(src, "views", "bundles"),
    homepage: {
        script: path.resolve(src, "views", "bundles", "homepage.bundle.js"),
    },
};
