policycoreutils-python:
  pkg.installed

policycoreutils:
  pkg.installed

selinux_mode:
  selinux.mode:
    - name: permissive
    - require:
      - pkg: policycoreutils
      - pkg: policycoreutils-python

/etc/selinux/config:
  file.managed:
    - source: salt://sel/config
    - mode: 644
    - user: root
    - group: root
