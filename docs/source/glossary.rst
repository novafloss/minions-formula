==========
 Glossary
==========

.. glossary::
   :sorted:

   master
     The salt-master, configured with minion-formula and managing other minion
     in the plateforme.

   ops minion
     The regular salt-minion, bound to the :term:`master`.

   dev minion

     The masterless salt minion. This minion is isolated from :term:`ops
     minion`, deployed by minion-formula.

   setup
      A set of parameters to deploy a :term:`dev minion` for an app.
