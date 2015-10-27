#!/bin/bash
#
# deploy a project from a local path
#

# Failfast on first failing command
set -o errexit
# Consider undefined variables as an error
set -o nounset
# Consider a command failing, evin
set -o pipefail
# Log each command executed
set -o xtrace

# setup is an optionnal function executed before the test.
setup () {
    # base_setup configure a dedicated salt-call with the formula.
    base_setup

    # ${TMP_DIR}/etc/salt is the directory where salt is configured. The shell
    # function base_grains contains base grains overrides to configure
    # minions-formula in the isolated environment.
    cat > ${TMP_DIR}/etc/salt/grains <<EOF
minions:
$(base_grains)
# Here, configure the minions formula
  setups:
   myapp:
     path: ${TOP_SRCDIR}/test/fixtures/myapp
     grains:
       myapp:
         destdir: ${DESTDIR}
EOF
}

# Custom optionnal teardown
teardown () {
    exit_code=$1

    base_teardown $@
}

# Source the base _testlib.sh script, after `setup` is defined. This script
# provides base_setup, base_grains and base_teardown functions. It ensure
# teardown is always executed at exit of script.

. test/_testlib.sh

# Execute tests commands. Not the suffixed salt-call_ function. It's just an
# alias to execute salt-call in the isolated environment.
salt-call_ state.sls minions
salt-call_ minions.sls myapp myapp.install

# asserts than test is successful.
test -e ${DESTDIR}/myapp-installed
