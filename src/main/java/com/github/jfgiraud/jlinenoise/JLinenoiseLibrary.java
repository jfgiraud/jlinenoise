package com.github.jfgiraud.jlinenoise;

public class JLinenoiseLibrary {

    public native void print();

    public native void init();

    public native String linenoise(String prompt);

    public native void loadHistory(String filepath);

    public native void addToHistory(String line);

    public native void saveHistory(String filepath);

//    public native void linenoiseAddCompletion(Completions lc, String str);

    /**
     * Clear screen.
     */
//    public native void linenoiseClearScreen();
//
//    public native int linenoiseHistoryAdd(String line);
//
//    public native String linenoiseHistoryGet(int index);
//
//    public native int linenoiseHistoryGetLen();
//
//    public native int linenoiseHistoryLoad(String filename);
//
//    public native int linenoiseHistorySave(String filename);
//
//    public native int linenoiseHistorySetMaxLen(int len);
//
//    public native void linenoisePrintKeyCodes();
//
////    public native void linenoiseSetCompletionCallback(CompletionCallback fn);
//
//    public native void linenoiseSetMultiLine(int ml);

    static {
        System.loadLibrary("jlinenoise");
    }
}
