base:
  '*.nfp.*':
    - minion
  '*.nfp.local':
    - git
    - base-install
    - ssh
    - ad
  'roles:service':
    - match: grain
    - firewall
    - sel
  'roles:db':
    - match: grain
    - postgres
  'roles:mail':
    - match: grain
    - postgres.install
    - nginx
    - mail
  'roles:www':
    - match: grain
    - node
  'roles:master':
    - match: grain
    - node
