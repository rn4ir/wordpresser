{% set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set wp_pass = salt['pillar.get']('mysql:server:wp_password', salt['grains.get']('server_id')) %}

wpuser_user:
  mysql_user.present:
    - host: 'localhost'
    - connection_user: 'root'
    - connection_pass: '{{ mysql_root_pass }}'
    - connection_charset: utf8
    - name: 'wptest'
    - password: {{ wp_pass }}

wpuser_database:
  mysql_database.present:
    - name: wptest
    - host: 'localhost'
    - connection_user: 'root'
    - connection_pass: '{{ mysql_root_pass }}'
    - connection_charset: utf8

wpuser_grants:
  mysql_grants.present:
    - database: wptest.*
    - grant: ALL PRIVILEGES
    - user: wptest
    - host: 'localhost'
    - connection_user: 'root'
    - connection_pass: '{{ mysql_root_pass }}'
    - connection_charset: utf8
