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
    - db
  'roles:www':
    - match: grain
  'roles:master':
    - match: grain
  'roles:docker':
    - match: grain
    - docker
  'roles:lb':
    - match: grain
    - lb
