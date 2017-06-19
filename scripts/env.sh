#!/bin/bash

export HAB_ORIGIN=core
export HAB_AUTH_TOKEN=YOUR_TOKEN
export HAB_DEPOT_URL=http://localhost:9636/v1/depot
export PATH=/root/.cargo/bin:$PATH

alias psql="/hab/pkgs/core/postgresql/9.6.1/20170606002619/bin/psql -U hab -h 127.0.0.1"
