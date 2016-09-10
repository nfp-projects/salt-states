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

/home/node/.ssh:
  file.directory:
    - user: node
    - group: node
    - mode: 600
    - makedirs: True

{% for file in ['config','github_id_rsa','github_id_rsa.pub'] %}

/home/node/.ssh/{{ file }}:
  file.managed:
    - source: salt://ssh/{{ file }}
    - mode: {{ '600' if file == 'github_id_rsa' else '644' }}
    - user: node
    - group: node
    - require:
      - file: /home/node/.ssh

{% endfor %}

node_group:
  group.present:
    - name: node
    - system: True
    - members:
      - node

/var/log/node:
  file.directory:
    - user: node
    - group: node
    - mode: 755

