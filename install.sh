#! /bin/bash

./node_modules/coffee-script/bin/coffee -c src/*.coffee scripts/
./node_modules/jade/bin/jade src/index.jade --out ./
./node_modules/less/bin/lessc src/base.less styles/base.css
coffee -c -o scripts/ src/*.coffee