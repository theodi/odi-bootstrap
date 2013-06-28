CLONE_URL = git@github.com:theodi/odi-bootstrap.git
REPO_DIR=$(shell pwd)
BOOTSTRAP = ./docs/assets/css/bootstrap.css
BOOTSTRAP_LESS = ./less/bootstrap.less
BOOTSTRAP_RESPONSIVE = ./docs/assets/css/bootstrap-responsive.css
BOOTSTRAP_RESPONSIVE_LESS = ./less/responsive.less
ODI_BOOTSTRAP_LESS = ./less/odi/odi.less
ODI_BOOTSTRAP_CRIMSON_LESS = ./less/odi/odi-crimson.less
ODI_BOOTSTRAP_GREEN_LESS = ./less/odi/odi-green.less
ODI_BOOTSTRAP_ORANGE_LESS = ./less/odi/odi-orange.less
ODI_BOOTSTRAP_POMEGRANATE_LESS = ./less/odi/odi-pomegranate.less
ODI_BOOTSTRAP_RED_LESS = ./less/odi/odi-red.less
ODI_BOOTSTRAP = ./docs/assets/css/odi-bootstrap.css
ODI_BOOTSTRAP_CRIMSON = ./docs/assets/css/odi-bootstrap-crimson.css
ODI_BOOTSTRAP_GREEN = ./docs/assets/css/odi-bootstrap-green.css
ODI_BOOTSTRAP_ORANGE = ./docs/assets/css/odi-bootstrap-orange.css
ODI_BOOTSTRAP_POMEGRANATE = ./docs/assets/css/odi-bootstrap-pomegranate.css
ODI_BOOTSTRAP_RED = ./docs/assets/css/odi-bootstrap-red.css
DATE=$(shell date +%I:%M%p)
DATETIME=$(shell date '+%Y-%m-%d %H:%M')
CHECK=\033[32m✔\033[39m
HR=\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#


#
# BUILD DOCS
#

build:
	@echo "\n${HR}"
	@echo "Building Bootstrap..."
	@echo "${HR}\n"
	@./node_modules/.bin/jshint js/*.js --config js/.jshintrc
	@./node_modules/.bin/jshint js/tests/unit/*.js --config js/.jshintrc
	@echo "Running JSHint on javascript...             ${CHECK} Done"
	@./node_modules/.bin/recess --compile ${BOOTSTRAP_LESS} > ${BOOTSTRAP}
	@./node_modules/.bin/recess --compile ${BOOTSTRAP_RESPONSIVE_LESS} > ${BOOTSTRAP_RESPONSIVE}
	@./node_modules/.bin/recess --compile ${ODI_BOOTSTRAP_LESS} > ${ODI_BOOTSTRAP}
	@./node_modules/.bin/recess --compile ${ODI_BOOTSTRAP_CRIMSON_LESS} > ${ODI_BOOTSTRAP_CRIMSON}
	@./node_modules/.bin/recess --compile ${ODI_BOOTSTRAP_GREEN_LESS} > ${ODI_BOOTSTRAP_GREEN}
	@./node_modules/.bin/recess --compile ${ODI_BOOTSTRAP_ORANGE_LESS} > ${ODI_BOOTSTRAP_ORANGE}
	@./node_modules/.bin/recess --compile ${ODI_BOOTSTRAP_POMEGRANATE_LESS} > ${ODI_BOOTSTRAP_POMEGRANATE}
	@./node_modules/.bin/recess --compile ${ODI_BOOTSTRAP_RED_LESS} > ${ODI_BOOTSTRAP_RED}
	@echo "Compiling LESS with Recess...               ${CHECK} Done"
	@node docs/build
	@cp -r img/* docs/assets/img/
	@cp js/*.js docs/assets/js/
	@cp js/tests/vendor/jquery.js docs/assets/js/
	@echo "Compiling documentation...                  ${CHECK} Done"
	@cat js/bootstrap-transition.js js/bootstrap-alert.js js/bootstrap-button.js js/bootstrap-carousel.js js/bootstrap-collapse.js js/bootstrap-dropdown.js js/bootstrap-modal.js js/bootstrap-tooltip.js js/bootstrap-popover.js js/bootstrap-scrollspy.js js/bootstrap-tab.js js/bootstrap-typeahead.js js/bootstrap-affix.js > docs/assets/js/bootstrap.js
	@./node_modules/.bin/uglifyjs -nc docs/assets/js/bootstrap.js > docs/assets/js/bootstrap.min.tmp.js
	@echo "/**\n* Bootstrap.js v2.3.2 by @fat & @mdo\n* Copyright 2012 Twitter, Inc.\n* http://www.apache.org/licenses/LICENSE-2.0.txt\n*/" > docs/assets/js/copyright.js
	@cat docs/assets/js/copyright.js docs/assets/js/bootstrap.min.tmp.js > docs/assets/js/bootstrap.min.js
	@rm docs/assets/js/copyright.js docs/assets/js/bootstrap.min.tmp.js
	@echo "Compiling and minifying javascript...       ${CHECK} Done"
	@echo "\n${HR}"
	@echo "Bootstrap successfully built at ${DATE}."
	@echo "${HR}\n"
	@echo "Thanks for using Bootstrap,"
	@echo "<3 @mdo and @fat\n"

#
# RUN JSHINT & QUNIT TESTS IN PHANTOMJS
#

test:
	./node_modules/.bin/jshint js/*.js --config js/.jshintrc
	./node_modules/.bin/jshint js/tests/unit/*.js --config js/.jshintrc
	node js/tests/server.js &
	phantomjs js/tests/phantom.js "http://localhost:3000/js/tests"
	kill -9 `cat js/tests/pid.txt`
	rm js/tests/pid.txt

#
# CLEANS THE ROOT DIRECTORY OF PRIOR BUILDS
#

clean:
	rm -r bootstrap

#
# BUILD SIMPLE BOOTSTRAP DIRECTORY
# recess & uglifyjs are required
#

bootstrap: bootstrap-img bootstrap-css bootstrap-js


#
# JS COMPILE
#
bootstrap-js: bootstrap/js/*.js

bootstrap/js/*.js: js/*.js
	mkdir -p bootstrap/js
	cat js/bootstrap-transition.js js/bootstrap-alert.js js/bootstrap-button.js js/bootstrap-carousel.js js/bootstrap-collapse.js js/bootstrap-dropdown.js js/bootstrap-modal.js js/bootstrap-tooltip.js js/bootstrap-popover.js js/bootstrap-scrollspy.js js/bootstrap-tab.js js/bootstrap-typeahead.js js/bootstrap-affix.js > bootstrap/js/bootstrap.js
	./node_modules/.bin/uglifyjs -nc bootstrap/js/bootstrap.js > bootstrap/js/bootstrap.min.tmp.js
	echo "/*!\n* Bootstrap.js by @fat & @mdo\n* Copyright 2012 Twitter, Inc.\n* http://www.apache.org/licenses/LICENSE-2.0.txt\n*/" > bootstrap/js/copyright.js
	cat bootstrap/js/copyright.js bootstrap/js/bootstrap.min.tmp.js > bootstrap/js/bootstrap.min.js
	rm bootstrap/js/copyright.js bootstrap/js/bootstrap.min.tmp.js

#
# CSS COMPLILE
#

bootstrap-css: bootstrap/css/*.css

bootstrap/css/*.css: less/*.less
	mkdir -p bootstrap/css
	./node_modules/.bin/recess --compile ${BOOTSTRAP_LESS} > bootstrap/css/bootstrap.css
	./node_modules/.bin/recess --compress ${BOOTSTRAP_LESS} > bootstrap/css/bootstrap.min.css
	./node_modules/.bin/recess --compile ${BOOTSTRAP_RESPONSIVE_LESS} > bootstrap/css/bootstrap-responsive.css
	./node_modules/.bin/recess --compress ${BOOTSTRAP_RESPONSIVE_LESS} > bootstrap/css/bootstrap-responsive.min.css

#
# IMAGES
#

bootstrap-img: bootstrap/img/*

bootstrap/img/*: img/*
	mkdir -p bootstrap/img
	cp img/* bootstrap/img/


#
# MAKE FOR GH-PAGES 4 FAT & MDO ONLY (O_O  )
#

gh-pages: bootstrap docs
	rm -f docs/assets/bootstrap.zip
	zip -r docs/assets/bootstrap.zip bootstrap
	rm -r bootstrap
	rm -f ../bootstrap-gh-pages/assets/bootstrap.zip
	node docs/build production
	cp -r docs/* ../bootstrap-gh-pages

#
# WATCH LESS FILES
#

watch:
	echo "Watching less files..."; \
	watchr -e "watch('less/.*\.less') { system 'make' }"


.PHONY: docs watch gh-pages bootstrap-img bootstrap-css bootstrap-js
	
#
# Upload latest build to Github pages
#

upload:
	make build
	echo "Uploading..." ; \
	echo "\n${HR}" ; \
	git clone ${CLONE_URL} /tmp/odi-bootstrap; \
	cd /tmp/odi-bootstrap; \
	git checkout gh-pages; \
	cp -R ${REPO_DIR}/docs/assets/* /tmp/odi-bootstrap ; \
	git add . ; \
	git commit -m 'Update ${DATETIME}' . ; \
	git push origin gh-pages
	rm -rf /tmp/odi-bootstrap
	
	