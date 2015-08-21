#!/bin/bash

set -eux

TOP_SRCDIR=$(readlink -f $(dirname $0)/../..)
cd ${TOP_SRCDIR}

. test/_testlib.sh

base_setup

export GIT_WORKTREE=${TMP_DIR}/dumb
export GIT_DIR=${GIT_WORKTREE}/.git
mkdir -p ${GIT_WORKTREE}
git init
git checkout -b master
cp -ar ${TOP_SRCDIR}/test/fixtures/dumb-project ${GIT_WORKTREE}/.deploy
pushd ${GIT_WORKTREE}
git add -f .deploy
popd
git commit -m import

cat > ${DESTDIR}/etc/salt/grains <<EOF
project:
$(base_grains)
  setups:
   dumb:
     git: ${GIT_DIR}
     version: master
     grains_from_grains:
       dumbproject: dumbproject
dumbproject:
  destdir: ${DESTDIR}
EOF

salt-call_ saltutil.clear_cache
salt-call_ saltutil.refresh_pillar
salt-call_ saltutil.sync_all
salt-call_ state.sls project
salt-call_ project.call dumb install

test -e ${DESTDIR}/dumb-installed
