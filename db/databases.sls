# State file for configuring postgres databases and users

{% for database in pillar['postgres_dbs'] %}
postgres-database-{{ pillar['postgres_dbs'][database]['name'] }}:
  postgres_database.present:
    - name: {{ pillar['postgres_dbs'][database]['name'] }}
    - owner: {{ pillar['postgres_dbs'][database]['owner'] }}
    - require:
      - postgres_user: postgres-user-{{ pillar['postgres_dbs'][database]['owner'] }}
{% endfor %}

{% for user in pillar['postgres_users'] %}
postgres-user-{{ pillar['postgres_users'][user]['user'] }}:
  postgres_user.present:
    - name: {{ pillar['postgres_users'][user]['user'] }}
    - createdb: False
    - password: {{ pillar['postgres_users'][user]['pass'] }}
    - require:
      - service: postgres-server
      - pkg: postgres-server
{% endfor %}
