#!/bin/bash
#
# deploy a minion from git
#

set -eux

TOP_SRCDIR=$(readlink -f $(dirname $0)/../..)
cd ${TOP_SRCDIR}


function setup {
    base_setup

    # Create a temporary dumb git repository
    export GIT_WORKTREE=${TMP_DIR}/dumb
    export GIT_DIR=${GIT_WORKTREE}/.git
    mkdir -p ${GIT_WORKTREE}
    git init
    git checkout -b master
    # Put dumb deploy code in a .deploy/ directory
    cp -ar ${TOP_SRCDIR}/test/fixtures/dumb-project ${GIT_WORKTREE}/.minion
    pushd ${GIT_WORKTREE}
    git add -f .minion
    popd
    git commit -m import

    cat > ${TMP_DIR}/etc/salt/grains <<EOF
minions:
$(base_grains)
  setups:
   dumb:
     git: ${GIT_DIR}
     version: master
     grains:
       dumbproject:
         destdir: ${DESTDIR}
EOF
}

. test/_testlib.sh

salt-call_ state.sls minions
salt-call_ minions.sls dumb install

test -e ${DESTDIR}/dumb-installed
