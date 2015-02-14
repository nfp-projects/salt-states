# State file for api.nfp.is

/etc/nginx/conf.d/beta.nfp.is.conf:
  file.managed:
    - source: salt://nginx/router/beta.nfp.is.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root
