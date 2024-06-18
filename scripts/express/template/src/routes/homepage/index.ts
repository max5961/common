import HttpStatusCodes from "../../common/HttpStatusCodes";
import Paths from "../../common/Paths";
import express from "express";

export const homeRouter = express.Router();

const Routes = {
    root: "/",
    bundle: "/bundle.js",
    api: "/api",
} as const;

/* Serve static assets from webpack */
homeRouter.use(Routes.root, express.static(Paths.assets));

homeRouter.get(Routes.root, (req, res) => {
    res.render("homepage", {
        scriptPath: "/bundle.js",
    });
});

homeRouter.get(Routes.bundle, (req, res) => {
    res.status(HttpStatusCodes.OK).sendFile(Paths.homepage.script);
});
