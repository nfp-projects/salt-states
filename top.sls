base:
  '*':
    - ssh
    - edit
    - git
    - iptables
    - hosts
  'roles:api':
    - match: grain
    - nodejs
    - nginx
    - mine
  'roles:router':
    - match: grain
    - nginx
    - mine
  'roles:www':
    - match: grain
    - nginx
    - mine
  'roles:db':
    - match: grain
    - mysql
    - postgres
    - mine
    
