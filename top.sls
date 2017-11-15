base:
  '*.nfp.*':
    - nfp
  '*.nfp.local':
    - nfp-local
  'roles:service':
    - match: grain
    - service
  'roles:db':
    - match: grain
    - postgres
  'roles:mail':
    - match: grain
    - postgres.install
    - mail
  'roles:www':
    - match: grain
  'roles:master':
    - match: grain
  'roles:lb':
    - match: grain
    - lb
