=================================
 :term:`Minions <minion>` format
=================================

A minion is defined by a directory containing salt files. Minions provides
states and pillars. You can see it as a formula tighted with pillars.

Here is the tree of sample minion:

::

   .
   ├── pillars
   │   └── base
   │       ├── settings.sls
   │       └── top.sls
   └── states
       ├── dumbproject
       │   ├── install.sls
       │   └── map.jinja
       └── install.sls

``pillars`` directory
=====================

Contains a directory for each targetted environement (e.g, dev, qa, prod). The
final pillar_roots will contains::

  pillar_roots:
    {{ env }}:
      - /path/to/deploy/code/pillars/{{ env }}

``states`` directory
====================

Is a regular formula directory, containing :term:`actions <action>`. In the sample,
``install.sls`` implements the ``install`` action.
