{% from 'project/map.jinja' import project with context -%}

project_sources_dir:
  file.directory:
    - name: {{ project.sources_dir }}
    - user: {{ project.user }}
    - group: {{ project.group }}
    - mode: 0770
    - makedirs: true

project_config_dir:
  file.directory:
    - name: {{ project.config_dir }}
    - user: root
    - group: root
    - mode: 0770
    - makedirs: true

project_log_dir:
  file.directory:
    - name: {{ project.log_dir }}
    - user: root
    - group: root
    - mode: 0770
    - makedirs: true

{% for name, setup in project.setups.iteritems() -%}
{%- set src_dir = project.sources_dir + '/' + name %}
{%- set config_dir = project.config_dir + '/' + name %}
{%- set log_dir = project.log_dir + '/' + name %}

{%- if setup.get('path', None) %}
{%- set deploy_root = src_dir -%}
project_{{ name }}_symlink:
  file.symlink:
    - name: {{ src_dir }}
    - target: {{ setup.path }}
    - user: {{ project.user }}
    - group: {{ project.group }}
    - mode: 0770
    - force: true

{%- elif setup.get('git', None) %}
{%- set deploy_root = src_dir + '/.deploy' -%}
project_{{ name }}_git:
  git.latest:
    - name: {{ setup.git }}
    - rev: "{{ setup.version }}"
    - target: {{ src_dir }}
    - user: {{ project.user }}
    - submodules: True
{%- endif %}

project_{{ name }}_config_dir:
  file.directory:
    - name: {{ config_dir }}/minion.d
    - user: root
    - group: root
    - mode: 0770
    - makedirs: true

{% set setup_grains = setup.get('grains', {}) -%}

project_{{ name }}_minion_config:
  file.managed:
    - name: {{ config_dir }}/minion
    - user: root
    - group: root
    - mode: 0770
    - template: jinja
    - source: salt://project/files/minion
    - context:
        env: {{ env }}
        project: {{ project }}
        setup: {{ setup }}
        src_dir: {{ src_dir }}
        config_dir: {{ config_dir }}
        log_dir: {{ log_dir }}
        deploy_root: {{ deploy_root }}
        grains: {{ setup_grains }}

project_{{ name }}_log_dir:
  file.directory:
    - name: {{ log_dir }}
    - user: root
    - group: root
    - mode: 0770
    - makedirs: true

project_{{ name }}_deploy_script:
  file.managed:
    - name: /usr/local/sbin/deploy-{{ name }}
    - user: root
    - group: root
    - mode: 0770
    - template: jinja
    - source: salt://project/files/deploy
    - context:
        project: {{ project }}
        name: {{ name }}
        setup: {{ setup }}
        config_dir: {{ config_dir }}

{% endfor %}
