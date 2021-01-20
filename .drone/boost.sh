#!/bin/bash

# Copyright 2020 Rene Rivera, Sam Darwin
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.txt or copy at http://boost.org/LICENSE_1_0.txt)

set -ex
export TRAVIS_BUILD_DIR=$(pwd)
export DRONE_BUILD_DIR=$(pwd)
export TRAVIS_BRANCH=$DRONE_BRANCH
export VCS_COMMIT_ID=$DRONE_COMMIT
export GIT_COMMIT=$DRONE_COMMIT
export REPO_NAME=$DRONE_REPO
export PATH=~/.local/bin:/usr/local/bin:$PATH

echo '==================================> INSTALL'

git clone https://github.com/boostorg/boost-ci.git boost-ci
cp -pr boost-ci/ci boost-ci/.codecov.yml .

if [ "$TRAVIS_OS_NAME" == "osx" ]; then
    unset -f cd
fi

export SELF=`basename $REPO_NAME`
export BOOST_CI_TARGET_BRANCH="$TRAVIS_BRANCH"
export BOOST_CI_SRC_FOLDER=$(pwd)

. ./ci/common_install.sh

echo '==================================> SCRIPT'

cd $BOOST_ROOT/libs/$SELF
ci/travis/build.sh
