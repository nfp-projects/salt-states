base:
  '*':
    - ssh
    - edit
    - git
    - iptables
  'role:router':
    - match: grain
    - nginx
    - nginx.router
    - mine
  'role:www':
    - match: grain
    - nginx
    - nginx.www
    - mine
