nginx_repo:
  file.managed:
    - source: salt://nginx/nginx.repo
    - name: /etc/yum.repos.d/nginx.repo
    - user: root
    - group: root
    - mode: 644

nginx:
  pkg.installed:
    - name: {{ pillar['pkgs']['nginx'] }}
    - require:
      - file: nginx_repo
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/*
      - pkg: {{ pillar['pkgs']['nginx'] }}

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/nginx.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: nginx

nginx_user:
  user.present:
    - name: nginx

nginx_group:
  group.present:
    - name: nginx
    - system: True
    - members:
      - nginx

include:
{% set roles = salt['grains.get']('roles', []) %}
{% if 'mail' in roles %}
  - .mail
{% endif %}
