{%- from "wordpresser/mysql/map.jinja" import mysql %}

install_mysql:
  pkg.installed:
    - names: {{ mysql.pkgs }}

reload-mysql:
  service.running:
    - name: {{ mysql.service }}
    - enable: True
    - reload: True
