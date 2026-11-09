#!/bin/bash
# macOS setup (Intel or Apple Silicon). Run: bash scripts/install-mac.sh
set -e
if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
fi
brew install git python openjdk@17 jenkins-lts minikube kubectl ruby
brew install --cask docker
gem_ruby="$(brew --prefix ruby)/bin"
export PATH="$gem_ruby:$PATH"
echo "export PATH=\"$gem_ruby:\$PATH\"" >> ~/.zshrc
gem install puppet
echo "Now: open -a Docker  (wait for whale icon), then: brew services start jenkins-lts"
