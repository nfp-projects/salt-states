base:
  '*':
    - ssh
    - edit
    - git
    - iptables
    - hosts
  'roles:router':
    - match: grain
    - nginx
    - mine
  'roles:www':
    - match: grain
    - nginx
    - mine
    - node
  'roles:db':
    - match: grain
    - mysql
    
