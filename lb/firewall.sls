eth0-config:
  file.blockreplace:
    - name: /etc/sysconfig/network-scripts/ifcfg-eth0
    - marker_start: "# Managed by SaltStack --please do not edit--"
    - marker_end: "# Managed by SaltStack --end of salt managed zone--"
    - content: |
        ZONE=external
    - show_changes: True
    - append_if_not_found: True

eth1-config:
  file.blockreplace:
    - name: /etc/sysconfig/network-scripts/ifcfg-eth1
    - marker_start: "# Managed by SaltStack --please do not edit--"
    - marker_end: "# Managed by SaltStack --end of salt managed zone--"
    - content: |
        ZONE=internal
    - show_changes: True
    - append_if_not_found: True

network:
  service:
    - name: network
    - running
    - enable: True
    - restart: True
    - watch:
      - file: eth0-config
      - file: eth1-config
  require:
      - file: eth0-config
      - file: eth1-config

firewalld:
  service:
    - name: firewalld
    - running
    - enable: True
    - restart: True
    - watch:
      - service: network
  require:
      - service: network

external:
  cmd.run:
    - name: |
        firewall-cmd --zone=external --remove-service=ssh
        firewall-cmd --zone=external --permanent --remove-service=ssh
        firewall-cmd --zone=external --add-service=http
        firewall-cmd --zone=external --permanent --add-service=http
        firewall-cmd --zone=external --add-service=https
        firewall-cmd --zone=external --permanent --add-service=https
        firewall-cmd --zone=external --remove-masquerade
        firewall-cmd --zone=external --permanent --remove-masquerade
