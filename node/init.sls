{% set roles = salt['grains.get']('roles', []) %}

nodejs-dep:
  cmd.run:
    - name: curl --silent --location https://rpm.nodesource.com/setup_5.x | bash -
    - unless: test -e /etc/yum.repos.d/nodesource-el.repo

nodejs-install:
  pkg.latest:
    - name: {{ pillar['pkgs']['nodejs'] }}
    - require:
      - cmd: nodejs-dep

forever:
  npm.installed:
    - require:
      - pkg: nodejs-install

forever-service:
  npm.installed:
    - require:
      - pkg: nodejs-install

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

node_group:
  group.present:
    - name: node
    - system: True
    - members:
      - node
