#include <jni.h>
#include <stdio.h>
#include "com_github_jfgiraud_jlinenoise_Library.h"
#include "linenoise.h"
#include "encodings/utf8.h"

JNIEXPORT void JNICALL   Java_com_github_jfgiraud_jlinenoise_Library_print(JNIEnv *env, jobject obj)  {
     printf("salut jeff!\n");
     return;
}

JNIEXPORT jstring JNICALL Java_com_github_jfgiraud_jlinenoise_Library_linenoise
  (JNIEnv *env, jobject obj, jstring prompt) {
   const char *cprompt = (*env)->GetStringUTFChars(env, prompt, NULL);
   char *cresult = linenoise(cprompt);
   jstring result = (*env)->NewStringUTF(env, cresult);
   (*env)->ReleaseStringUTFChars(env, prompt, cresult);
   return result;
}

JNIEXPORT void JNICALL Java_com_github_jfgiraud_jlinenoise_Library_init
  (JNIEnv *env, jobject obj) {
   linenoiseSetEncodingFunctions(
          linenoiseUtf8PrevCharLen,
          linenoiseUtf8NextCharLen,
          linenoiseUtf8ReadCode);
}