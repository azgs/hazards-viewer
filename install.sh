#! /bin/bash

./node_modules/coffee-script/bin/coffee -c -o scripts/ src/*.coffee
./node_modules/jade/bin/jade src/index.jade --out ./
./node_modules/less/bin/lessc src/base.less styles/base.css
mv scripts/server.js ./