#!/bin/bash

set -o errexit -o nounset

addToDrat(){
  cd ..; mkdir drat; cd drat

  ## Set up Repo parameters
  git init
  git config user.name "Colin Gillespie"
  git config user.email "csgillespie@gmail.com"
  git config --global push.default simple

  ## Get drat repo
  git remote add upstream "https://$GH_TOKEN@github.com/csgillespie/drat.git"
  git fetch upstream
  git checkout gh-pages

  Rscript -e "drat::insertPackage(devtools::build('../renamer'), \
    repodir = '.', \
    commit='Travis update: build $TRAVIS_BUILD_NUMBER')"
  git push

}

addToDrat

## Other options:
## Only add if the commit is tagged: so something like:
#if [ $TRAVIS_TAG ] ; then
#   addToDrat
#fi
##but will need to edit .travis.yml since $TRAVIS_BRANCH will now equal $TRAVIS_TAG


## Add to the drat repo
#Rscript -e "drat::insertPackage(list.files(path='../nclRintroduction', full.names = TRUE, pattern='*.tar.gz'),
#  repodir = '.',
#  commit='Travis update: build $TRAVIS_BUILD_NUMBER')"
#TRAVIS_BUILD_NUMBER

