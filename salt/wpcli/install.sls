{%- from "wordpresser/wpcli/map.jinja" import wpcli %}

install_wp:
  cmd.script:
    - source: salt://wordpresser/wpcli/files/install-wpcli.sh
    - cwd: {{ wpcli.docroot }}
    - user: root
