nginx_repo:
  file.managed:
    - source: salt://common/nginx/nginx.repo
    - name: /etc/yum.repos.d/nginx.repo
    - user: root
    - group: root
    - mode: 644

nginx:
  pkg.installed:
    - name: {{ pillar['pkgs']['nginx'] }}
    - fromrepo: nginx-stable
    - require:
      - file: nginx_repo
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - pkg: {{ pillar['pkgs']['nginx'] }}

nginx_user:
  user.present:
    - name: nginx

nginx_group:
  group.present:
    - name: nginx
    - system: True
    - members:
      - nginx
