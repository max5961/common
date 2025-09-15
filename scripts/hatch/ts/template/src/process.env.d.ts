declare namespace NodeJS {
    interface ProcessEnv {
        FOO: string | undefined;
        NODE_ENV: "test" | "dev" | "production" | undefined;
    }
}
