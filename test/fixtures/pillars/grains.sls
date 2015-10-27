minions: {{ salt['grains.get']('minions', {})|yaml }}
