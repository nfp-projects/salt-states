{#
minion_id:
  file.managed:
    - name: /etc/salt/minion_id
    - source: salt://nfp/minion/minion_id
    - mode: 644
    - user: root
    - group: root
    - template: jinja
#}

salt-minion:
  pkg.latest:
    - refresh: True
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - pkg: salt-minion
      #      - file: minion_id
