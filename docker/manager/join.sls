{% set join_token = salt['mine.get']('*', 'manager_token').items()[0][1] %}
{% set join_ip = salt['mine.get']('*', 'manager_ip').items()[0][1][0] %}

include:
  - docker
  - docker.mine

join cluster:
  cmd.run:
    - name: 'docker swarm join --token {{ join_token }} {{ join_ip }}:2377'
    - require:
      - pkg: docker-ce
