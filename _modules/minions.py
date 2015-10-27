import logging
import os
import subprocess

import salt.exceptions as exc


logger = logging.getLogger(__name__)


def sls(minion, mods, test=False, **kwargs):
    """
    Execute sls on a specific minion.
    """

    kwargs.setdefault('saltenv', __opts__['environment'] or 'base')  # noqa
    return module(minion, 'state.sls', mods=mods, test=test, **kwargs)


def module(minion, name, *args, **kwargs):
    """
    Execute an arbitrary salt module on dev minion.
    """

    script = '/usr/local/sbin/minion-' + minion
    if not os.access(script, os.X_OK):
        raise exc.CommandNotFoundError("Unknown minion " + minion)

    args = [script, name] + list(args)
    for k, v in kwargs.items():
        if k.startswith('__'):
            continue
        args.append('%s=%s' % (k, v))

    logger.debug("Calling %r", args)
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
