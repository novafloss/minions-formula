#################
 Pushing pillars
#################

Ops can push pillar into :term:`dev minion` from the :term:`master`. This is
called the *bridge*. Each :term:`setup` has a ``pillars`` key. The bridge
copies these pillars in a sls named ``master_pillars``.

.. code-block:: yaml

   minions:
     myapp:
       pillars:
         database_dsn: postgres://username:password@host/database

In the :term:`dev minion`, you can include these pillars with ``top.sls``:

.. code-block:: yaml

   {{ env }}:
      '*':
        - master_pillars

And here is how to use it in the states:

.. code-block:: yaml

   myapp_settings:
     file.managed:
       - name: /etc/myapp.cfg
       - source: salt://myapp/files/myapp.cfg
       - template: jinja
       - context:
           database: {{ pillar.database_dsn }}

The structure of these pillars is a contract between dev and ops.
