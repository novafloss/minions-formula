myapp: {{ salt['grains.get']('myapp', {})|yaml }}
