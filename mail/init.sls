# Salt state for postfix and dependancies

include:
  - postgres.install

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


postfix-download:
  archive.extracted:
    - name: /usr/src/postfix
    - source: http://cdn.postfix.johnriley.me/mirrors/postfix-release/official/postfix-3.1.0.tar.gz
    - tar_options: v
    - archive_format: tar
    - if_missing: /usr/src/postfix/postfix-3.1.0

postfix-install:
  cmd.run:
    - name: |
        make makefiles CCARGS='-DHAS_PGSQL -I/usr/pgsql-9.5/include/ -fPIC -DUSE_TLS -DUSE_SSL -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -DPREFIX="/usr" -DHAS_LDAP -DLDAP_DEPRECATED=1 -DHAS_PCRE -I/usr/include/openssl -I/usr/include/sasl -I/usr/include' AUXLIBS='-L/usr/local/lib -lpq -L/usr/lib64 -L/usr/lib64/openssl -lssl -lcrypto -L/usr/lib64/sasl2 -lsasl2 -lpcre -lz -lm -lldap -llber -Wl,-rpath,/usr/lib64/openssl -pie -Wl,-z,relro' OPT='-O' DEBUG='-g'
    - cwd: /usr/src/postfix/postfix-3.1.0
    - shell: /bin/bash
    - require:
      - archive: postfix-download
      - pkg: dependancies
      - pkg: postgres-client
      - pkg: postgres-devel
