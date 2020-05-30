MAX_AGE    = 14

UNAME := $(shell uname -s)
SHELL := $(shell which bash)
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Lazily evaluated variables; expensive to compute, but we only want it do it
# when first necessary.
GIT_DATE   = git --git-dir=nixpkgs-unstable/.git show -s --format=%cd --date=format:%Y%m%d_%H%M%S
HEAD_DATE  = $(eval HEAD_DATE := $(shell $(GIT_DATE) HEAD))$(HEAD_DATE)
LKG_DATE   = $(eval LKG_DATE  := $(shell $(GIT_DATE) last-known-good))$(LKG_DATE)

BUILDPATH = /run/current-system
BUILD_ARGS = --keep-going --argstr version $(HEAD_DATE)

NIXPATH = darwin=$(ROOT_DIR)nix-darwin:darwin-config=$(ROOT_DIR)config/nix-darwin:home-manager=$(ROOT_DIR)home-manager:home-manager-config=$(ROOT_DIR)config/home-manager:nix-overlays=$(ROOT_DIR)overlays:nixpkgs=$(ROOT_DIR)nixpkgs-unstable:nixpkgs-stable=$(ROOT_DIR)nixpkgs-stable
PRENIX  = NIX_PATH=$(NIXPATH)

NIX        = $(PRENIX) nix
NIX_BUILD  = $(PRENIX) nix-build
NIX_ENV	   = $(PRENIX) nix-env
NIX_STORE  = $(PRENIX) nix-store
NIX_GC	   = $(PRENIX) nix-collect-garbage

DARWIN_REBUILD = $(PRENIX) $(BUILDPATH)/sw/bin/darwin-rebuild
HOME_MANAGER   = $(PRENIX) HOME_MANAGER_CONFIG=$(ROOT_DIR)config/home-manager $(BUILDPATH)/sw/bin/home-manager

# Manage

all: rebuild

build:
	@$(NIX) build -f . $(BUILD_ARGS)
	@rm -f result*

build-darwin:
	@$(NIX_BUILD) . -A nix-darwin
	@rm -f result*

build-home:
	@$(NIX_BUILD) . -A home-manager
	@rm -f result*

darwin-switch:
	@$(DARWIN_REBUILD) switch -Q
	@echo "# Nix-darwin generation: $$(darwin-rebuild --list-generations | tail -1)"

home-switch:
	@$(HOME_MANAGER) switch
	@echo "# Home-manager generation: $$(home-manager generations | head -1)"

switch: darwin-switch home-switch

rebuild: build switch

pull:
	@echo "# Updating repositories"
	@echo "# Pulling nixpkgs-stable"
	@(cd nixpkgs-stable && git pull --rebase)
	@echo "# Pulling nixpkgs-unstable"
	@(cd nixpkgs-unstable && git pull --rebase)
	@echo "# Pulling nix-darwin"
	@(cd nix-darwin && git pull --rebase origin master)
	@echo "# Pulling home-manager"
	@(cd home-manager && git pull --rebase origin master)

tag-before:
	@echo "# Tagging before update"
	@git --git-dir=nixpkgs-unstable/.git branch -f before-update HEAD

tag-working:
	@echo "# Tagging after update"
	@git --git-dir=nixpkgs-unstable/.git branch -f last-known-good before-update
	@git --git-dir=nixpkgs-unstable/.git branch -D before-update
	@git --git-dir=nixpkgs-unstable/.git tag -f known-good-$(LKG_DATE) last-known-good

mirror:
	@echo "# Pushing changes to mirrors on pjan"
	@git --git-dir=nixpkgs-unstable/.git push pjan -f master:master
	@git --git-dir=nixpkgs-unstable/.git push pjan -f unstable:unstable
	@git --git-dir=nixpkgs-unstable/.git push pjan -f last-known-good:last-known-good
	@git --git-dir=nixpkgs-unstable/.git push -f --tags pjan
	@git --git-dir=nix-darwin/.git push --mirror pjan
	@git --git-dir=home-manager/.git push --mirror pjan

update: tag-before pull rebuild working

check:
	@$(NIX_STORE) --verify --repair --check-contents

########################################################################

define delete-generations
	$(NIX_ENV) $(1) --delete-generations			\
	    $(shell $(NIX_ENV) $(1)				\
		--list-generations | field 1 | head -n -$(2))
endef

define delete-generations-all
	$(call delete-generations,,$(1))
	$(call delete-generations,-p /nix/var/nix/profiles/system,$(1))
endef

clean: gc check

fullclean: gc-old check

remove-build-products:
	clean $(HOME)/Documents $(HOME)/src

gc:
	$(call delete-generations-all,$(MAX_AGE))
	$(NIX_GC) --delete-older-than $(MAX_AGE)d

gc-old: remove-build-products
	$(call delete-generations-all,1)
	$(NIX_GC) --delete-old

########################################################################

# env-build:
# 		@nix build darwin.pkgs.envs.ghc82
# 		@rm result

# env-update:
# 		@nix-env -f '<darwin>' -u --leq -Q -k -A pkgs.envs.ghc82
# 		@rm result

# env-build-all:
# 		@nix build darwin.pkgs.envs.ghc82
# 		@nix build darwin.pkgs.envs.ghc82-profiled
# 		@rm result

# env-update-all:
# 		@nix-env -f '<darwin>' -u --leq -Q -j4 -k -A pkgs \
# 		  || nix-env -f '<darwin>' -u --leq -Q -A pkgs
