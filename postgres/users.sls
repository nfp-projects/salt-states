# State file for configuring users in mysql.

{% for user in pillar['postgres_users'] %}
postgres-user-{{ pillar['postgres_users'][user]['user'] }}:
  postgres_user.present:
    - name: {{ pillar['postgres_users'][user]['user'] }}
    - createdb: False
    - password: {{ pillar['postgres_users'][user]['pass'] }}
    - runas: postgres
    - require:
      - service: {{ salt['pillar.get']('pkgs:postgres:service') }}
      - pkg: {{ salt['pillar.get']('pkgs:postgres:server') }}
{% endfor %}


