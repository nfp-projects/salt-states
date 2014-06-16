# State file for nfp.is site.

/etc/nginx/conf.d/nfp.is.conf:
  file.managed:
    - source: salt://nginx/router/nfp.is.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/nginx/conf.d/nfp.is.key:
  file.managed:
    - source: salt://nginx/router/nfp.is.key
    - mode: 600
    - user: nginx
    - group: nginx
