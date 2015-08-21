==============
 Contributing
==============

.. image:: https://circleci.com/gh/novafloss/minions-formula.svg?style=shield
   :target: https://circleci.com/gh/novafloss/minions-formula
   :alt: CI Status

This formula is under CI. Functionnal tests can be executed locally using the
following steps.

#. Install salt
#. As root, run:

   .. code-block:: console

      # make test

Writing functionnal tests
=========================

A functionnal test of minions-formula is a schell script. Here is a template script.

.. literalinclude:: ../../test/functionnal/local.sh
   :language: sh

A minimal minion is available in ``test/fixtures/myapp``. This minion just
create a file ``/myapp-installed`` when it is executed. Use this minion to test
minions-formula is properly configured.
