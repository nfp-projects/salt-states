base:
  '*':
    - ssh
    - base-install
    - git
    - ad
    - minion
  'roles:api':
    - match: grain
    - nodejs
