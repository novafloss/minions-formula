import logging
import os
import subprocess

import salt.exceptions as exc


logger = logging.getLogger(__name__)


def call(project, action, test=False, *args, **kwargs):
    """
    Execute a named top on a specific project.

    The action is the name of the corresponding top, without ``.sls`` suffix.
    """

    # Compute deploy command.
    script = '/usr/local/sbin/deploy-' + project
    if not os.access(script, os.X_OK):
        raise exc.CommandNotFoundError("Unknown project "+project)

    # Calls state.top to trigger a named highstate
    args = [script, 'state.top', action + '.sls', 'test=%r' % bool(test)]
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
