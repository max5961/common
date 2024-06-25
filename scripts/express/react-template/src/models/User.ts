export interface IUser {
    username: string;
    id: number;
}

function create(username: string, id: number): IUser {
    return {
        username,
        id,
    };
}

function isUser(arg: unknown): boolean {
    return (
        !!arg &&
        typeof arg === "object" &&
        "username" in arg &&
        typeof arg.username === "string" &&
        "id" in arg &&
        typeof arg.id === "number"
    );
}

function from(arg: object): IUser {
    if (!isUser(arg)) {
        throw new Error("Invalid IUser shape");
    }

    const u = arg as IUser;

    return create(u.username, u.id);
}

export default {
    create,
    isUser,
    from,
} as const;
