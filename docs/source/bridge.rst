################################################
 Bridging pillar from salt-master to app minion
################################################

Ops can inject pillar into app minion from the overlord. This is called the
bridge.

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
