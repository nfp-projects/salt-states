docker_repo:
  file.managed:
    - source: salt://docker/docker.repo
    - name: /etc/yum.repos.d/docker.repo
    - user: root
    - group: root
    - mode: 644

docker:
  pkg.installed:
    - name: docker-engine
    - require:
      - file: docker_repo
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - pkg: docker-engine
