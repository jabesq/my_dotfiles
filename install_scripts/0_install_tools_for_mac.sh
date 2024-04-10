#!/bin/env bash

printf "Install brew"
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

printf "Install Apps and Tools from brew"
brew install stow 1password-cli fzf openssl readline sqlite3 xz zlib tcl-tk zoxide

printf "Install pyenv"
curl https://pyenv.run | bash



