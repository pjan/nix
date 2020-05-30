#!/usr/bin/env bash

# Config
LATEST_STABLE=nixpkgs-20.03-darwin

# Variables
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE}")"; pwd -P)"
NIXPATH="darwin=$ROOT_DIR/nix-darwin:darwin-config=$ROOT_DIR/config/nix-darwin:home-manager=$ROOT_DIR/home-manager:home-manager-config=$ROOT_DIR/config/home-manager:nix-overlays=$ROOT_DIR/overlays:nixpkgs=$ROOT_DIR/nixpkgs-unstable:nixpkgs-stable=$ROOT_DIR/nixpkgs-stable"

# Functions
do_sudo() {
	[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
	echo "✓ sudo authentication successful."
}

init_repo() {
	# Setting up base repo
	cd "$ROOT_DIR"
	git config remote.pjan.url >&- || git remote add pjan git@github.com:pjan/nix.git
	# Setting up nixpkgs-unstable repo
  cd "$ROOT_DIR/nixpkgs-unstable"
	git config remote.channels.url >&- || git remote add channels https://github.com/nixos/nixpkgs-channels
	git remote update channels
	git checkout nixpkgs-unstable 2>/dev/null || git checkout --track channels/nixpkgs-unstable
	git config remote.pjan.url >&- || git remote add pjan git@github.com:pjan/nixpkgs.git
	# Setting up nixpkgs-stable repo
	cd "$ROOT_DIR/nixpkgs-stable"
	git config remote.channels.url >&- || git remote add channels https://github.com/nixos/nixpkgs-channels
	git remote update channels
	git checkout $LATEST_STABLE 2>/dev/null || git checkout --track channels/$LATEST_STABLE
	git config remote.pjan.url >&- || git remote add pjan git@github.com:pjan/nixpkgs.git
	# Setting up nix-darwin
  cd "$ROOT_DIR/nix-darwin"
	git checkout master
	git config remote.pjan.url >&- || git remote add pjan git@github.com:pjan/nix-darwin.git
	# Setting up home-manager
	cd "$ROOT_DIR/home-manager"
	git checkout master
	git config remote.pjan.url >&- || git remote add pjan git@github.com:pjan/home-manager.git
}

install_nix() {
	echo "# Installing Nix Package Manager..."
	if [ -d "$HOME/.nix-profile/" ]; then
		echo "✗ Nix Package Manager already installed."
	else
		bash <(curl https://nixos.org/nix/install)
		source ~/.nix-profile/etc/profile.d/nix.sh
		echo "✓ Nix Package Manager successfully installed."
	fi
}

install_darwin() {
	echo "# Installing nix-darwin..."
	if [ -f "/run/current-system/darwin-version" ]; then
		echo "✗ nix-darwin already installed."
	else
		export NIX_PATH=$NIXPATH
		[ -e /etc/bashrc ] && [ ! -L /etc/bashrc ] && sudo rm /etc/bashrc || true
		[ -e /etc/nix/nix.conf ] && [ ! -L /etc/nix/nix.conf ] && sudo rm /etc/nix/nix.conf || true
		$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild build
		$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild switch
		@source /etc/bashrc
		echo "✓ nix-darwin successfully installed."
	fi
}

go() {
  do_sudo
  init_repo
  install_nix
	install_darwin
}

go

unset do_sudo
unset update_repo
unset install_nix
unset install_darwin
unset go