#!/bin/bash

LOCAL_VERSION=$(cat lib/raml_visualizer/version.rb | grep VERSION | cut -d " " -f 5 | tr -d '""')
REMOTE_VERSION=$(fury list --as=renderedtext | grep "raml_visualizer" | cut -d " " -f 2 | tr -d '()')

if [ $LOCAL_VERSION = $REMOTE_VERSION ]; then
  echo "Version ${LOCAL_VERSION} already exists.";
  exit 1;
fi
