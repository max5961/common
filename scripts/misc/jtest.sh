#!/bin/bash

if [[ ! -d "$HOME/void" ]]; then
    mkdir ~/void
fi

cd ~/void

# Start new
if [[ -d jtest ]]; then
    if  [[ "$1" == "-n" ]]; then
        trash-put jtest
    fi
fi

mkdir -p jtest && cd jtest

if [[ ! -f .prettierrc.json ]]; then
    cp ~/common/templates/dotfiles/.prettierrc.json .
fi

if [[ ! -f .gitignore ]]; then
    echo "node_modules/" >> .gitignore
fi

if [[ ! -d .git ]]; then
    git init > /dev/null 2>&1
fi

if [[ ! -d node_modules ]]; then
    # npm init -y && npm install --save-dev @types/node
    npm init -y
    echo \
        '{
        "name": "jtest",
        "version": "1.0.0",
        "description": "",
        "scripts": {
            "start": "tsc ts-test.ts && node ts-test.js",
            "start:ts": "tsc ts-test.ts && node ts-test.js",
            "start:js": "node js-test.js",
            "test": "tsc && npx vitest"
        },
        "type": "module",
        "keywords": [],
        "author": "",
        "license": "ISC",
        "devDependencies": {
            "@types/node": "latest",
            "vitest": "latest"
        }
    }' > package.json

    echo \
        '{
    "compilerOptions": {
        "outDir": "./dist/" /* Specify an output folder for all emitted files. */,
        "jsx": "react" /* Specify what JSX code is generated. */,
        "target": "ESNext" /* Set the JavaScript language version for emitted JavaScript and include compatible library declarations. */,
        "module": "ESNext" /* Specify what module code is generated. */,
        "moduleResolution": "node" /* Specify how TypeScript looks up a file from a given module specifier. */,
        "allowJs": true /* Allow JavaScript files to be a part of your program. Use the 'checkJS' option to get errors from these files. */,
        "sourceMap": true /* Create source map files for emitted JavaScript files. */,
        "noEmitOnError": true /* Disable emitting files if any type checking errors are reported. */,
        "esModuleInterop": true /* Emit additional JavaScript to ease support for importing CommonJS modules. This enables 'allowSyntheticDefaultImports' for type compatibility. */,
        "forceConsistentCasingInFileNames": true /* Ensure that casing is correct in imports. */,
        "strict": true /* Enable all strict type-checking options. */,
        "noImplicitAny": true /* Enable error reporting for expressions and declarations with an implied 'any' type. */,
        "skipLibCheck": true /* Skip type checking all .d.ts files. */
        }
    }' > tsconfig.json

    npm install
    update-package-versions
    npx prettier --write package.json
fi

touch index.ts test.spec.ts
neovim index.ts && exit 0;

