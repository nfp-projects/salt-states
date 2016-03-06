base:
  '*.nfp.*':
    - ssh
    - base-install
    - git
    - minion
  '*.nfp.local':
    - ad
    - firewall
  'roles:db':
    - match: grain
    - postgres
  'roles:mail':
    - match: grain
    - postgres.install
    - mail
  'roles:master':
    - match: grain
    - nodejs
