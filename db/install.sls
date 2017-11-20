postgres-repo:
  pkg.installed:
    - unless: test -f /etc/yum.repos.d/pgdg-10-centos.repo
    - sources:
      - pgdg-centos95: {{ salt['pillar.get']('pkgs:postgres:repo') }}

postgres-client:
  pkg.installed:
    - name: {{ salt['pillar.get']('pkgs:postgres:client') }}

postgres-devel:
  pkg.installed:
    - name: {{ salt['pillar.get']('pkgs:postgres:devel') }}

