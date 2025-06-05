import { IMessage } from "../models/Message";
import odm from "./MockOrm";

/* Get a message with a specific id */
async function getOne(id: number): Promise<IMessage | null> {
    const db = await odm.openDb();
    for (const message of db.messages) {
        if (message.id === id) {
            return message;
        }
    }

    return null;
}

/* Get all messages from the db */
async function getAll(): Promise<IMessage[]> {
    const db = await odm.openDb();
    return db.messages;
}

/* Add a message */
async function add(message: IMessage): Promise<void> {
    const db = await odm.openDb();
    db.messages.push(message);
    return odm.saveDb(db);
}

/* Deletes a message.  If no message exists, does nothing */
async function delete_(id: number): Promise<void> {
    const db = await odm.openDb();
    db.messages = db.messages.filter((message) => message.id !== id);
    return odm.saveDb(db);
}

/* Updates a message */
async function update(updatedMessage: IMessage): Promise<void> {
    const db = await odm.openDb();
    db.messages = db.messages.map((message) => {
        if (message.id === updatedMessage.id) return updatedMessage;
        return message;
    });
    return odm.saveDb(db);
}

export default {
    getOne,
    getAll,
    add,
    update,
    delete: delete_,
} as const;
