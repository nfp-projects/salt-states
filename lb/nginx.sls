include:
  - common.nginx
  - common.git

config_files:
  git.latest:
    - name: git@github.com:nfp-projects/nginx.git
    - rev: master
    - target: /etc/nginx/config
    - identity: "/root/.ssh/github_id_rsa"
    - force_fetch: True
    - force_checkout: True
    - force_reset: True
  require:
    - sls: common.nginx
    - sls: common.git
    - file: /etc/nginx/certs

/etc/nginx/nginx.conf:
  file.copy:
    - source: /etc/nginx/config/nginx.conf
    - force: true
    - onchanges:
      - git: config_files
    - watch_in:
      - service: nginx

/etc/nginx/certs:
  file.recurse:
    - source: salt://lb/certs
    - include_empty: True
    - require_in:
      - service: nginx
    - watch_in:
      - service: nginx

check_config:
  cmd.run:
    - name: nginx -t
    - watch:
      - file: /etc/nginx/nginx.conf
    - require_in:
      - service: nginx

