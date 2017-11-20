/etc/salt/minion.d/swarm.conf:
  file.managed:
    - source: salt://docker/swarm.conf
    - require:
      - pkg: docker-engine
