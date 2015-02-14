# Node installation state
{% set roles = salt['grains.get']('roles', []) %}

wget:
  pkg.installed:
    - name: wget

nodejs-source:
  git.latest:
    - target: /usr/src/nodejs
    - name: https://github.com/joyent/node.git
    - rev: v0.12.0-release

nodejs-install:
  cmd.run:
    - cwd: /usr/src/nodejs
    - name: ./configure --v8-options="--harmony" && make && make install
    - unless: test -e /usr/local/bin/node
    - require:
      - git: nodejs-source

node_user:
  user.present:
    - name: node
    - home: /home/node

node_home:
  file.directory:
    - name: /home/node
    - user: node
    - group: node
    - mode: 755
    - require:
      - user: node_user
{% if 'api' in roles %}
    - require_in:
      - git: nfp_api
{% endif %}

node_group:
  group.present:
    - name: node
    - system: True
    - members:
      - node

include:
  - .service
{% if 'api' in roles %}
  - .api
{% endif %}

