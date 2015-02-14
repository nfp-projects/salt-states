# Salt state for www machines.

/etc/nginx/conf.d/api.nfp.is.conf:
  file.managed:
    - source: salt://nginx/api/api.nfp.is.conf
    - template: jinja
    - mode: 644
    - user: nginx
    - group: nginx

