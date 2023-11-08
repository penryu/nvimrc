#!/bin/sh
set -eu

OS_SYS=$(uname -s)
OS_VER=$(uname -r | sed 's/\..*//')
export OS_SYS OS_VER

YARN_PKGS="
  bash-language-server
  dockerfile-language-server-nodejs
  @microsoft/compose-language-service
  vscode-langservers-extracted
  typescript typescript-language-server
  yaml-language-server
"

install_yarn_pkgs(){
  yarn global add bash-language-server
  yarn global add dockerfile-language-server-nodejs
  yarn global add @microsoft/compose-language-service
  yarn global add vscode-langservers-extracted
  yarn global add typescript typescript-language-server
  yarn global add yaml-language-server
}

install_cargo_bins(){
  cargo install --git https://github.com/latex-lsp/texlab --locked
}

install_brew_deps(){
  deps="clojure-lsp/brew/clojure-lsp-native lua-language-server"

  if [ "$OS_SYS" = "Darwin" ]; then
    for dep in $deps; do
      brew install "$dep"
    done
  else
    echo "Not a macOS system; skipping brew deps: $deps"
  fi
}

# https://github.com/artempyanykh/marksman/releases/


install_yarn_pkgs

install_cargo_bins

install_brew_deps
