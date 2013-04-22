#! /bin/bash

coffee -c src/*.coffee scripts/
jade src/index.jade --out ./
lessc src/base.less styles/base.css
coffee -c -o scripts/ src/*.coffee