{% from "wordpresser/wordpress/map.jinja" import wordpress %}
{% from "wordpresser/wp_user/map.jinja" import wpuser %}

{% set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set wp_pass = salt['pillar.get']('mysql:server:wp_password', salt['grains.get']('server_id')) %}
{% set wp_host = salt['pillar.get']('mysql:server:host', salt['grains.get']('server_id')) %}
{% set wp_adminuser = salt['pillar.get']('admin:wpapp:user', salt['grains.get']('server_id')) %}
{% set wp_adminpass = salt['pillar.get']('admin:wpapp:pass', salt['grains.get']('server_id')) %}
{% set wp_adminmail = salt['pillar.get']('admin:wpapp:mail', salt['grains.get']('server_id')) %}

install_wp:
  cmd.script:
    - cwd: /home/{{ wpuser.username }}/public_html
    - source: salt://wordpresser/wordpress/files/install-wp.sh
    - user: root
    - template: jinja
    - context:
      username: {{ wpuser.username }}

config_wp:
  cmd.run:
    - cwd: /home/{{ wpuser.username }}/public_html
    - name: 'wp core config --dbname=wptest --dbuser=wptest --dbpass={{ wp_pass }} --dbhost={{ wp_host }} --dbprefix=wp_ --allow-root'

core_wp:
  cmd.run:
    - cwd: /home/{{ wpuser.username }}/public_html
    - name: 'wp core install --url="{{ wordpress.url }}" --title="{{ wordpress.name }}" --admin_user="{{ wp_adminuser }}" --admin_password="{{ wp_adminpass }}" --admin_email="{{ wp_adminmail }}" --allow-root'

