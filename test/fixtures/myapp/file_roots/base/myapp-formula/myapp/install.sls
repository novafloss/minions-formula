{% from 'myapp/map.jinja' import myapp with context -%}

install:
  file.symlink:
    - name: {{ myapp.destdir }}/myapp-installed
    - target: /dev/null
