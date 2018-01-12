UNAME := $(shell uname -s)
SHELL := /bin/bash # $(shell which bash)
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
DARWIN_INSTALL_NIX_PATH := darwin=$(ROOT_DIR)nix-darwin:darwin-config=$(ROOT_DIR)config/darwin-install.nix:nix-overlays=$(ROOT_DIR)overlays:nixpkgs=$(ROOT_DIR)nixpkgs

# Install
nix-install: sudo _nix-install

darwin-install: sudo _darwin-install

# Manage
build: darwin-build
switch: darwin-switch

darwin-build:
		@darwin-rebuild build

darwin-switch:
		@darwin-rebuild switch

darwin-update:
		@nix-env -f '<darwin>' -u --leq -Q -j4 -k -A pkgs \
		  || nix-env -f '<darwin>' -u --leq -Q -A pkgs

update: sudo tag-before pull darwin-update switch tag-working

##########
# Helpers
##########

sudo:
		@echo "# sudo authentication"
		@sudo -k
		@sudo echo "# sudo authentication successful!"

_nix-install:
ifeq ("$(wildcard $(HOME)/.nix-profile/)","")
		@echo "# Getting Nix Package Manager"
		@bash <(curl https://nixos.org/nix/install)
		@source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
		@echo "# Nix Package Manager already installed"
endif

_darwin-install: export NIX_PATH=$(DARWIN_INSTALL_NIX_PATH)
_darwin-install:
ifeq ($(UNAME),Darwin)
ifeq ("$(wildcard /run/current-system/darwin-version)", "")
		@[ -e /etc/bashrc ] && [ ! -L /etc/bashrc ] && sudo rm /etc/bashrc || true
		@[ -e /etc/nix/nix.conf ] && [ ! -L /etc/nix/nix.conf ] && sudo rm /etc/nix/nix.conf || true
		@[ ! -L /run ] && sudo ln -s private/var/run /run || true
		@$$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild build
		@$$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild switch
		@sudo sed -i '' '/# Nix/,/# End Nix/d' /etc/profile # fix for nix sourcing daemon by default
		@source /etc/bashrc
else
		@echo "# Nix darwin already installed"
endif
endif

pull:
		@echo "Updating repositories"
		@(cd nixpkgs    && git pull --rebase)
		@(cd nix-darwin && git pull --rebase)

tag-before:
		@echo "# Tagging before update"
		@git --git-dir=nixpkgs/.git branch -f before-update HEAD

tag-working:
		@echo "# Tagging after update"
		@git --git-dir=nixpkgs/.git branch -f last-known-good before-update
		@git --git-dir=nixpkgs/.git branch -D before-update
