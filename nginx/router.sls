/etc/nginx/conf.d/nfp.is.conf:
  file.managed:
    - source: salt://nginx/nfp.is.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root
