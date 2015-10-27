=========
 Purpose
=========

With the devops movements, you want to open the plateform to developers so they
can push their code and settings up to the production environment. But as an
admin sys, you don't want to let developers manage your
salt-master. ``minions-formula`` helps you split deployment process to let devs
manage as much as possible.

In the following schema is summarized the architecture of minions with
``minions-formula``. The :term:`master` configure ``minions-formula`` to point
to dev's project. Inside the target host, each project has it's own standalone
salt minion called :term:`dev minion`. Each :term:`dev minion` has it's own
states and pillars.

.. image:: architecture.*
   :alt: Architecture
   :width: 80%
   :align: center

This way you provide a simple entry point for dev team to update their app code
and settings on demand. For example, developers send an event to salt-master
that trigger the update or the execution of a state in their :term:`dev
minion`.


Use cases
=========

- Dev team maintain an app with it's states in same git repository. The
  deployment tool ensure it does not mix different versions of code and
  deployment code.

- Ops team deploy two different versions of the same app on different
  minions with the same salt-master. This can be useful to implements
  blue/green deployment to achieve ZDD.

- Ops team defines global plateform settings, each project can reuse them to
  provision their own project. e.g. database server, queue server, etc.
