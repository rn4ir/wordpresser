open_nginx_ports:
  firewalld.present:
    - name: public
    - ports:
      - 80/tcp
      - 443/tcp
      - 22/tcp
