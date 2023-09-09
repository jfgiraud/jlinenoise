#include <jni.h>
#include <stdio.h>
#include "com_github_jfgiraud_jlinenoise_JLinenoiseLibrary.h"
#include "linenoise.h"
#include "encodings/utf8.h"

JNIEXPORT void JNICALL   Java_com_github_jfgiraud_jlinenoise_JLinenoiseLibrary_print(JNIEnv *env, jobject obj)  {
     printf("Hello!\n");
     return;
}

JNIEXPORT jstring JNICALL Java_com_github_jfgiraud_jlinenoise_JLinenoiseLibrary_linenoise
  (JNIEnv *env, jobject obj, jstring prompt) {
   const char *cprompt = (*env)->GetStringUTFChars(env, prompt, NULL); //TODO ReleaseStringUTFChars
   char *cresult = linenoise(cprompt);
   jstring result = (*env)->NewStringUTF(env, cresult);
   (*env)->ReleaseStringUTFChars(env, prompt, cprompt);
   free(cresult);
   return result;
}

JNIEXPORT void JNICALL Java_com_github_jfgiraud_jlinenoise_JLinenoiseLibrary_init
  (JNIEnv *env, jobject obj) {
   linenoiseSetEncodingFunctions(
          linenoiseUtf8PrevCharLen,
          linenoiseUtf8NextCharLen,
          linenoiseUtf8ReadCode);
}

JNIEXPORT void JNICALL Java_com_github_jfgiraud_jlinenoise_JLinenoiseLibrary_loadHistory
  (JNIEnv *env, jobject obj, jstring filepath) {
  const char *cfilepath = (*env)->GetStringUTFChars(env, filepath, NULL);
  linenoiseHistoryLoad(cfilepath);
  (*env)->ReleaseStringUTFChars(env, filepath, cfilepath);
}

JNIEXPORT void JNICALL Java_com_github_jfgiraud_jlinenoise_JLinenoiseLibrary_saveHistory
  (JNIEnv *env, jobject obj, jstring filepath) {
  const char *cfilepath = (*env)->GetStringUTFChars(env, filepath, NULL);
  linenoiseHistorySave(cfilepath);
  (*env)->ReleaseStringUTFChars(env, filepath, cfilepath);
}

JNIEXPORT void JNICALL Java_com_github_jfgiraud_jlinenoise_JLinenoiseLibrary_addToHistory
  (JNIEnv *env, jobject obj, jstring line) {
  const char *cline = (*env)->GetStringUTFChars(env, line, NULL);
  linenoiseHistoryAdd(cline);
  (*env)->ReleaseStringUTFChars(env, line, cline);
}