# Inject grains into pillar. Tests just play with grains.
minions:
  {{ salt['grains.get']('minions', {})|yaml(False)|indent(2) }}
