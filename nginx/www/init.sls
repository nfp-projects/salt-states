# Salt state for www machines.

# Install relevant php packages.
{% for php in pillar['pkgs']['php'] %}
{{ php }}:
  pkg.installed:
    - name: {{ php }}
{% endfor %}

php-fpm:
  pkg.installed:
    - name: php-fpm
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/php-fpm.d/*
      - file: /etc/php.ini

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
