#!/usr/bin/env bash
set -e

###################################################################
# Script Name   : project.sh
# Description   : This program initialises a project ready for dev
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

PROJECT_DIR="$HOME"/project
PROJECT_LOG="$HOME"/.logs/.project.log
PROJECT_SECRETS="$PROJECT_DIR"/.secrets.baseline

# removes log file
touch "$PROJECT_LOG"

# creates the project folder if required
if [ ! -d "$PROJECT_DIR" ]; then
  mkdir -pv "$PROJECT_DIR" >> "$PROJECT_LOG"
else
  echo "folder '$PROJECT_LOG' exists" >> "$PROJECT_LOG"
fi

if [ ! -d .git ]; then
  git init "$PROJECT_DIR" >> "$PROJECT_LOG"
else
  echo "git already initialised" >> "$PROJECT_LOG"
fi

if [ ! -f "$PROJECT_DIR"/.pre-commit-config.yaml ]; then
  cp -v "$HOME"/.pre-commit-config.yaml "$PROJECT_DIR"/.pre-commit-config.yaml >> "$PROJECT_LOG"
else
  echo "pre-commit config exists" >> "$PROJECT_LOG"
fi

if [ ! -f "$PROJECT_SECRETS" ]; then
  detect-secrets scan "$PROJECT_DIR" > "$PROJECT_SECRETS"
else
  echo "detect secrets baseline exists" >> "$PROJECT_LOG"
fi

pre-commit install >> "$PROJECT_LOG"
