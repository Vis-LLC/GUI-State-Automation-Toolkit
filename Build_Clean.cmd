#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
python Build.py CLEAN CLEAN
python3 Build.py CLEAN CLEAN
popd
