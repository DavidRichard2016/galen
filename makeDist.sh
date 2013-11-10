#!/bin/bash

set -e

if [ -d dist ]; then
    rm -rf dist/*
fi


function read_var {
    printf "$1"
    if [[ -n $3 ]]; then
        printf " [$3]: "
    else
        printf ": "
    fi
    read input

    if [[ -n $3 && -z $input ]]; then
        input=$3
    fi

    eval "$2=\$input"
}


version_promt=$( cat pom.xml | grep "<version>" | head -n 1 | awk -F"[<>]" '/version/{print $3}' | sed "s/-SNAPSHOT//g" )

read_var "Enter version" version "$version_promt"

bin=bin-${version}
src=src-${version}


mkdir -p dist/$bin
mkdir -p dist/$src

echo New dist is $version
echo Assemblying new dist

mvn assembly:assembly -DskipTests=true

cp target/galen-jar-with-dependencies.jar dist/$bin/galen.jar
cp galen dist/$bin/.
cp LICENSE-2.0.txt dist/$bin/.
cp README dist/$bin/.

cp LICENSE-2.0.txt dist/$src/.
cp README dist/$src/.
cp -r src dist/$src/src


cd dist

zip -r -9 galen-$bin.zip $bin
zip -r -9 galen-$src.zip $src
