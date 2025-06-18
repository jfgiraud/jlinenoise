CC = gcc

JAVAC = javac
CFLAGS = -Wall -W -Os -g
LIB = lib
INCLUDES = -I/java/include -I/usr/lib/jvm/java-17-openjdk-amd64/include/ -I/usr/lib/jvm/java-17-openjdk-amd64/include/linux -Iyhirose-linenoise
REPOSITORY_NAME ?= jlinenoise

VERSION ?= $(shell cat doc/VERSION)
FILE_VERSION ?= $(shell cat doc/VERSION)

.ONESHELL:
SHELL=bash

.PHONY: usage
usage:
	@cat - <<EOF
		Targets:
		* archive: create the jar (used in github pipeline for release)
		* commit-release VERSION=X.Y.Z: commit files and create a release
		* init: init yhirose-linenoise submodule
		* update-doc: update man pages and usages
		* update-version VERSION=X.Y.Z: update man pages and usages
		* install-dependencies: install dependencies (you must call this target with sudo)
	EOF

install-dependencies:
	apt install openjdk-17-jdk-headless

lib:
	mkdir -p lib

.PHONE: init
init:
	make yhirose-linenoise/.git

yhirose-linenoise/.git:
	git submodule update --init yhirose-linenoise

.c.o:
	$(CC) -fPIC -c $(CFLAGS) $(INCLUDES) $< -o $@

c/com_github_jfgiraud_jlinenoise_JLinenoiseLibrary.h: src/main/java/com/github/jfgiraud/jlinenoise/JLinenoiseLibrary.java
	$(JAVAC) -h c -d target/classes/ $<
	make c/com_github_jfgiraud_jlinenoise_JLinenoiseLibrary.o

lib/libjlinenoise.so: yhirose-linenoise/.git yhirose-linenoise/linenoise.o yhirose-linenoise/encodings/utf8.o c/com_github_jfgiraud_jlinenoise_JLinenoiseLibrary.h | lib init
	$(CC) $(CFLAGS) -L $(LIB) -shared $(INCLUDES) c/com_github_jfgiraud_jlinenoise_JLinenoiseLibrary.c yhirose-linenoise/linenoise.o yhirose-linenoise/encodings/utf8.o -o $@

target/classes/%.class: src/main/java/%.java | target/classes
	$(JAVAC) -cp target/classes -d target/classes/ $<

target/classes:
	mkdir -p target/classes

lib/$(REPOSITORY_NAME).jar: lib/libjlinenoise.so target/classes/com/github/jfgiraud/jlinenoise/JLinenoiseLibrary.class
	cd lib
	jar cvf $(REPOSITORY_NAME).jar libjlinenoise.so
	cd ../target/classes
	jar -uvf ../../lib/$(REPOSITORY_NAME).jar com/github/jfgiraud/jlinenoise/JLinenoiseLibrary.class

.PHONY: update-version
update-version:
	[[ "$(VERSION)" == "$(FILE_VERSION)" ]] && echo "Change version number! (make update-version VERSION=X.Y.Z)" && exit 1
	! grep -Eq "^## ${VERSION}\b" CHANGELOG.md && echo "No information about this version in CHANGELOG.md. Add an entry in CHANGELOG.md!" && exit 1
	@echo "Modify version in doc/VERSION"
	@echo "$(VERSION)" > doc/VERSION
	mvn -B -DnewVersion=v$(cat doc/VERSION) -DgenerateBackupPoms=false versions:set

.PHONY: archive
archive: lib/$(REPOSITORY_NAME).jar

.PHONY: commit-release
commit-release: update-version
	@echo "Commit release $$VERSION"
	git add -u .
	git commit -m "Commit for creating tag v$$VERSION"
	git push
	git tag "v$$VERSION" -m "Tag v$$VERSION"
	git push --tags

.PHONY: archive
archive: lib/$(REPOSITORY_NAME).jar

run: lib/$(REPOSITORY_NAME).jar target/classes/com/github/jfgiraud/jlinenoise/Example.class
	java -classpath target/classes -Djava.library.path=lib com.github.jfgiraud.jlinenoise.Example

.PHONY: clean
clean:
	@echo "Clean files"
	rm -f c/com_github_jfgiraud_jlinenoise_JLinenoiseLibrary.h
	rm -f lib/*.so yhirose-linenoise/{,encodings/}*.o c/*.o
	rm -f lib/libjlinenoise.so lib/jlinenoise.jar
	rm -rf target lib

.PHONY: test
test:
	@echo "No test"
