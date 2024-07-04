export interface IMessage {
    username: string;
    message: string;
    id: number;
    createdAt: string;
}

function create(
    username: string,
    message: string,
    id: number,
    createdAt?: string,
): IMessage {
    return {
        username,
        message,
        id,
        createdAt: createdAt ?? new Date().toLocaleString(),
    };
}

function isMessage(arg: unknown): boolean {
    return (
        !!arg &&
        typeof arg === "object" &&
        "username" in arg &&
        typeof arg.username === "string" &&
        "message" in arg &&
        typeof arg.message === "string" &&
        "id" in arg &&
        typeof arg.id === "number" &&
        "createdAt" in arg &&
        typeof arg.createdAt === "string"
    );
}

function from(arg: object): IMessage {
    if (!isMessage(arg)) {
        throw new Error("Invalid object shape");
    }

    const m = arg as IMessage;

    return create(m.username, m.message, m.id, m.createdAt);
}

export default {
    create,
    from,
    isMessage,
} as const;
