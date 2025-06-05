# Custom Express TypeScript Generator
This is my custom express typescript generator template which is strongly
influenced by express-generator-ts.  This generator however has less high level
abstractions and utilizes webpack and scss for styling frontend.

## Usage
This starts the server in watch mode.  It relies on nodemon and ts-node
```sh
npm run start:dev
```

To work on the frontend files located in ./src/public, you can run 'npx webpack
--watch' alongside 'npm run start:dev'.  You will still need to to manually
refresh the apge becuase nodemon only refreshes the server.  It doesn't
automatically send get requests on the client.
```sh
npx webpack --watch
```
#### note
For any ./src/public changes to take effect, you will need to compile with
webpack.


## Directories
### ./src/views
This directory stores .ejs files.  It is also the output directory for the
webpack bundler which compiles all of the frontend files found in ./src/public.
To add a new view, a new entry point must be added in webpack.config.js
### ./src/public
This directory contains all of the frontend .ts and .scss files which are
compiled and outputted to ./src/views using webpack
### ./src/common
HttpStatusCodes.ts
Paths.ts (server side paths to files and common directories)
### ./src/routes
Routing
### ./src/models
Type Definitions for shapes pulled from db
### ./src/repos
- Where the database lives
- Contains logic to access and modify the database.  Each file returns a default
  export object containing the various methods:
