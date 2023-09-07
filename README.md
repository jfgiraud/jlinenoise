# jlinenoise

## description
jlinenoise is a java binding around the C linenoise library.

## example
```
$ make clean run
......
......
......
Hello!
$ ls
read: ls
$ hello man
```

The arrow keys (↑ ↓ → ←) are working... See the cursor below.

![jlinenoise](https://github.com/jfgiraud/jlinenoise/assets/505040/42c6b923-50a9-4591-9145-7cb9bfa3317b)

## code
Follow the [link](src/main/java/com/github/jfgiraud/jlinenoise) to see the code of this example.

## integration

### pom.xml

Introduce the new repository and the dependency in your `pom.xml`

```xml
<repositories>
        <repository>
            <id>jitpack.io</id>
            <url>https://jitpack.io</url>
        </repository>
    </repositories>

    <dependencies>
        <dependency>
            <groupId>com.github.jfgiraud</groupId>
            <artifactId>jlinenoise</artifactId>
            <version>v0.0.13</version>
        </dependency>
    </dependencies>
```
