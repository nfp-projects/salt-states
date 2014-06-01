ssh:
  pkg.installed:
    - name: {{ pillar['pkgs']['ssh'] }}

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://ssh/sshd_config
    - mode: 644
    - user: root
    - group: root

{% for file in ['config','github_id_rsa','github_id_rsa.pub'] %}

/root/.ssh/{{ file }}:
  file.managed:
    - source: salt://ssh/{{ file }}
    - mode: {{ '600' if file == 'github_id_rsa' else '644' }}
    - user: root
    - group: root

{% endfor %}
