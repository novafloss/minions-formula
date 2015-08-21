#!/bin/bash

set -eux

TOP_SRCDIR=$(readlink -f $(dirname $0)/../..)
cd ${TOP_SRCDIR}

. test/_testlib.sh

base_setup

cat > ${DESTDIR}/etc/salt/grains <<EOF
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

salt-call_ saltutil.clear_cache
salt-call_ saltutil.refresh_pillar
salt-call_ saltutil.sync_all
salt-call_ state.sls project
salt-call_ project.call dumb install

test -e ${DESTDIR}/dumb-installed
