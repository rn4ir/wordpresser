{% from "wordpresser/nginx/map.jinja" import nginx %}

nginx-repo-deb:
  pkgrepo.managed:
    - humanname: Official Nginx Repository - Debian
    {% if grains['os_family'] == 'Debian' %}
    - name: deb http://nginx.org/packages/debian/ jessie nginx
    - file: /etc/apt/sources.list.d/nginx.list
    - refresh_db: true
    - gpgcheck: 0
    {% elif grains['os_family'] == 'Redhat' %}
    - humanname: Official Nginx Repository - CentOS
    - mirrorlist: http://nginx.org/packages/centos/$releasever/$basearch/
    - gpgcheck: 0
    - enabled: 1
    {% endif %}
