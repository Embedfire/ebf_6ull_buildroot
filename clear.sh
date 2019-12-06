#!/bin/bash
set -v
rm -rf output/target
find output/ -name .stamp_target_installed | xargs rm -rf 
