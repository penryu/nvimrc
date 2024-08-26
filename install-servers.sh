#!/bin/sh
set -eu

OS_MACH=$(uname -m)
OS_SYS=$(uname -s)

install_yarn_pkgs(){
  pkg_names="
    bash-language-server
    dockerfile-language-server-nodejs
    @microsoft/compose-language-service
    typescript
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
  "
  # we know there are no unexpected spaces in the string we just built
  # shellcheck disable=SC2086
  yarn global add $pkg_names
}

install_cargo_bins(){
  cargo install --git https://github.com/latex-lsp/texlab --locked
}

install_brew_deps(){
  if [ "$OS_SYS" = Darwin ]; then
    deps="
      clojure-lsp/brew/clojure-lsp-native
      lua-language-server
    "
    # we know there are no unexpected spaces in the string we just built
    # shellcheck disable=SC2086
    brew install $deps
  else
    echo "Not a macOS system; skipping brew deps"
  fi
}

install_marksman(){
  dest="$HOME/.local/bin/marksman"

  if [ -x "$dest" ]; then
    echo "Found $dest; not reinstalling"
    return 0
  fi

  tuple="$OS_SYS:$OS_MACH"
  mkdir -p "$(dirname "$dest")"

  case $tuple in
    Darwin:arm64)   filename="marksman-macos";;
    Linux:aarch64)  filename="marksman-linux-arm64";;
    Linux:x86_64)   filename="marksman-linux-x64";;
    *)
      echo "Unrecognized platform $tuple for marksman!"
      return 1
      ;;
  esac

  curl -Lo "$dest" "https://github.com/artempyanykh/marksman/releases/latest/download/$filename"
  chmod 755 "$dest"
}

install_yarn_pkgs
install_cargo_bins
install_brew_deps
install_marksman
