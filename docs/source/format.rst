=====================================
 :term:`Minions <dev minion>` format
=====================================

A :term:`dev minion` is defined by a directory containing salt files. A
:term:`dev minion` provides states and pillars. You can see it as a set of
formulas tighted with pillars.

Here is the tree of sample :term:`dev minion`:

::

  .
  ├── file_roots
  │   └── base
  │       └── myapp-formula
  │           └── myapp
  │               ├── install.sls
  │               └── map.jinja
  └── pillars
      └── base
          ├── settings.sls
          └── top.sls


``pillars`` directory
=====================

Contains a directory for each targetted environment (e.g, dev, qa, prod). The
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
      - /path/to/myapp-minion/file_roots/base/myapp-formula

You can call sls from app minion with ``minion.sls myapp.install``.

.. notice::

   As a special case, the directories in ``file_roots/base/`` are appended to
   **all** environments file_roots. This allow te define common formulas once
   in ``file_roots/base`` and reuse them in all environments.

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
