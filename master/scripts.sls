
master_scripts:
  git.latest:
    - name: git@github.com:nfp-projects/master-scripts.git
    - rev: master
    - target: /root/master-scripts
    - identity: "/root/.ssh/github_id_rsa"
    - force: True
    - force_checkout: True
    - force_reset: True

