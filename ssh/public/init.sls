/etc/ssh/sshd_config_public:
  file.managed:
    - source: salt://ssh/public/sshd_config_public
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/usr/lib/systemd/system/sshd-second.service:
  file.managed:
    - source: salt://ssh/public/sshd-second.service
    - mode: 600
    - user: root
    - group: root

/root/deploy:
  file.managed:
    - source: salt://ssh/public/deploy
    - mode: 700
    - user: root
    - group: root

/root/.ssh/authorized_keys:
  file.managed:
    - source: salt://ssh/public/authorized_keys
    - template: jinja
    - mode: 600
    - user: root
    - group: root

sshd-second:
  service:
    - running
    - enable: True
    - restart: True
    - require:
      - file: /etc/ssh/sshd_config_public
      - file: /usr/lib/systemd/system/sshd-second.service
    - watch:
      - file: /etc/ssh/sshd_config_public
