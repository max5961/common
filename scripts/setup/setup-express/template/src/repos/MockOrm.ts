import path from "path";
import fs from "fs/promises";
import { IUser } from "../models/User";
import { IMessage } from "../models/Message";

const DB_PATH = path.join(__dirname, "database.json");

interface IDb {
    user: IUser;
    messages: IMessage[];
}

async function openDb(): Promise<IDb> {
    const db = await fs.readFile(DB_PATH, "utf-8");
    return JSON.parse(db) as IDb;
}

async function saveDb(db: IDb): Promise<void> {
    await fs.writeFile(JSON.stringify(db), DB_PATH, "utf-8");
}

export default {
    openDb,
    saveDb,
} as const;
