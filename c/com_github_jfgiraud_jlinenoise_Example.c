#include <jni.h>
#include <stdio.h>
#include "com_github_jfgiraud_jlinenoise_Example.h"

JNIEXPORT void JNICALL   Java_com_github_jfgiraud_jlinenoise_Example_print(JNIEnv *env, jobject obj)  {
     printf("salut jeff!\n");
     return;
}