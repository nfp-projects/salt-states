# State file for api project

include:
  - git
  - nodejs.service

nfp_api:
  git.latest:
    - name: https://github.com/nfp-projects/nfp_api.git
    - user: node
    - rev: master
    - target: /home/node/nfp_api
    - force: True
    - force_checkout: True
    - force_reset: True
    - require:
      - pkg: git

nfp_api_npm:
  cmd.run:
    - cwd: /home/node/nfp_api
    - user: node
    - name: npm install
    - onchanges:
      - git: nfp_api
    - require:
      - git: nfp_api

nfp_api_service:
  cmd.run:
    - cwd: /home/node
    - name: pm2 startOrReload api.json && pm2 save
    - user: node
    - watch:
      - git: nfp_api
      - file: /home/node/api.json
 
/home/node/api.json:
  file.managed:
    - source: salt://nodejs/api/process.json
    - mode: 600
    - user: node
    - group: node   

/home/node/nfp_api/config/config.json:
  file.managed:
    - source: salt://nodejs/api/config.json
    - mode: 600
    - user: node
    - group: node
    - template: jinja


/var/log/nfp_api:
  file.directory:
    - user: node
    - group: node
    - mode: 755

