# Salt state for www machines.

include:
  - git
  - nginx

nfp_www_folder:
  file.directory:
    - name: /var/www/nfp_www
    - user: nginx
    - group: nginx
    - mode: 755

nfp_www:
  git.latest:
    - name: https://github.com/nfp-projects/nfp_www.git
    - user: nginx
    - rev: master
    - target: /var/www/nfp_www
    - force: True
    - force_checkout: True
    - force_reset: True
    - require:
      - pkg: git
      - file: nfp_www_folder

nfp_www_nfpm:
  cmd.run:
    - cwd: /var/www/nfp_www
    - user: nginx
    - name: npm install && npm run build
    - onchanges:
      - git: nfp_www

/etc/nginx/conf.d/beta.nfp.is.conf:
  file.managed:
    - source: salt://nginx/www/beta.nfp.is.conf
    - template: jinja
    - mode: 644
    - user: nginx
    - group: nginx

