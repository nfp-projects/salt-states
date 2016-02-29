{% set folder = '/root/node_salt' %}
{% set app = folder + '/index.js' %}
{% set user = 'root' %}
{% set run = 'index.js' %}
{% set name = 'node_salt' %}
{% set log = '/var/log/node/salt_node.forever.log' %}
{% set log_out = '/var/log/node/salt_node.out.log' %}
{% set log_err = '/var/log/node/salt_node.err.log' %}

project:
  git.latest:
    - name: https://github.com/nfp-projects/node_salt.git
    - user: {{ user }}
    - rev: master
    - target: {{ folder }}
    - force: True
    - force_checkout: True
    - force_reset: True

npm:
  npm.bootstrap:
    - name: {{ folder }}
    - user: {{ user }}
    - onchanges:
      - git: project
    - require:
      - git: project

config:
  file.managed:
    - name: {{ folder }}/config/config.json
    - source: salt://deploy/node_salt_config.json
    - mode: 600
    - user: {{ user }}
    - group: {{ user }}
    - template: jinja
    - require:
      - git: project

startup:
  cmd.run:
    - cwd: {{ folder }}
    - name: forever-service install {{ name }} --start -s {{ run }} -f " -o {{ log_out }} -e {{ log_err }}"
    - require:
      - git: project
      - npm: npm
      - file: config
    - unless: forever list | grep {{ name }}

service:
  cmd.run:
    - name: forever restart {{ name }}
    - require:
      - git: project
      - npm: npm
      - file: config
    - onchanges:
      - git: project
      - npm: npm
      - file: config
    - onlyif: forever list | grep {{ name }}


