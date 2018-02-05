#!/bin/sh
source "${BASH_SOURCE[0]%/*}/util.sh"

languages=( $(svn ls https://svn.code.sf.net/p/apertium/svn/languages | grep / | cut -d '/' -f 1) )
for lang in "${languages[@]}"
do
    # delete existing stuff
    # rm -rf $lang.git/
    # delete $lang

    # do the import
    ../subgit-3.2.6/bin/subgit configure \
        --layout directory \
        --svn-url https://svn.code.sf.net/p/apertium/svn/languages/$lang/
    cp ../authors.txt $lang.git/subgit/authors.txt
    ../subgit-3.2.6/bin/subgit install $lang.git

    # setup the new repo
    create_repo $lang
    cd $lang.git/
    git remote add origin git@github.com:$ORG/$lang.git
    git push origin --force --all
    set_repo_topics $lang '["languages"]'

    # clean up
    cd ..
    rm -rf $lang.git/
done