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
