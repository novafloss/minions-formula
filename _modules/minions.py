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

# Here is now a workaround to output multiline YAML string as literal. This is
# required to handle GPG output.
#
# >>> data = """\
# ... name: |
# ...     0
# ...     1
# ... """
# >>> print data
# name: |
#     0
#     1
#
# >>> out = yaml.dump(yaml.load(data), default_flow_style=False)
# >>> print out
# name: '0
#
#   1
#
#   '
#
# >>>


class literal_str(str):
    def __repr__(self):
        return 'literal' + super(literal_str, self).__repr__()


def literal_str_representer(dumper, data):
    return dumper.represent_scalar(u'tag:yaml.org,2002:str', data, style='|')


libyaml.add_representer(literal_str, literal_str_representer)


def annotateliterals(data):
    for k, v in data.items():
        if hasattr(v, 'items'):
            yield k, dict(annotateliterals(v))
        elif isinstance(v, str) and '\n' in v:
            yield k, literal_str(v)
        else:
            yield k, v


def yaml(data):
    logger.debug("rendering %r", data)
    data = dict(annotateliterals(data))
    logger.debug("annotated %r", data)
    data = libyaml.dump(data, default_flow_style=False)
    logger.debug("rendered as %r", data)
    return data
