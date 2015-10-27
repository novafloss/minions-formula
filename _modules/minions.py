import logging
import os
import subprocess
import yaml as libyaml

import salt.exceptions as exc


logger = logging.getLogger(__name__)


def sls(minion, action, test=False, **kwargs):
    """
    Execute sls on a specific minion.
    """

    # Compute deploy command.
    script = '/usr/local/sbin/minion-' + minion
    if not os.access(script, os.X_OK):
        raise exc.CommandNotFoundError("Unknown minion " + minion)

    # Calls state.top to trigger a named highstate
    args = [script, 'state.sls', action, 'test=%r' % bool(test)]
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
