=========
 Purpose
=========

With the devops movements, you want to open the plateform to developers so they
can push their code and settings up to the production environment. But as an
admin sys, you don't want to let developers manage your
salt-master. ``minions-formula`` helps you split deployment process to let devs
manage as much as possible.

In the following schema is summarized the architecture of minions with
``minions-formula``. The salt-master configure ``minions-formula`` to point to
dev's projects. Inside the minion, each project has it's own standalone salt
minion with project's states, pillars and external formulas and additionnal
grains pushed from salt-master.

.. image:: architecture.*
   :alt: Architecture
   :width: 90%
   :align: center

Use cases
=========

- Dev team maintain project and project formula in same git repository. The
  deployment tool ensure it does not mix different versions of code and
  deployment code.

- Ops team deploy two versions of the same product on different minions with
  the same salt-master. This can be useful to implements blue/green deployment
  to achieve ZDD.

- Ops team defines global plateform settings, each project can reuse them to
  provision their own project. e.g. database server, queue server,
