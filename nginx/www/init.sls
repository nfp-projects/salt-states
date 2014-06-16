# Salt state for www machines.

# Install relevant php packages.
{% for name in pillar['pkgs']['php'] %}
{{ name }}:
  pkg.installed:
    - name: {{ pillar['pkgs']['php'][name] }}
{% endfor %}

{{ pillar['pkgs']['php-fpm'] }}:
  pkg.installed:
    - name: {{ pillar['pkgs']['php-fpm'] }}
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/php-fpm.d/*
      - file: /etc/php.ini
      - pkg: {{ pillar['pkgs']['php-fpm'] }}
      - pkg: {{ pillar['pkgs']['php']['php-common'] }}

# Configuration for php-fpm
/etc/php-fpm.d/www.conf:
  file.managed:
    - source: salt://nginx/www/php-fpm.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root

# Configuration for php
/etc/php.ini:
  file.managed:
    - source: salt://nginx/www/php.ini
    - template: jinja
    - mode: 644
    - user: root
    - group: root

# Include all nginx site states
include:
  - .nfp
