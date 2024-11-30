#!/bin/bash

cd example/ios
rm -r .symlinks
pod deintegrate
rm Podfile.lock
pod update
pod install
cd ..

cd ..