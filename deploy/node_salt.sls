{% set app = '/home/node/node_salt/index.js' %}
{% set run = 'index.js' %}
{% set name = 'node_salt' %}
{% set log = '/var/log/node/salt_node.forever.log' %}
{% set log_out = '/var/log/node/salt_node.out.log' %}
{% set log_err = '/var/log/node/salt_node.err.log' %}

project:
  git.latest:
    - name: https://github.com/nfp-projects/node_salt.git
    - user: node
    - rev: master
    - target: /home/node/node_salt
    - force: True
    - force_checkout: True
    - force_reset: True

npm:
  npm.bootstrap:
    - name: /home/node/node_salt
    - user: node
    - onchanges:
      - git: project
    - require:
      - git: project

config:
  file.managed:
    - name: /home/node/node_salt/config/config.json
    - source: salt://deploy/node_salt_config.json
    - mode: 600
    - user: node
    - group: node
    - template: jinja
    - require:
      - git: project

startup:
  cmd.run:
    - cwd: /home/node/node_salt
    - name: forever-service install {{ name }} -r node --start -s {{ run }} -f " -o {{ log_out }} -e {{ log_err }}"
    - require:
      - git: project
      - npm: npm
      - file: config
    - unless: runuser -l node -c 'forever list' | grep {{ name }}

service:
  cmd.run:
    - cwd: /home/node
    - name: forever restart {{ name }}
    - user: node
    - require:
      - git: project
      - npm: npm
      - file: config
    - onchanges:
      - git: project
      - npm: npm
      - file: config
    - onlyif: forever list | grep {{ name }}


