{%- from "wordpresser/php/map.jinja" import php %}

install_php:
  pkg.installed:
    - names: {{ php.pkgs }}

php5-fpm-service:
  service.running:
    - name: {{ php.service }}
    - enable: True
    - watch:
      - pkg: {{ php.service }}
    - require:
      - pkg: {{ php.service }}

#nginx-restart:
#  cmd.run:
#    - name: systemctl restart nginx

copy_info_file:
  file.managed:
    - name: /usr/share/nginx/html/info.php
    - source: salt://wordpresser/php/files/info.php
    - makedirs: True

php.ini-conf:
  file.replace:
    - name: /etc/php5/fpm/php.ini
    - pattern: ";cgi.fix_pathinfo=1"
    - repl: "cgi.fix_pathinfo=0"

www.conf-listen.mode:
  file.replace:
    - name: /etc/php5/fpm/pool.d/www.conf
    - pattern: ";listen.mode = 0660"
    - repl: "listen.mode = 0660"

add-nginx-to-wwwdata:
  group.present:
    - name: www-data
    - addusers:
      - nginx

copy_default_conf:
  file.managed:
    - name: /etc/nginx/conf.d/default.conf
    - source: salt://wordpresser/php/files/default.conf
    - backup: minion


php5-fpm-restart:
  cmd.run:
    - name: systemctl restart php5-fpm

nginx-restart:
  cmd.run:
    - name: systemctl restart nginx
