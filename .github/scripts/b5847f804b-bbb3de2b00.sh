#!/bin/bash

set -ex
export TRAVIS_BUILD_DIR=$(pwd)
export TRAVIS_BRANCH=${TRAVIS_BRANCH:-$(echo $GITHUB_REF | awk 'BEGIN { FS = "/" } ; { print $3 }')}
export VCS_COMMIT_ID=$GITHUB_SHA
export GIT_COMMIT=$GITHUB_SHA
export REPO_NAME=$(basename $GITHUB_REPOSITORY)
export PATH=~/.local/bin:/usr/local/bin:$PATH

echo '==================================> BEFORE_INSTALL'

. .github/scripts/before-install.sh

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

echo '==================================> BEFORE_SCRIPT'

. $GITHUB_WORKSPACE/.github/scripts/before-script.sh

echo '==================================> SCRIPT'

pushd /tmp && git clone https://github.com/linux-test-project/lcov.git && export PATH=/tmp/lcov/bin:$PATH && which lcov && lcov --version && popd
cd $BOOST_ROOT/libs/$SELF
ci/travis/codecov.sh

echo '==================================> AFTER_SUCCESS'

. $GITHUB_WORKSPACE/.github/scripts/after-success.sh
