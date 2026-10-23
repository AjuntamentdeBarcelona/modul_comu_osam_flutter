rm -f pubspec.lock &&
rm -f -r ios/.build &&
rm -f -r ios/.swiftpm &&
rm -f -r android/.gradle &&
rm -f -r android/build &&
rm -f -r android/app/.gradle &&
rm -f -r android/app/build &&
fvm flutter precache --ios &&
fvm flutter clean &&
fvm flutter pub get