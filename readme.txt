javac -h c -d target src/main/java/org/example/Main.java

cc -Wall -W -Os -g -L . -shared -I/java/include -I/usr/lib/jvm/java-11-openjdk-amd64/include/ -I/usr/lib/jvm/java-11-openjdk-amd64/include/linux c/org_example_Main.c -o libMain.so

$ java -Djava.library.path=.. com.github.jfgiraud.jlinenoise.Example
salut jeff!

