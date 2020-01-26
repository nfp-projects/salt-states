git:
  pkg.installed:
    - name: {{ pillar['pkgs']['git'] }}

ssh:
  pkg.installed:
    - name: {{ pillar['pkgs']['ssh'] }}

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://common/git/sshd_config
    - mode: 644
    - user: root
    - group: root

/root/.ssh:
  file.directory:
    - user: root
    - group: root
    - mode: 600
    - makedirs: True

{% for file in ['config','github_id_rsa','github_id_rsa.pub'] %}

/root/.ssh/{{ file }}:
  file.managed:
    - source: salt://common/git/{{ file }}
    - mode: 600
    - user: root
    - group: root

{% endfor %}

{% set roles = salt['grains.get']('roles', []) %}
{% if 'master' in roles %}
include:
  - .public
{% endif %}
