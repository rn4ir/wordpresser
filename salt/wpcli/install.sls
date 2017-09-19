{%- from "wordpresser/wpcli/map.jinja" import wpcli %}

install_wpcli:
  cmd.script:
    - source: salt://wordpresser/wpcli/files/install-wpcli.sh
    - cwd: {{ wpcli.docroot }}
    - user: root
