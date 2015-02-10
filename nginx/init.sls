nginx:
  pkg.installed:
    - name: {{ pillar['pkgs']['nginx'] }}
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
{% if 'router' in roles %}
  - .router
{% endif %}
{% if 'www' in roles %}
  - .www
{% endif %}
