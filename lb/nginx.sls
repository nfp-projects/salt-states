include:
  - common.nginx

config_files:
  git.latest:
    - name: git@github.com:nfp-projects/nginx.git
    - rev: master
    - target: /etc/nginx/config
    - identity: "/root/.ssh/github_id_rsa"
    - force: True
    - force_checkout: True
    - force_reset: True
  require:
    - sls: common.nginx

/etc/nginx/nginx.conf:
  file.copy:
    - source: /etc/nginx/config/nginx.conf
    - force: true
    - onchanges:
      - git: config_files

check_config:
  cmd.run:
    - name: nginx -t
    - watch:
      - file: /etc/nginx/nginx.conf
    - watch_in:
      - service: nginx

