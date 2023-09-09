package com.github.jfgiraud.jlinenoise;

public class Example {

    private static JLinenoiseLibrary lib = new JLinenoiseLibrary();

    public static void main(String[] args) {
        lib.init();
        lib.print();
        lib.loadHistory("history.txt");
        String line;
        while ((line = lib.linenoise("$ ")) != null) {
            System.out.println("read: " + line);
            lib.addToHistory(line);
            lib.saveHistory("history.txt");
        }
    }

}