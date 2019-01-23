#!/bin/bash
find ./build/web-mobile -name "*.png" | xargs -i tools/pngquant.exe -f -v --ext .png --speed 1 --skip-if-larger {}
find ./build/web-desktop -name "*.png" | xargs -i tools/pngquant.exe -f -v --ext .png --speed 1 --skip-if-larger {}
find ./build/jsb-link/res -name "*.png" | xargs -i tools/pngquant.exe -f -v --ext .png --speed 1 --skip-if-larger {}