package com.github.jfgiraud.jlinenoise;

public class Example {

    private native void print();

    public static void main(String[] args) {
        new Example().print();
    }

    static {
        System.loadLibrary("jlinenoise");
    }

}