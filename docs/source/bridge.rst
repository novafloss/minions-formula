################################################
 Bridging pillar from salt-master to app minion
################################################

Ops can inject pillar into app minion from the overlord. This is called the
bridge. Each minion setup has a ``pillars`` key. These pillars are rendered as
YAML in a pillar sls named ``master_pillars``.

.. code-block:: yaml

   minions:
     myapp:
       git: git@github.com:mycompany/myapp
       pillars:
         myapp:
           database_dsn: postgres://username:password@host/database

In the minion, you can include these pillars with ``top.sls``:

.. code-block:: yaml

   {{ env }}:
      '*':
        - master_pillars

The structure of these pillars is a contract between dev and ops.
