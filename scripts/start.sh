#!bin/bash -e

cd node-perf

npm install

node --perf_basic_prof_only_functions server.js