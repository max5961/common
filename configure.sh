git config alias.update '! f() { DIR=$(git rev-parse --show-toplevel); $DIR/dev-update.sh; }; f'
