#!/bin/bash

TEST_CASE=$(basename $0)
TOP_SRCDIR=$(readlink -f $(dirname $0)/../..)
# Base directory where we store temporary file for the test case. We fall back
# to fast shared memory mount.
BASE_DIR=${BASE_DIR:=/run/shm/project-formula}
# Isolate each test case
TMP_DIR=${BASE_DIR}/${TEST_CASE}
# This is where the project will be deployed
DESTDIR=${TMP_DIR}/destdir

base_setup () {
    # Trigger testcase teardown on exit.
    trap 'teardown $?' EXIT INT QUIT TERM ABRT KILL

    # Setup an isolated standalone salt minion to execute the formula. Test
    # case should just drop specific configuration in
    # ${TMP_DIR}/etc/salt/grains. The base_grains helper generate settings for
    # using the formula in the test env.
    mkdir -p ${TMP_DIR}/etc/salt
    cat > ${TMP_DIR}/etc/salt/minion <<EOF
# This is important, /etc/salt/grains is computed after this value.
conf_file: ${TMP_DIR}/etc/salt/minion
log_level: debug
log_file: ${TMP_DIR}/log/salt
cachedir: ${TMP_DIR}/cache/salt
file_client: local
file_roots:
  base:
    - ${TOP_SRCDIR}/
id: ${TEST_CASE}
EOF

    # Basic grains. Not really useful since no projects is configured at
    # all. Should be overriden by tests.
    cat > ${TMP_DIR}/etc/salt/grains <<EOF
project:
$(base_grains)
EOF

}

# Base teardown for testcase cleaning.
base_teardown () {
    exit_code=$1
    # Put env var BREAKPOINT to non-nil and testcase will wait for ENTER before
    # cleaning the test env. e.g. BREAKPOINT=1 make test. BREAKPOINT is honored
    # only when test is failing.
    if [ "$exit_code" != "0" -a -n "${BREAKPOINT-}" ] ; then
        read
    fi

    rm -f /usr/local/sbin/deploy-*
    rm -rf --one-file-system ${TMP_DIR}

    # fancy explicit output
    set +x
    case $exit_code in
	0)  res=OK ;;
	*)  res=FAIL ;;
    esac
    echo >&2
    echo "${TEST_CASE}: $res" >&2
    echo >&2
}

# Preconfigured salt-call for test own salt setup.
salt-call_ () {
    salt-call --config-dir ${TMP_DIR}/etc/salt --retcode-passthrough $@
}

# Base grains to isolate project-formula
base_grains () {
    cat <<EOF
  sources_dir: ${DESTDIR}/src
  config_dir: ${DESTDIR}/etc/projects
  log_dir: ${DESTDIR}/log
  user: $(id -un)
  group: $(id -gn)
EOF
}

# Provide a default setup for test cases.
if ! type -t setup | grep -q function ; then
    setup () {
        base_setup
    }
fi

# Provide a default teardown.
if ! type -t teardown | grep -q function ; then
    teardown () {
        base_teardown $@
    }
fi

# Automatically trigger setup phase. teardown is automatically called with
# trap.
setup
