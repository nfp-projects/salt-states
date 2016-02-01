{% for package in pillar['pkgs']['base'] %}
install-{{ package }}:
  pkg.installed:
    - name: {{ package }}
{% endfor %}
