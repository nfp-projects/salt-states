{% set ip_addr = salt['network.interfaces']()['eth0']['inet'][0]['address']  %}

include:
  - docker
  - docker.mine

init new swarm cluster:
  cmd.run:
    - name: 'docker swarm init --advertise-addr {{ ip_addr }}'
    - require:
      - pkg: docker-engine
