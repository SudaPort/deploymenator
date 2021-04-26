#!/bin/bash

REPOS=(
    "github.com/sudaport/cashier-daemon.git"
    "github.com/sudaport/emission-daemon.git"
)

GIT_BRANCH='main'
CUR_DIR=${PWD}

function makeconfig {
    cd $1 && cp -f ${CUR_DIR}/clear.env .env
}

for i in "${REPOS[@]}"
do
    dir=$(basename "$i" ".git")
    dir=${CUR_DIR}/../${dir}

   if [[ -d "$dir" ]]; then
       cd $dir && makeconfig $dir && make build && cd ..
   else
       git clone -b $GIT_BRANCH "http://$i" $dir
       cd $dir && makeconfig $dir && make build && cd ..
   fi
done
