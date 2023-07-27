#!/bin/bash

export PATH="$PATH:/opt/homebrew/bin"

if ! swiftformat --lint --config .swiftformat.yml . > /dev/null 2>&1
then
  echo "pre-commit: Commit aborted due to SwiftFormat warnings. Please check the automatically
generated fixes and try again"
  swiftformat --config .swiftformat.yml . > /dev/null 2>&1
  exit 1
fi