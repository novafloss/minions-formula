#!/bin/bash
#
# deploy a minion from git
#

set -eux

TOP_SRCDIR=$(readlink -f $(dirname $0)/../..)
cd ${TOP_SRCDIR}


function setup {
    base_setup

    # Create a temporary git repository
    export GIT_WORKTREE=${TMP_DIR}/myapp
    export GIT_DIR=${GIT_WORKTREE}/.git
    mkdir -p ${GIT_WORKTREE}
    git init
    git checkout -b master
    # Put myapp minion code in a .minion/ directory
    cp -ar ${TOP_SRCDIR}/test/fixtures/myapp ${GIT_WORKTREE}/.minion
    pushd ${GIT_WORKTREE}
    git add -f .minion
    popd
    git commit -m import

    cat > ${TMP_DIR}/etc/salt/grains <<EOF
minions:
$(base_grains)
  setups:
   myapp:
     git: ${GIT_DIR}
     version: master
     opspillar:
       myapp:
         destdir: ${DESTDIR}
EOF
}

. test/_testlib.sh

salt-call_ state.sls minions
salt-call_ minions.sls myapp myapp.install

test -e ${DESTDIR}/myapp-installed
