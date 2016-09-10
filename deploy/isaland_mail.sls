{% set folder = '/home/node/isaland_mail' %}
{% set app = folder + '/index.js' %}
{% set user = 'node' %}
{% set run = 'index.js' %}
{% set name = 'isaland_mail' %}
{% set log = '/var/log/node/salt_node.forever.log' %}
{% set log_out = '/var/log/node/' + name + '.out.log' %}
{% set log_err = '/var/log/node/' + name + '.err.log' %}

project:
  git.latest:
    - name: https://github.com/nfp-projects/isaland_mail.git
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
    - source: salt://deploy/isaland_mail_config.json
    - mode: 600
    - user: {{ user }}
    - group: {{ user }}
    - template: jinja
    - require:
      - git: project

startup:
  cmd.run:
    - cwd: {{ folder }}
    - name: forever-service install {{ name }} -r {{ user }} --start -s {{ run }} -f " -o {{ log_out }} -e {{ log_err }}"
    - require:
      - git: project
      - npm: npm
      - file: config
    - unless: runuser -l {{ user }} -c 'forever list' | grep {{ name }}

service:
  cmd.run:
    - name: forever restart {{ name }}
    - user: {{ user }}
    - require:
      - git: project
      - npm: npm
      - file: config
    - onchanges:
      - git: project
      - npm: npm
      - file: config
    - onlyif: forever list | grep {{ name }}

