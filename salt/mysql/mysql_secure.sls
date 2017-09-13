{% from "wordpresser/mysql/map.jinja" import mysql %}
{% set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

root_user:
  mysql_user.present:
    - name: 'root'
    - password: {{ mysql_root_pass }}

mysql remove anonymous users:
  mysql_user.absent:
    - name: ''
    - host: 'localhost'
    - connection_user: 'root'
    - connection_pass: '{{ mysql_root_pass }}'
    - connection_charset: utf8

mysql remove test database:
  mysql_database.absent:
    - name: test
    - host: 'localhost'
    - connection_user: 'root'
    - connection_pass: '{{ mysql_root_pass }}'
    - connection_charset: utf8

disable remote login for root:
  mysql_query.run:
    - database: 'mysql'
    - query: "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    - output: "/tmp/removehostroot.txt"
    - host: 'localhost'
    - connection_user: 'root'
    - connection_pass: '{{ mysql_root_pass }}'
    - connection_charset: utf8

mysql_restart:
  module.wait:
    - name: service.restart
    - m_name: {{ mysql.service }}
