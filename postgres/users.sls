# State file for configuring users in mysql.

{% for user in pillar['postgres']['users'] %}
postgres-user-{{ pillar['postgres']['users'][user]['user'] }}:
  postgres_user.present:
    - name: {{ pillar['postgres']['users'][user]['user'] }}
    - createdb: False
    - password: {{ pillar['postgres']['users'][user]['pass'] }}
    - runas: postgres
    - require:
      - service: {{ salt['pillar.get']('pkgs:postgres:service') }}
      - pkg: {{ salt['pillar.get']('pkgs:postgres:server') }}
{% endfor %}


