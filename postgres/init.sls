# State file for postgres server installation

postgres-repo:
  pkg.installed:
    - unless: test -f /etc/yum.repos.d/pgdg-94-centos.repo
    - sources:
      - pgdg-centos94: {{ salt['pillar.get']('pkgs:postgres:repo') }}


postgres-server:
  pkg.installed:
    - name: {{ salt['pillar.get']('pkgs:postgres:server') }}
  service:
    - name: {{ salt['pillar.get']('pkgs:postgres:service') }}
    - running
    - enable: True
    - restart: True
    - watch:
      - pkg: {{ salt['pillar.get']('pkgs:postgres:server') }}
      - file: {{ salt['pillar.get']('pkgs:postgres:hba') }}
      - file: {{ salt['pillar.get']('pkgs:postgres:config') }}
#      - file: /etc/my.cnf

postgres-client:
  pkg.installed:
    - name: {{ salt['pillar.get']('pkgs:postgres:client') }}

postgres-initdb:
  cmd.run:
    - cwd: /
    - user: root
    - name: service {{ salt['pillar.get']('pkgs:postgres:service') }} initdb
    - unless: test -f {{ salt['pillar.get']('pkgs:postgres:config') }}
    - require_in:
      - service: {{ salt['pillar.get']('pkgs:postgres:service') }}
    - env:
      LC_ALL: C.UTF-8

postgres-config:
  file.blockreplace:
    - name: {{ salt['pillar.get']('pkgs:postgres:config') }}
    - marker_start: "# Managed by SaltStack --please do not edit--"
    - marker_end: "# Managed by SaltStack --end of salt managed zone--"
    - content: |
         listen_addresses = '*'
    - show_changes: True
    - append_if_not_found: True

postgres-pg_hba:
  file.managed:
    - name: {{ salt['pillar.get']('pkgs:postgres:hba') }}
    - source: salt://postgres/pg_hba.conf
    - template: jinja
    - mode: 600
    - user: postgres
    - group: postgres


include:
  - .users
  - .databases

