#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
python Build.py --js JS_BROWSER
python3 Build.py --js JS_BROWSER
popd
