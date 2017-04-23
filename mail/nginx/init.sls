# State file for nfp.is site.

include:
  - common.nginx

/etc/nginx/conf.d/mail.jokula.is.conf:
  file.managed:
    - source: salt://mail/nginx/mail.jokula.is.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - listen_in:
      - service: nginx

/etc/nginx/mail.jokula.is.key:
  file.managed:
    - source: salt://certs/mail.jokula.is.key
    - mode: 600
    - user: nginx
    - group: nginx
    - listen_in:
      - service: nginx

/etc/nginx/mail.jokula.is.crt:
  file.managed:
    - source: salt://certs/mail.jokula.is.crt
    - mode: 600
    - user: nginx
    - group: nginx
    - listen_in:
      - service: nginx

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://mail/nginx/nginx.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: nginx
    - listen_in:
      - service: nginx
