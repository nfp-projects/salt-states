# Salt state to manage host file

/etc/hosts:
  file.managed:
    - source: salt://hosts/hosts
    - mode: 644
    - user: root
    - group: root
    - template: jinja
