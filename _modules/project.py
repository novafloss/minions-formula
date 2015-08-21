import os
import subprocess

import salt.exceptions as exc


def call(project, action):
    script = '/usr/local/sbin/deploy-' + project
    if not os.access(script, os.X_OK):
        raise exc.CommandNotFoundError("Unknown project "+project)

    args = [script, 'state.top', action + '.sls']
    child = subprocess.Popen(
        args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    child.wait()

    out = ""
    out += child.stderr.read()
    out += "\n"
    out += child.stdout.read()

    if child.returncode != 0:
        raise exc.CommandExecutionError(out)

    return out


def merge_grains(defaults, from_grains):
    grains_get = __salt__['grains.get']  # noqa

    grains = defaults.copy()
    from_grains = from_grains.copy()
    for dest, src in from_grains.items():
        data = grains_get(src)
        if not data:
            raise exc.SaltException("Missing grains %r" % src)
        grains[dest] = data
    return grains
