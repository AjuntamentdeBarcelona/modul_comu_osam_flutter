#!/bin/bash

rm -r .gradle

cd android
rm -r build
rm -r .gradle
cd ..

cd example

cd android
rm -r build
rm -r .gradle
cd ..

cd ios
rm -r .symlinks
pod deintegrate
rm Podfile.lock
pod install
pod update
pod install
pod update
cd ..

cd ..