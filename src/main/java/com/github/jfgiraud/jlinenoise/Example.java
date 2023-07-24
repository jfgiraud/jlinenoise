package com.github.jfgiraud.jlinenoise;

public class Example {

    private static JLinenoiseLibrary lib = new JLinenoiseLibrary();

    public static void main(String[] args) {
        lib.init();
        lib.print();
        String line;
        while ((line = lib.linenoise("rpn> ")) != null) {
            System.out.println("read: " + line);
        }
    }

}