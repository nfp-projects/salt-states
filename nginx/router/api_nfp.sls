# State file for api.nfp.is

/etc/nginx/conf.d/api.nfp.is.conf:
  file.managed:
    - source: salt://nginx/router/api.nfp.is.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root
