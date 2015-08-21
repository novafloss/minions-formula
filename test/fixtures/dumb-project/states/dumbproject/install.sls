{% from 'dumbproject/map.jinja' import dumbproject with context -%}

install:
  file.symlink:
    - name: {{ dumbproject.destdir }}/dumb-installed
    - target: /dev/null
