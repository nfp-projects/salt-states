# Salt state for postfix and dependancies
{% set files = ['main.cf','master.cf','pgsql-boxes.cf','pgsql-aliases.cf','pgsql-domains.cf'] %}

include:
  - postgres.install
  - .dovecot

wget:
  pkg.installed:
    - name: wget

dependancies:
  pkg.installed:
    - pkgs:
      - libdb
      - libdb-devel
      - gcc
      - openssl
      - openssl-devel
      - pcre
      - pcre-devel
      - openldap-devel
      - cyrus-sasl
      - cyrus-sasl-devel
      - openldap
      - dovecot
      - dovecot-pgsql

postfix-folder:
  file.directory:
    - name: /usr/src/postfix
    - mode: 755
    - user: root
    - group: root
    - makedirs: True

postfix-download:
  archive.extracted:
    - name: /usr/src/postfix/
    - source: http://cdn.postfix.johnriley.me/mirrors/postfix-release/official/postfix-3.1.0.tar.gz
    - source_hash: md5=86c0a02dca96b1d316c76033140ccb10
    - tar_options: v
    - archive_format: tar
    - if_missing: /usr/src/postfix/postfix-3.1.0
    - require:
      - file: postfix-folder

postfix-install:
  cmd.run:
    - name: |
        make makefiles CCARGS='-DHAS_PGSQL -I/usr/pgsql-9.5/include/ -fPIC -DUSE_TLS -DUSE_SSL -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -DPREFIX="/usr" -DHAS_LDAP -DLDAP_DEPRECATED=1 -DHAS_PCRE -I/usr/include/openssl -I/usr/include/sasl -I/usr/include' AUXLIBS='-L/usr/local/lib -lpq -L/usr/lib64 -L/usr/lib64/openssl -lssl -lcrypto -L/usr/lib64/sasl2 -lsasl2 -lpcre -lz -lm -lldap -llber -Wl,-rpath,/usr/lib64/openssl -pie -Wl,-z,relro' OPT='-O' DEBUG='-g'
    - cwd: /usr/src/postfix/postfix-3.1.0
    - shell: /bin/bash
    - unless: postconf -c /etc/postfix -m | grep pgsql
    - require:
      - archive: postfix-download
      - pkg: dependancies
      - pkg: postgres-client
      - pkg: postgres-devel

postfix:
  service:
    - running
    - enable: True
    - restart: True
    - require:
      - cmd: postfix-install
    - watch:
      - file: dovecot_cert
      - file: dovecot_key
{% for file in files %}
      - file: {{ file }}
{% endfor %}

{% for file in files %}
{{ file }}:
  file.managed:
    - name: /etc/postfix/{{ file }}
    - source: salt://mail/{{ file }}
    - template: jinja
    - mode: 644
    - user: root
    - group: root
{% endfor %}

