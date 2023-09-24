#!/bin/bash

initialize_git_repository() {
    echo ""
    echo "Initialize empty git repository? [y/n]:"
    read answer
    answer=$(to_lower_case "$answer");

    if [ "$answer" = "y" ] || [ "$answer" = "" ]; then
        git init
        echo /node_modules >> .gitignore 
        git add *
        git commit -m "Initial commit. Setup webpack"
        git branch -M main
        if [ $? -eq 0 ]; then
            echo -e "\033[32mGit initialized in $(pwd)\033[0m"
        fi
    fi
}

to_lower_case() {
    echo "$1" | tr [:upper:] [:lower:] 
} 

template_exists() {
    if [ ! -d "$1" ]; then
        echo -e "\033[31mTemplate does not exist in: $1\033[0m"
        exit 1
    fi
}

inject_css_reset() {
    css_reset="$HOME/environment/resources/templates/css-resets/reset.css"
    if [ ! -f "$css_reset" ]; then
        echo -e "\033[33mCannot locate CSS reset template.  Using default reset\033[0m"
    else
        cd "$(pwd)" && cat "$css_reset" > ./src/style/reset.css
    fi
}

init_webpack() {
    npm init -y
    npm install webpack webpack-cli --save-dev
}

copy_parent_file_structure() {
    parent_dir="$1"
    curr_dir="$(pwd)"
    cp -r "$parent_dir." "$curr_dir"
    inject_css_reset
}

install_basic() {
    npm install --save-dev style-loader css-loader csv-loader xml-loader babel-loader @babel/core @babel/preset-env
    config_files_dir="$HOME/environment/resources/templates/webpack/webpack-config-files"
    cp "$config_files_dir/basic-webpack.config.js" "$(pwd)/webpack.config.js"
}

insert_prettierrc() {
    template="$HOME/environment/resources/templates/prettier/.prettierrc.json"
    cp "$template" "$(pwd)/.prettierrc.json"
}

insert_eslintrc() {
    template_dir="$HOME/environment/resources/templates/eslint"
    if [ "$1" = "typescript" ]; then 
        cp "$template_dir/.typescriptrc.json" "$(pwd)/.eslintrc.json"
    elif [ "$1" = "javascript" ]; then
        cp "$template_dir/.javascriptrc.json" "$(pwd)/.eslintrc.json"
    fi
}

install_advanced() {
    npm install --save-dev style-loader css-loader csv-loader xml-loader babel-loader @babel/core @babel/preset-env eslint eslint-config-prettier
    npm install --save-dev --save-exact prettier
    config_files_dir="$HOME/environment/resources/templates/webpack/webpack-config-files"
    cp "$config_files_dir/basic-webpack.config.js" "$(pwd)/webpack.config.js"
    insert_prettierrc
}

install_sass() {
    echo "Installing sass dependencies"
    npm install --save-dev sass-loader sass
}

install_typescript() {
    echo "Installing TypeScript dependencies"
    npm install --save-dev typescript ts-loader
    npm isntall --sav-dev @typescript-eslint/parser
}

yes_sass() {
    template_dir="$HOME/environment/resources/templates/webpack/sass-structure"
    rm -r "$(pwd)/src" && mkdir src && cp -r "$template_dir/src/"* "$(pwd)/src"
}

yes_typescript() {
    mv ./src/index.js ./src/index.ts
}

get_config_files() {
    template_dir="$HOME/environment/resources/templates/webpack/webpack-config-files"
    if [ "$1" = "typescript_sass" ]; then
        cp "$template_dir/sass-typescript-config.js" "$(pwd)/webpack.config.js"
        cp "$template_dir/tsconfig.json" "$(pwd)/tsconfig.json"
    fi

    if [ "$1" = "typescript" ]; then
        cp "$template_dir/typescript-config.js" "$(pwd)/webpack.config.js"
        cp "$template_dir/tsconfig.json" "$(pwd)/tsconfig.json"
    fi

    if [ "$1" = "sass" ]; then
        cp "$template_dir/sass-config.js" "$(pwd)/webpack.config.js"
    fi

    if [ "$1" = "basic" ]; then
        cp "$template_dir/basic-webpack-config.js" "$(pwd)/webpack.config.js"
    fi
}

