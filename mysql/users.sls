# State file for configuring users in mysql.

{% for user in pillar['mysql']['users'] %}
{{ pillar['mysql']['users'][user]['user'] }}:
  mysql_user.present:
    - host: 10.0.0.%
    - password: {{ pillar['mysql']['users'][user]['pass'] }}
    - connection_user: root
    - connection_pass: {{ pillar['mysql']['root_pw'] }}
    - require:
      - service: mysqld
      - pkg: {{ pillar['pkgs']['mysql-python'] }} 
{% endfor %}

