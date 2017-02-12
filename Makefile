#!/bin/make -f

DO         := ./build/utils.sh
SET_CONFIG := $(DO) set-config
DESTDIR    ?= /

define colorecho
	@tput setaf 118 || true
	@echo $1        || true
	@tput sgr0      || true
endef

ifeq ($(MAKECMDGOALS),build_dev)
debug_mode   := True
decorated    := True
stays_on_top := False
endif


# Configuration: Use values from command line if provided, default values otherwise.
at_spi_service        ?= True
background_images_dir ?= $(abspath $(DESTDIR)/usr/share/backgrounds)
config_dir            ?= $(abspath $(DESTDIR)/etc/lightdm)
debug_mode            ?= False
decorated             ?= False
greeters_dir          ?= $(abspath $(DESTDIR)/usr/share/xgreeters)
locale_dir            ?= $(abspath $(DESTDIR)/usr/share/locale)
themes_dir            ?= $(abspath $(DESTDIR)/usr/share/web-greeter/themes)
logo_image            ?= $(themes_dir)/default/img/antergos-logo-user.png
stays_on_top          ?= True
user_image            ?= $(themes_dir)/default/img/antergos.png


_apply_config:
	@$(SET_CONFIG) at_spi_service        $(at_spi_service)
	@$(SET_CONFIG) background_images_dir $(background_images_dir)
	@$(SET_CONFIG) config_dir            $(config_dir)
	@$(SET_CONFIG) debug_mode            $(debug_mode)
	@$(SET_CONFIG) decorated             $(decorated)
	@$(SET_CONFIG) greeters_dir          $(greeters_dir)
	@$(SET_CONFIG) locale_dir            $(locale_dir)
	@$(SET_CONFIG) themes_dir            $(themes_dir)
	@$(SET_CONFIG) logo_image            $(logo_image)
	@$(SET_CONFIG) stays_on_top          $(stays_on_top)
	@$(SET_CONFIG) user_image            $(user_image)

_build_init: clean
	$(DO) build-init

all: install

build: _build_init _apply_config
	$(DO) build

build_dev: install
	sudo $(DO) install-dev

clean:
	$(DO) clean

install: build
	sudo $(DO) install $(DESTDIR)
	$(call colorecho, SUCCESS!)


.PHONY: all _apply_config _build_init build build_dev clean install