def sls(name, minion, action, **kwargs):
    """
    Ensure a corresponding action has been called to minion.

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
        out = minions_sls(minion, action, test=test)
        ret['changes']['out'] = out
    except Exception, e:
        ret['comment'] = e.message
        ret['result'] = False

    return ret
