def sls(name, minion, mods, **kwargs):
    """
    Ensure a corresponding state sls has been called in dev minion.

    Note that test mode is delegated to local ``state.sls`` command.
    """

    ret = {
        'name': name,
        'changes': {},
        'result': True,
        'comment': 'Nothing runned'
    }

    minions_sls = __salt__['minions.sls']  # noqa

    test = __opts__['test']  # noqa

    try:
        out = minions_sls(minion, mods, test=test)
        ret['changes']['out'] = out
    except Exception, e:
        ret['comment'] = e.message
        ret['result'] = False

    return ret


def module(name, minion, **kwargs):
    ret = {
        'name': name,
        'changes': {},
        'result': True,
        'comment': 'Nothing runned'
    }

    minions_module = __salt__['minions.module']  # noqa

    try:
        out = minions_module(minion, name, **kwargs)
        if out:
            ret['changes']['out'] = out
    except Exception, e:
        ret['comment'] = e.message
        ret['result'] = False

    return ret
