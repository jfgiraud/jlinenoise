CC = gcc

JAVAC = javac
CFLAGS = -Wall -W -Os -g
LIB = lib
INCLUDES = -I/java/include -I/usr/lib/jvm/java-11-openjdk-amd64/include/ -I/usr/lib/jvm/java-11-openjdk-amd64/include/linux -Ilinenoise

.ONESHELL:
SHELL=bash

.PHONY: usage
usage:
	@cat - <<EOF
		Targets:
		* c/com_jfgiraud_jlinenoise_Example.c
		* lib/jlinenoise.so
	EOF

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

lib/jlinenoise.jar: lib/libjlinenoise.so target/classes/com/github/jfgiraud/jlinenoise/Library.class
	cd lib
	jar cvf jlinenoise.jar libjlinenoise.so
	cd ../target/classes
	jar -uvf ../../lib/jlinenoise.jar com/github/jfgiraud/jlinenoise/Library.class

.PHONY: jar
jar: lib/jlinenoise.jar

run: lib/jlinenoise.jar target/classes/com/github/jfgiraud/jlinenoise/Example.class
	cd target/classes
	java -Djava.library.path=../../lib com.github.jfgiraud.jlinenoise.Example

.PHONY: clean
clean:
	@echo "Clean files"
	rm -f c/com_github_jfgiraud_jlinenoise_Library.h
	rm -f lib/*.so linenoise/{,encodings/}*.o c/*.o
	rm -f lib/libjlinenoise.so lib/jlinenoise.jar
	rm -rf target lib