check_valid_args() {
    if [ -z "$1" ]; then
        echo "At least one argument must be present.  --help for help"
        exit 1
    fi

    if [ "$1" == "--help" ]; then
        echo "Arguments may be the following:"
        echo "  --basic: Intialize basic webpack directory"
        echo "  --advanced: Initialize heavier webpack directory: ESlint, Prettier"
        echo ""
        echo "  The following are valid arguments for specific assets"
        echo "      --sass: Download necessary SASS modules and modify the file structure"
        echo "      --typescript: Download necessary TypeScript modules and modify the file structure"
        exit 0
    fi
}

check_valid_args "$1"

basic=false
advanced=false
sass=false
typescript=false

for arg in "$@"; do
    case $arg in
        --basic)
            basic=true
            shift 
            ;;
        --advanced)
            advanced=true
            shift
            ;;
        --sass)
            sass=true
            shift
            ;;
        --typescript)
            typescript=true
            shift
            ;;
        *)
            echo "Unknown arg: $arg"
            exit 1;
            ;;
    esac
done

if [ "$basic" = true ] && [ "$advanced" = true ]; then
    echo "Cannot create basic and advanced setup. --help for help"
    exit 1;
fi

if [ "$basic" = false ] && [ "$advanced" = false ]; then
    echo "Must include either --basic or --advanced as an argument.  --help for help"
    exit 1;
fi

# first run npm init and install webpack then run more specific configuration
init_webpack
# basic setups
if [ "$basic" = true ] && [ "$typescript" = true ] && [ "$sass" = true ]; then
    echo "Initializing basic configuration with TypeScript and SASS"
    copy_parent_file_structure "$HOME/environment/resources/templates/webpack/basic/"
    install_typescript
    install_sass
    install_basic
    # yes_sass needs to be run before yes_typescript as yes_sass removes the src directory
    # and replaces it with the sass file structure tempalte
    # yes_typescript simply changes the index.js file to index.ts
    yes_sass
    yes_typescript
    get_config_files "typescript_sass"
elif [ "$basic" = true ] && [ "$typescript" = true ]; then
    echo "Initializing basic configuration with TypeScript"
    copy_parent_file_structure "$HOME/environment/resources/templates/webpack/basic/" 
    install_typescript
    install_basic
    yes_typescript
    get_config_files "typescript" 
elif [ "$basic" = true ] && [ "$sass" = true ]; then
    echo "Initializing basic configuration with SASS"
    copy_parent_file_structure "$HOME/environment/resources/templates/webpack/basic/" 
    install_sass
    install_basic
    yes_typescript
    get_config_files "sass"
elif [ "$basic" = true ]; then
    echo "Initializing advanced configuration"
    copy_parent_file_structure "$HOME/environment/resources/templates/webpack/basic/" 
    install_basic
    get_config_files "basic"

# advanced setups
elif [ "$advanced" = true ] && [ "$typescript" = true ] && [ "$sass" = true ]; then
    echo "Initializing advanced configuration with TypeScript and SASS"
    copy_parent_file_structure "$HOME/environment/resources/templates/webpack/advanced/" 
    install_typescript
    install_sass
    install_advanced
    yes_sass
    yes_typescript
    get_config_files "typescript_sass"
    insert_eslintrc "typescript"
elif [ "$advanced" = true ] && [ "$typescript" = true ]; then
    echo "Initializing advanced configuration with TypeScript"
    copy_parent_file_structure "$HOME/environment/resources/templates/webpack/advanced/" 
    install_typescript
    install_advanced
    yes_typescript
    get_config_files "typescript"
    insert_eslintrc "typescript"
elif [ "$advanced" = true ] && [ "$sass" = true ]; then
    echo "Initializing advanced configuration with SASS"
    copy_parent_file_structure "$HOME/environment/resources/templates/webpack/advanced/" 
    install_sass
    install_advanced
    get_config_files "sass"
    insert_eslintrc "javascript"
elif [ "$advanced" = true ]; then
    echo "Initializing advanced configuration"
    copy_parent_file_structure "$HOME/environment/resources/templates/webpack/advanced/" 
    install_advanced
    get_config_files "basic"
    insert_eslintrc "javascript"
fi

npm run build

initialize_git_repository


