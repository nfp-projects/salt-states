# State file for configuring postgres databases

{% for database in pillar['postgres_dbs'] %}
postgres-database-{{ pillar['postgres_dbs'][database]['name'] }}:
  postgres_database.present:
    - name: {{ pillar['postgres_dbs'][database]['name'] }}
    - owner: {{ pillar['postgres_dbs'][database]['owner'] }}
    - runas: postgres
    - require:
      - postgres_user: postgres-user-{{ pillar['postgres_dbs'][database]['owner'] }}
{% endfor %}

