=================================
 :term:`Minions <minion>` format
=================================

A minion is defined by a directory containing salt files. Minions provides
states and pillars. You can see it as a set of formulas tighted with pillars.

Here is the tree of sample minion:

::

  .
  ├── file_roots
  │   └── base
  │       └── dumbproject-formula
  │           └── dumbproject
  │               ├── install.sls
  │               └── map.jinja
  └── pillars
      └── base
          ├── settings.sls
          └── top.sls


``pillars`` directory
=====================

Contains a directory for each targetted environement (e.g, dev, qa, prod). The
final pillar_roots will contains::

  pillar_roots:
    base:
      - /path/to/deploy/code/pillars/base

``file_roots`` directory
========================

It's just file tree matching the ``file_roots`` salt config option. The final
``file_roots`` will contains::

  file_roots:
    base:
      - /path/to/minion/file_roots/base/dumbproject-formula

You can call sls from app minion with ``minion.sls dumbproject.install``.

Deploying from git repository
=============================

You can fetch a minion configuration from a git repository. Put the minion
directory in ``.minion`` in the root of your project and ask minions-formula to
clone the project repository:

.. code-block:: yaml

   minions:
     setups:
       myapp:
         git: git@github.com:mycompany/myapp.git
