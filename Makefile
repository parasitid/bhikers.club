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
	flutter build apk \
             --release --no-pub --suppress-analytics

clean: ## clean clojuredart code
	clj -M:cljd clean

clean-full: clean ## full clean
	flutter clean

upgrade:
	clj -M:cljd upgrade
	flutter pub upgrade
