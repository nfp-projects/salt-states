nginx:
  pkg.installed:
    - name: {{ pillar['pkgs']['nginx'] }}
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d/*

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/nginx.conf
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
