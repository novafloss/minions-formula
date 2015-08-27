==================================
 :term:`Project <project>` format
==================================

A project deployment code is a directory containing salt files. Projects
provides states, pillars and named states top.sls. You can see it as a formula
tighted with pillars.

Here is the tree of sample deployment project:

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

Is a regular formula directory, containing :term:`named tops <named top>`. tops
includes state files. In the sample, ``install.sls`` is a named top
implementing the ``install`` deployment command.
