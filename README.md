# libcurl-ada
Ada bind libcurl

https://fil-andrey.blogspot.com/2018/06/ada-bind-libcurl-simple-ada-parser.html

## Requirements
libcurl

libcurl4-openssl-dev (optional for https)
## Build
```
gcc -c libcurlconstants.c -lcurl
gnatmake test.adb -largs -lcurl -largs libcurlconstants.o
```
