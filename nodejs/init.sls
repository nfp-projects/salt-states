nodejs:
  pkg.installed:
    - name: {{ pillar['pkgs']['node'] }}

npm:
  pkg.installed:
    - name: {{ pillar['pkgs']['npm'] }}
