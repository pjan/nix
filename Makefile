UNAME := $(shell uname -s)
SHELL := /bin/bash # $(shell which bash)
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
DARWIN_INSTALL_NIX_PATH := darwin=$(ROOT_DIR)nix-darwin:darwin-config=$(ROOT_DIR)config/darwin-install.nix:nix-overlays=$(ROOT_DIR)overlays:nixpkgs=$(ROOT_DIR)nixpkgs

# Install
nix-install: sudo _nix-install

darwin-install: sudo _darwin-install

# Manage
darwin-build:
		@darwin-rebuild build
		@rm result

darwin-switch:
		@darwin-rebuild switch -Q
		@echo "# Darwin generation: $$(darwin-rebuild --list-generations | tail -1)"

home-build:
		@home-manager build
		@rm result

home-switch:
		@home-manager switch
		@echo "# Home generation:   $$(home-manager generations | head -1)"

env-build:
		@nix-build '<darwin>' -A pkgs.envs.ghc82
		@rm result

env-update:
		@nix-env -f '<darwin>' -u --leq -Q -k -A pkgs.envs.ghc82
		@rm result

env-build-all:
		@nix-build '<darwin>' -A pkgs.envs.ghc82
		@nix-build '<darwin>' -A pkgs.envs.ghc82-profiled
		@rm result

env-update-all:
		@nix-env -f '<darwin>' -u --leq -Q -j4 -k -A pkgs \
		  || nix-env -f '<darwin>' -u --leq -Q -A pkgs

build: darwin-build home-build env-build

build-all: darwin-build home-build env-build-all

switch: darwin-switch home-switch

update: sudo tag-before pull env-build-all switch env-update-all tag-working mirror done

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
		@echo "# Updating repositories"
		@echo "# Pulling nixpkgs"
		@(cd nixpkgs      && git pull --rebase)
		@echo "# Pulling nix-darwin"
		@(cd nix-darwin   && git pull --rebase)
		@echo "# Pulling home-manager"
		@(cd home-manager && git pull --rebase)

tag-before:
		@echo "# Tagging before update"
		@git --git-dir=nixpkgs/.git branch -f before-update HEAD

tag-working:
		@echo "# Tagging after update"
		@git --git-dir=nixpkgs/.git branch -f last-known-good before-update
		@git --git-dir=nixpkgs/.git branch -D before-update

mirror:
		@echo "# Pushing changes to mirrors on pjan"
		@git --git-dir=nixpkgs/.git push --mirror pjan
		@git --git-dir=nix-darwin/.git push --mirror pjan
		@git --git-dir=home-manager/.git push --mirror pjan

done:
		@echo "### ALL DONE ###"

gc:
		@find $(HOME) \
		  \( -name dist -type d -o		\
		     -name result -type l \) -print0	\
		  | parallel -0 /bin/rm -fr {}
		nix-collect-garbage --delete-older-than 14d

