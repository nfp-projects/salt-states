docker_repo:
  file.managed:
    - source: salt://docker/docker-ce.repo
    - name: /etc/yum.repos.d/docker-ce.repo
    - user: root
    - group: root
    - mode: 644

docker:
  pkg.installed:
    - name: docker-ce
    - require:
      - file: docker_repo
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - pkg: docker-ce

python-setuptools:
  pkg.installed: []

pip-install:
  cmd.run:
    - name: easy_install pip
    - require:
      - pkg: python-setuptools

docker-py:
  cmd.run:
    - name: pip install docker-py>=1.4.0 # installs 1.8.1 by default
    - reload_modules: True
    - require:
      - cmd: pip-install

