#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
python Build.py --python STANDARD
python3 Build.py --python STANDARD
popd
