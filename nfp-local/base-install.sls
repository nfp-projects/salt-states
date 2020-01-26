install-base:
  pkg.installed:
    - pkgs:
{% for package in pillar['pkgs']['base'] %}
      - {{ package }}
{% endfor %}
