CC = gcc

CFLAGS = -Wall -W -Os -g
LIB = lib/
INCLUDES = -I/java/include -I/usr/lib/jvm/java-11-openjdk-amd64/include/ -I/usr/lib/jvm/java-11-openjdk-amd64/include/linux

.ONESHELL:
SHELL=bash

.PHONY: usage
usage:
	@cat - <<EOF
		Targets:
		* c/com_jfgiraud_jlinenoise_Example.c
		* lib/jlinenoise.so
	EOF


lib/libjlinenoise.so: c/com_github_jfgiraud_jlinenoise_Example.h c/com_github_jfgiraud_jlinenoise_Example.c
	$(CC) $(CFLAGS) -L $(LIB) -shared $(INCLUDES) c/com_github_jfgiraud_jlinenoise_Example.c -o $@

.PHONY: lib
lib:
	mkdir -p lib
	make lib/libjlinenoise.so

target:
	mkdir target

target/com/github/jfgiraud/jlinenoise/Example.class: target
	javac -h c -d target src/main/java/com/github/jfgiraud/jlinenoise/Example.java

run: target/com/github/jfgiraud/jlinenoise/Example.class lib
	cd target
	java -Djava.library.path=../lib com.github.jfgiraud.jlinenoise.Example

.PHONY: clean
clean:
	@echo "Clean files"
	rm -f lib/libjlinenoise.so
	rm -rf target
	rm -rf lib



