# State file for nfp.is site.

/etc/nginx/conf.d/nfp.is.conf:
  file.managed:
    - source: salt://nginx/www/nfp.is.conf
    - template: jinja
    - mode: 644
    - user: nginx
    - group: nginx

/var/www/nfp.is:
  file.directory:
    - user: nginx
    - group: nginx
    - mode: 755
    - makedirs: True
