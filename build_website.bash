#!/usr/bin/env bash
cd docker

# copy in Gemfile to ensure correct dependenies are built into the image
cp ../Gemfile .

# build and run the image
./build.bash
./run.bash

# check if site has meaningfully changed (i.e. any file besides sitemap.xml's time stamps changed), if so push update
GIT_TARGET="-C ../_site"
files_changed=$(git $GIT_TARGET whatchanged -1 --format=oneline | tail -n +2 | grep -v sitemap.xml$ | wc -l)

if [$files_changed -gt 0]; then
    git $GIT_TARGET add -A && git $GIT_TARGET commit -m "docker build: $(date)" && git $GIT_TARGET
else
    echo "no website content has changed"
fi
