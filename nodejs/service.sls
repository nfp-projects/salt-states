# state file for installing pm2 on machine

pm2:
  cmd.run:
    - cwd: /root
    - user: root
    - name: npm install pm2 -g && pm2 startup centos -u node
    - unless: test -f /usr/local/bin/pm2
