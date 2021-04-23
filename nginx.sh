#!/bin/bash

REPO="github.com/sudaport/nginx-proxy.git"

GIT_BRANCH='mirror'

dir=$(basename "$REPO" ".git")
dir=${PWD}/../${dir}

if [[ -d "$dir" ]]; then
   echo "Folder $dir already exists"
else
   git clone -b $GIT_BRANCH "https://$REPO" $dir
fi
