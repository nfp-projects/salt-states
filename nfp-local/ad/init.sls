include:
  - nfp-local.base-install

hosts:
  file.managed:
    - name: /etc/hosts
    - source: salt://nfp-local/ad/hosts
    - mode: 644
    - user: root
    - group: root
    - template: jinja

install-base-ad:
  pkg.installed:
    - pkgs:
{% for package in pillar['pkgs']['ad'] %}
      - {{ package }}
{% endfor %}

ad_join:
  cmd.run:
    - name: |
        echo {{ pillar['ad_noc']['password'] }}| realm join {{ pillar['ad']['domain'] }} -U {{ pillar['ad_noc']['user'] }}
        id noc@nfp.local
    - require:
      - sls: nfp-local.base-install
      - pkg: install-base-ad
      - file: hosts
#      - file: network_file
    - unless:
      - id noc@nfp.local

sssd:
  service:
    - running
    - enable: True
    - watch:
      - file: sssd_conf
  require:
    - sls: nfp-local.base-install

nfp_home:
  file.directory:
    - name: /home/nfp.local
    - mode: 555
    - user: root
    - group: root
    - makedirs: True
  require:
    - cmd: ad_join

oddjobd:
  service:
    - running
    - enable: True
  require:
    - cmd: ad_join

sudoers:
  file.append:
    - name: /etc/sudoers
    - text: |
{% for group in pillar['ad']['sudoers'] %}
        %{{ group }} ALL=(ALL)     ALL
{% endfor %}
  require:
    - cmd: ad_join

sssd_conf:
  file.managed:
    - name: /etc/sssd/sssd.conf
    - source: salt://nfp-local/ad/sssd.conf
    - user: root
    - group: root
    - mode: 600
    - template: jinja
  require:
    - cmd: ad_join

{#
network_file:
  file.managed:
    - name: /etc/sysconfig/network
    - source: salt://nfp-local/ad/network
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    #}

