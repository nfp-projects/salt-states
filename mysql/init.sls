# State file for mysql server installation

mysqld:
  pkg.installed:
    - name: {{ pillar['pkgs']['mysqld'] }}
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/my.cnf
      - pkg: {{ pillar['pkgs']['mysqld'] }}

mysql:
  pkg.installed:
    - name: {{ pillar['pkgs']['mysql'] }}

mysql-python:
  pkg.installed:
    - name: {{ pillar['pkgs']['mysql-python'] }}

/etc/my.cnf:
  file.managed:
    - source: salt://mysql/my.cnf
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/salt/minion.d/mysql.conf:
  file.managed:
    - source: salt://mysql/mysql.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root

mysql_user:
  user.present:
    - name: mysql
  group.present:
    - name: mysql
    - system: True
    - members:
      - mysql

mysql-root:
  cmd:
    - run
    - name: mysqladmin --user root password '{{ pillar['mysql']['root_pw'] }}'
    - unless:  mysql --user root --password='{{ pillar['mysql']['root_pw'] }}' --execute="SELECT 1;"
    - require:
      - service: mysqld
      - pkg: {{ pillar['pkgs']['mysql'] }}

include:
  - .users

