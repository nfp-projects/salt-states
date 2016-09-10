{% set files = ['10-auth.conf','10-master.conf','10-mail.conf','15-lda.conf','20-imap.conf'] %}

mail_user:
  user.present:
    - name: vmail
    - uid: 5000
    - gid: 5000
    - home: /home/mailboxes
  require:
    - pkg: dependancies

mail_home:
  file.directory:
    - name: /home/mailboxes
    - user: vmail
    - group: vmail
    - mode: 700
    - require:
      - user: mail_user

dovecot:
  service:
    - running
    - enable: True
    - restart: True
    - watch:
      - file: dovecot.conf
      - file: dovecot-sql.conf
      - file: dovecot_cert
      - file: dovecot_key
{% for file in files %}
      - file: {{ file }}
{% endfor %}

dovecot_cert:
  file.managed:
    - name: /etc/pki/dovecot/certs/dovecot.pem
    - source: salt://certs/mail.jokula.is.crt
    - mode: 644
    - user: root
    - group: root

dovecot_key:
  file.managed:
    - name: /etc/pki/dovecot/private/dovecot.pem
    - source: salt://certs/mail.jokula.is.key
    - mode: 644
    - user: root
    - group: root

dovecot.conf:
  file.managed:
    - name: /etc/dovecot/dovecot.conf
    - source: salt://mail/dovecot.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root

dovecot-sql.conf:
  file.managed:
    - name: /etc/dovecot/dovecot-sql.conf
    - source: salt://mail/dovecot-sql.conf
    - template: jinja
    - mode: 600
    - user: root
    - group: root

{% for file in files %}
{{ file }}:
  file.managed:
    - name: /etc/dovecot/conf.d/{{ file }}
    - source: salt://mail/{{ file }}
    - template: jinja
    - mode: 644
    - user: root
    - group: root
{% endfor %}

