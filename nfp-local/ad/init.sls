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
        authconfig --disablecache --enablewinbind --enablewinbindauth --smbsecurity=ads --smbworkgroup=NFP --smbrealm={{ pillar['ad']['realm'] }} --enablewinbindusedefaultdomain --winbindtemplatehomedir={{ pillar['ad']['homedir'] }}/%U --winbindtemplateshell={{ pillar['ad']['shell'] }} --enablelocauthorize --disablekrb5 --enablemkhomedir --enablepamaccess --updateall
        net ads join nfp.local -U {{ pillar['ad_noc']['user'] }}%{{ pillar['ad_noc']['password'] }}
        net ads testjoin
    - require:
      - sls: nfp-local.base-install
      - pkg: install-base-ad
      - file: hosts
      - file: network_file
    - unless:
      - net ads testjoin

winbind:
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: krb5
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

krb5:
  file.managed:
    - name: /etc/krb5.conf
    - source: salt://nfp-local/ad/krb5.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  require:
    - cmd: ad_join

network_file:
  file.managed:
    - name: /etc/sysconfig/network
    - source: salt://nfp-local/ad/network
    - user: root
    - group: root
    - mode: 644
    - template: jinja

