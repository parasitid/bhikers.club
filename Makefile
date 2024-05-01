.PHONY: test
GIT_COMMIT := $(shell git rev-parse --short HEAD)
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
REPO_URL := "https://github.com/parasitid/bhikers.club"
# Extract owner and repo name
repo_path := $(shell echo $(REPO_URL) | sed -E 's|https://github.com/([^/]+)/([^/]+).*|\1/\2|')
# Build GitHub API URL for latest release
LATEST_RELEASE_API := https://api.github.com/repos/$(repo_path)/releases/latest
# These would be passed via GitHub Actions ENV or defined manually for local testing
BUILD_NAME ?= $(shell grep 'version:' pubspec.yaml | cut -d '+' -f1 | sed 's/version: //')
BUILD_NUMBER ?= $(shell grep 'version:' pubspec.yaml | cut -d '+' -f2)
BUILD_ID := $(BUILD_NAME)+$(BUILD_NUMBER)
##
# Bhikers Club
#
# @file
# @version 0.1
locale-gen: ## generate dart code for locale files
	flutter pub run easy_localization:generate -S src/resources/langs/
# end

test: ## run tests
	clj -M:test:cljd test

compile: ## run tests
	clj -M:cljd compile

apk: compile ## build apk
	flutter build apk \
             --debug --pub --suppress-analytics

apk-release: compile ## build apk for release
	@echo "Building APK with:"
	@echo "  GIT_COMMIT:          $(GIT_COMMIT)"
	@echo "  GIT_BRANCH:          $(GIT_BRANCH)"
	@echo "  BUILD_NAME:          $(BUILD_NAME)"
	@echo "  BUILD_NUMBER:        $(BUILD_NUMBER)"
	@echo "  BUILD_ID:            $(BUILD_ID)"
	@echo "  REPO_URL:            $(REPO_URL)"
	@echo "  LATEST_RELEASE_API:  $(LATEST_RELEASE_API)"
	flutter build apk \
		--dart-define=GIT_COMMIT=$(GIT_COMMIT) \
		--dart-define=GIT_BRANCH=$(GIT_BRANCH) \
		--dart-define=REPO_URL=$(REPO_URL) \
		--dart-define=LATEST_RELEASE_API=$(LATEST_RELEASE_API) \
		--build-number "$(BUILD_NUMBER)" \
		--build-name "$(BUILD_NAME)" \
		--release --no-pub --suppress-analytics

clean: ## clean clojuredart code
	clj -M:cljd clean

clean-full: clean ## full clean
	flutter clean

upgrade:
	clj -M:cljd upgrade
	flutter pub upgrade

format:
	cljfmt fix --file-pattern '\.cljd' src/club/bhikers/

precompile-svg:
	flutter pub run vector_graphics_compiler --libpathops $(FLUTTER_HOME)/bin/cache/artifacts/engine/linux-x64/libpath_ops.so --input-dir ./src/resources/icons/symbols/
