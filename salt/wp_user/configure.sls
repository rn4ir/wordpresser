{%- from "wordpresser/wp_user/map.jinja" import wpuser %}
{%- from "wordpresser/php/map.jinja" import php %}

create-nginx-available:
  file.directory:
    - name: /etc/nginx/sites-available
    - user: root
    - group: root

create-nginx-enabled:
  file.directory:
    - name: /etc/nginx/sites-enabled
    - user: root
    - group: root

copy-nginx-conf:
  file.managed:
    - name: /etc/nginx/sites-available/{{ wpuser.domain }}.conf
    - source: salt://wordpresser/wp_user/files/templates/nginx.conf
    - template: jinja
    - context:
      domain: {{ wpuser.domain }}
      username: {{ wpuser.username }}
      sockpath: {{ wpuser.sock }}

symlink-nginx-enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ wpuser.domain }}.conf
    - target: /etc/nginx/sites-available/{{ wpuser.domain }}.conf

add-enabled-nginx-conf:
  file.line:
    - name: /etc/nginx/nginx.conf
    - content: "include /etc/nginx/sites-enabled/*.conf;"
    - mode: insert
    - backup: True
    - after: "include /etc/nginx/conf.d/*.conf;"

change-file-dir-ownership:
  file.directory:
    - name: /home/{{ wpuser.username }}
    - user: {{ wpuser.username }}
    - group: {{ wpuser.username }}
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode

change-homdir-perm:
  file.directory:
    - name: /home/{{ wpuser.username }}
    - user: {{ wpuser.username }}
    - group: {{ wpuser.username }}
    - mode: 711
  
php5_fpm_restart:
  cmd.run:
    - name: systemctl restart {{ php.service }}

nginx_restart:
  cmd.run:
    - name: systemctl restart nginx 
