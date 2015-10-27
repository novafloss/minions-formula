{% from 'minions/map.jinja' import minions with context -%}

minions_sources_dir:
  file.directory:
    - name: {{ minions.sources_dir }}
    - user: {{ minions.user }}
    - group: {{ minions.group }}
    - mode: 0770
    - makedirs: true

minions_config_dir:
  file.directory:
    - name: {{ minions.config_dir }}
    - user: root
    - group: root
    - mode: 0770
    - makedirs: true

minions_log_dir:
  file.directory:
    - name: {{ minions.log_dir }}
    - user: root
    - group: root
    - mode: 0770
    - makedirs: true

minions_cache_dir:
  file.directory:
    - name: {{ minions.cache_dir }}
    - user: root
    - group: root
    - mode: 0770
    - makedirs: true

{% for name, setup in minions.setups.iteritems() -%}
{%- set src_dir = minions.sources_dir + '/' + name %}
{%- set config_dir = minions.config_dir + '/' + name %}
{%- set log_dir = minions.log_dir + '/' + name %}
{%- set cache_dir = minions.cache_dir + '/' + name %}

{%- if setup.get('path', None) %}
{%- set deploy_root = src_dir -%}
minions_{{ name }}_symlink:
  file.symlink:
    - name: {{ src_dir }}
    - target: {{ setup.path }}
    - user: {{ minions.user }}
    - group: {{ minions.group }}
    - mode: 0770
    - force: true

{%- elif setup.get('git', None) %}
{%- set deploy_root = src_dir + '/.minion' -%}
minions_{{ name }}_git:
  git.latest:
    - name: {{ setup.git }}
    - rev: "{{ setup.version }}"
    - target: {{ src_dir }}
    - user: {{ minions.user }}
    - submodules: True
{%- endif %}

minions_{{ name }}_config_dir:
  file.directory:
    - name: {{ config_dir }}/minion.d
    - user: root
    - group: root
    - mode: 0770
    - makedirs: true

{% set pillars_bridge = setup.get('pillars', {}) -%}
minions_{{ name }}_bridge:
  file.managed:
    - name: {{ config_dir }}/bridge/master_pillars.sls
    - makedirs: true
    - template: jinja
    - source: salt://minions/files/bridge
    - context:
        pillars: {{ pillars_bridge }}

minions_{{ name }}_minion_config:
  file.managed:
    - name: {{ config_dir }}/minion
    - user: root
    - group: root
    - mode: 0770
    - template: jinja
    - source: salt://minions/files/minion
    - context:
        env: {{ env }}
        minions: {{ minions }}
        setup: {{ setup }}
        src_dir: {{ src_dir }}
        cache_dir: {{ cache_dir }}
        config_dir: {{ config_dir }}
        log_dir: {{ log_dir }}
        deploy_root: {{ deploy_root }}

minions_{{ name }}_log_dir:
  file.directory:
    - name: {{ log_dir }}
    - user: root
    - group: root
    - mode: 0770
    - makedirs: true

{% set minion_script = '/usr/local/sbin/minion-' ~ name -%}
minions_{{ name }}_script:
  file.managed:
    - name: {{ minion_script }}
    - user: root
    - group: root
    - mode: 0770
    - template: jinja
    - source: salt://minions/files/minion-script
    - context:
        config_dir: {{ config_dir }}
        deploy_root: {{ deploy_root }}
        env: {{ env }}

{% set filerootfile = config_dir ~ '/minion.d/file_roots.conf' -%}
minions_{{ name }}_file_roots:
  cmd.run:
    - name: {{ minion_script }} find-file-roots > {{ filerootfile }}
    - unless: test -f {{ filerootfile }}

{% endfor %}
