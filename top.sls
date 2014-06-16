base:
  '*':
    - ssh
    - edit
    - git
    - iptables
  'roles:router':
    - match: grain
    - nginx
    - nginx.router
    - mine
  'roles:www':
    - match: grain
    - nginx
    - nginx.www
    - mine
  'roles:db':
    - match: grain
    - mysql
    
