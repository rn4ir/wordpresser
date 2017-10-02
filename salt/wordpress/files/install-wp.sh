#!/bin/bash

cd /home/{{ username }}/public_html
wp core download --allow-root --locale=en_GB
cd
