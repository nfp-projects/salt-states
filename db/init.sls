# State file for postgres server installationf

include:
  - .install
  - .databases

postgres-server:
  pkg.installed:
    - name: {{ salt['pillar.get']('pkgs:postgres:server') }}
  service:
    - name: {{ salt['pillar.get']('pkgs:postgres:service') }}
    - running
    - enable: True
    - restart: True
    - watch:
      - pkg: postgres-server
      - file: postgres-pg_hba
      - file: postgres-config

postgres-initdb:
  cmd.run:
    - cwd: /
    - user: root
    - name: /usr/pgsql-9.5/bin/postgresql95-setup initdb
    - unless: test -f {{ salt['pillar.get']('pkgs:postgres:config') }}
    - require_in:
      - service: postgres-server
    - env:
      LC_ALL: C.UTF-8

postgres-path:
  file.append:
    - name: /etc/bashrc
    - text: PATH=/usr/pgsql-9.5/bin/:$PATH

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

