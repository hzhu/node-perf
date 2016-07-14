#!bin/bash -e

cd node-perf

ulimit -c unlimited

node --perf_basic_prof_only_functions --abort_on_uncaught_exception server.js