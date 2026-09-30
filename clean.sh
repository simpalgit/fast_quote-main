#!/bin/bash

# Clean Flutter project
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf ios/Runner.xcworkspace
rm -rf build
rm -rf .dart_tool
rm -rf ~/Library/Developer/Xcode/DerivedData 2>/dev/null
xattr -cr . 2>/dev/null

echo "Clean complete!"
