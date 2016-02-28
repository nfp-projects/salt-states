base:
  '*':
    - ssh
    - base-install
    - git
    - ad
    - minion
  'roles:master':
    - match: grain
    - nodejs
