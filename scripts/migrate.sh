#!/bin/bash

source /scripts/env.sh

for pkg in /hab/cache/artifacts/core*.hart; do
  hab pkg upload --url http://localhost:9636/v1/depot --auth "$HAB_AUTH_TOKEN" "$pkg"
done
