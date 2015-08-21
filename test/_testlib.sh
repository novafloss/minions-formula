#!/bin/bash

TEST_CASE=$(basename $0)
TOP_SRCDIR=$(readlink -f $(dirname $0)/../..)
BASE_DIR=${BASE_DIR:=/run/shm/project-formula}
TMP_DIR=${BASE_DIR}/${TEST_CASE}
DESTDIR=${TMP_DIR}/destdir

base_setup () {
    trap 'base_teardown $?' EXIT INT QUIT TERM ABRT KILL
    mkdir -p ${DESTDIR}/etc/salt
    cat > ${DESTDIR}/etc/salt/minion <<EOF
conf_file: ${DESTDIR}/etc/salt/minion
log_level: debug
log_file: ${DESTDIR}/log/salt
cachedir: ${DESTDIR}/cache/salt
file_client: local
file_roots:
  base:
    - ${TOP_SRCDIR}/
EOF
}

base_teardown () {
    echo $@
    exit_code=$1
    if [ "$exit_code" != "0" -a -n "${BREAKPOINT-}" ] ; then
        tar -C $TMP_DIR --one-file-system -cf $(basename $0)-$(date +%H%M).tar .
        read
    fi

    rm -f /usr/local/sbin/deploy-*
    rm -rf --one-file-system ${TMP_DIR}
}

salt-call_ () {
    salt-call --config-dir ${DESTDIR}/etc/salt --retcode-passthrough $@
}

base_grains () {
    cat <<EOF
  sources_dir: ${DESTDIR}/src
  config_dir: ${DESTDIR}/etc/projects
  log_dir: ${DESTDIR}/log
  user: $(id -un)
  group: $(id -gn)
EOF
}
