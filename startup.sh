#!/bin/bash

set -euo pipefail

export DJANGO_READ_DOT_ENV_FILE=1
export DJANGO_DOT_ENV_FILE=.env

echo "==> $(date +%H:%M:%S) ==> Collecting static files..."
python src/manage.py collectstatic --noinput

echo "==> $(date +%H:%M:%S) ==> Migrating Django models..."
python src/manage.py migrate --noinput

echo "==> $(date +%H:%M:%S) ==> Running Gunicorn..."
exec gunicorn -c src/config/gunicorn.py config.wsgi -b 0.0.0.0:8000 --chdir src/ -D