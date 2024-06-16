import express from "express";
import path from "path";
import Paths from "./common/Paths";
import { homeRouter } from "./routes/homepage/index";

const app = express();

app.set("view engine", "ejs");
app.set("views", path.resolve(Paths.src, "views"));

app.use(log);

/* body parser middleware */
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use("/", homeRouter);

export default app;

function log(
    req: express.Request,
    res: express.Response,
    next: express.NextFunction,
): void {
    console.log(
        `${req.method} ${req.protocol}://localhost:3000${req.originalUrl}`,
    );
    next();
}
