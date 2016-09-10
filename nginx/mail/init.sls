# State file for nfp.is site.

/etc/nginx/conf.d/mail.jokula.is.conf:
  file.managed:
    - source: salt://nginx/mail/mail.jokula.is.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/nginx/mail.jokula.is.key:
  file.managed:
    - source: salt://certs/mail.jokula.is.key
    - mode: 600
    - user: nginx
    - group: nginx

/etc/nginx/mail.jokula.is.crt:
  file.managed:
    - source: salt://certs/mail.jokula.is.crt
    - mode: 600
    - user: nginx
    - group: nginx
