# State file for configuring postgres databases

{% for database in pillar['postgres']['databases'] %}
postgres-database-{{ database }}:
  postgres_database.present:
    - name: {{ database }}
    - owner: {{ pillar['postgres']['databases'][database]['owner'] }}
    - runas: postgres
    - require:
      - postgres_user: postgres-user-{{ pillar['postgres']['databases'][database]['owner'] }}
{% endfor %}

