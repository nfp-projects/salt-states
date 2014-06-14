#iptables config
iptables:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/sysconfig/iptables

/etc/sysconfig/iptables:
  file.managed:
    - source: salt://iptables/firewall
    - user: root
    - group: root
    - mode: 644
    - template: jinja
