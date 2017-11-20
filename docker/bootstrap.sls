{% for manager in salt['saltutil.runner']('cache.grains', tgt='swarmmanager', tgt_type='nodegroup') %}

{% if loop.first %}
{% set manager_sls = 'docker.manager.first' %}
{% else %}
{% set manager_sls = 'docker.manager.join' %}
{% endif %}

bootstrap swarm manager {{ manager }}:
  salt.state:
    - sls: {{ manager_sls }}
    - tgt: {{ manager }}

update mine for {{ manager }}:
  salt.function:
    - name: mine.update
    - tgt: '*'
    - require:
      - salt: bootstrap swarm manager {{ manager }}

{% endfor %}

{% for worker in salt['saltutil.runner']('cache.grains', tgt='swarmworker', tgt_type='nodegroup') %}

bootstrap swarm worker {{ worker }}:
  salt.state:
    - sls: docker.worker.join
    - tgt: {{ worker }}

{% endfor %}
