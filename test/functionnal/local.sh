#!/bin/bash
#
# deploy a project from a local path
#

set -eux

TOP_SRCDIR=$(readlink -f $(dirname $0)/../..)
cd ${TOP_SRCDIR}

function setup {
    base_setup

    cat > ${TMP_DIR}/etc/salt/grains <<EOF
project:
$(base_grains)
  setups:
   dumb:
     path: ${TOP_SRCDIR}/test/fixtures/dumb-project
     grains_from_grains:
       dumbproject: dumbproject
dumbproject:
  destdir: ${DESTDIR}
EOF

    salt-call_ saltutil.refresh_pillar
    salt-call_ saltutil.sync_all
}

. test/_testlib.sh

salt-call_ state.sls project
salt-call_ project.call dumb install

test -e ${DESTDIR}/dumb-installed
