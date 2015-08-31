def called(name, project, action, **kwargs):
    """
    Ensure a corresponding action has been called to a project.

    Note that test mode is delegated to local ``state.sls`` command.
    """

    ret = {
        'name': name,
        'changes': {},
        'result': True,
        'comment': 'Nothing runned'
    }

    project_call = __salt__['project.call']  # noqa

    test = __opts__['test']  # noqa

    try:
        out = project_call(project, action, test=test)
        ret['changes']['out'] = out
    except Exception, e:
        ret['comment'] = e.message
        ret['result'] = False

    return ret
