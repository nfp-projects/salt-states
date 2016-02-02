minion_id:
  file.managed:
    - name: /etc/salt/minion_id
    - source: salt://minion/minion_id
    - mode: 644
    - user: root
    - group: root
    - template: jinja

salt-minion:
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: minion_id
