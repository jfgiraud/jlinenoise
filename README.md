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

Follow the [link](src/main/java/com/github/jfgiraud/jlinenoise) to see the code of this example and use jlinenoise in your project.

## The arrow keys (↑ ↓ → ←) are working... See the cursor below.

![jlinenoise](https://github.com/jfgiraud/jlinenoise/assets/505040/42c6b923-50a9-4591-9145-7cb9bfa3317b)

Methods :
* `init()`
* `linenoise(prompt)`

## An history file can be set.

Methods :
* `loadHistory(filepath)`
* `addToHistory(line)`
* `saveHistory(filepath)`

## integration

of the version `v0.0.22`
### Download the jar

```bash
mvn install:install-file -Dfile=jlinenoise.jar -DgroupId=com.github.jfgiraud -DartifactId=jlinenoise -Dversion=v0.0.22 -Dpackaging=jar -DgeneratePom=true
```

### Install the jar in your .m2 repository

```bash
mvn install:install-file -Dfile=jlinenoise.jar -DgroupId=com.github.jfgiraud -DartifactId=jlinenoise -Dversion=v0.0.22 -Dpackaging=jar -DgeneratePom=true
```

### pom.xml

Introduce the dependency in your `pom.xml`

```xml
    <dependency>
        <groupId>com.github.jfgiraud</groupId>
        <artifactId>jlinenoise</artifactId>
        <version>v0.0.22</version>
    </dependency> 
```

### code example

Follow the [link](src/main/java/com/github/jfgiraud/jlinenoise) to see the code of this example and use jlinenoise in your project.

