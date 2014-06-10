#iptables config
/etc/sysconfig/test:
  file.managed:
    - source: salt://iptables/firewall
    - user: root
    - group: root
    - mode: 644
    - template: jinja