#Configuration for minion mine

salt-minion:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/salt/minion.d/*

/etc/salt/minion.d/mine.conf:
  file.managed:
    - source: salt://mine/mine.conf
    - mode: 644
    - user: root
    - group: root
