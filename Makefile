CC = gcc

JAVAC = javac
CFLAGS = -Wall -W -Os -g
LIB = lib
INCLUDES = -I/java/include -I/usr/lib/jvm/java-11-openjdk-amd64/include/ -I/usr/lib/jvm/java-11-openjdk-amd64/include/linux -Ilinenoise

VERSION ?= $(shell cat doc/VERSION)
FILE_VERSION ?= $(shell cat doc/VERSION)

.ONESHELL:
SHELL=bash

.PHONY: usage
usage:
	@cat - <<EOF
		Targets:
		* c/com_jfgiraud_jlinenoise_Example.c
		* lib/jlinenoise.so
	EOF

install-dependencies:
	git submodule update --init linenoise

lib:
	mkdir -p lib

.c.o:
	$(CC) -fPIC -c $(CFLAGS) $(INCLUDES) $< -o $@

c/com_github_jfgiraud_jlinenoise_Library.h: src/main/java/com/github/jfgiraud/jlinenoise/Library.java
	$(JAVAC) -h c -d target/classes/ $<
	make c/com_github_jfgiraud_jlinenoise_Library.o

lib/libjlinenoise.so: linenoise/linenoise.o linenoise/encodings/utf8.o c/com_github_jfgiraud_jlinenoise_Library.h | lib
	$(CC) $(CFLAGS) -L $(LIB) -shared $(INCLUDES) c/com_github_jfgiraud_jlinenoise_Library.c linenoise/linenoise.o linenoise/encodings/utf8.o -o $@

target/classes/%.class: src/main/java/%.java | target/classes
	$(JAVAC) -cp target/classes -d target/classes/ $<

target/classes:
	mkdir -p target/classes

lib/$(REPOSITORY_NAME).jar: lib/libjlinenoise.so target/classes/com/github/jfgiraud/jlinenoise/Library.class
	cd lib
	jar cvf $(REPOSITORY_NAME).jar libjlinenoise.so
	cd ../target/classes
	jar -uvf ../../lib/$(REPOSITORY_NAME).jar com/github/jfgiraud/jlinenoise/Library.class

.PHONY: update-version
update-version:
	[[ "$(VERSION)" == "$(FILE_VERSION)" ]] && echo "Change version number! (make update-version VERSION=X.Y.Z)" && exit 1
	! grep -Eq "^## ${VERSION}\b" CHANGELOG.md && echo "No information about this version in CHANGELOG.md. Add an entry in CHANGELOG.md!" && exit 1
	@echo "Modify version in doc/VERSION"
	@echo "$(VERSION)" > doc/VERSION

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

run: lib/$(REPOSITORY_NAME).jar target/classes/com/github/jfgiraud/jlinenoise/Example.class
	cd target/classes
	java -Djava.library.path=../../lib com.github.jfgiraud.jlinenoise.Example

.PHONY: clean
clean:
	@echo "Clean files"
	rm -f c/com_github_jfgiraud_jlinenoise_Library.h
	rm -f lib/*.so linenoise/{,encodings/}*.o c/*.o
	rm -f lib/libjlinenoise.so lib/jlinenoise.jar
	rm -rf target lib

.PHONY: test
test:
	@echo "No test"
	tree
