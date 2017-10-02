{%- from "wordpresser/php/map.jinja" import php %}

install_php:
  pkg.installed:
    - names: {{ php.pkgs }}

php-fpm-service:
  service.running:
    - name: {{ php.service }}
    - enable: True
    - watch:
      - pkg: {{ php.service }}
    - require:
      - pkg: {{ php.service }}

copy_info_file:
  file.managed:
    - name: /usr/share/nginx/html/info.php
    - source: salt://wordpresser/php/files/info.php
    - makedirs: True

php.ini-conf:
  file.replace:
    - name: {{ php.phpini }}
    - pattern: ";cgi.fix_pathinfo=1"
    - repl: "cgi.fix_pathinfo=0"

www.conf-listen.mode:
  file.managed:
    - name: {{ php.phpwww }}
    {% if grains['os_family'] == 'Debian' %}
    - source: salt://wordpresser/php/files/www.conf_deb
    {% elif grains['os_family'] == 'RedHat' %}
    - source: salt://wordpresser/php/files/www.conf_centos
    {% endif %}

{% if grains['os_family'] == 'Debian' %}
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
{% endif %}

{% if grains['os_family'] == 'RedHat' %}
selinux-state-temp:
  cmd.run:
    - name: setenforce 0

selinux-state-perm:
  file.replace:
    - name: /etc/selinux/config
    - pattern: "SELINUX=enforcing"
    - repl: "SELINUX=permissive"
{% endif %}

php-fpm-restart:
  cmd.run:
    - name: systemctl restart {{ php.service }}

nginx-restart:
  cmd.run:
    - name: systemctl restart nginx
