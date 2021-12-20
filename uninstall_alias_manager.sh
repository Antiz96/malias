#!/bin/bash

sed -i "/alias alias_manager='source ~\/.alias_manager\/alias_manager.sh'/d" ~/.bashrc && source ~/.bashrc && unalias alias_manager && rm -rf ~/.alias_manager && echo "The Alias Manager program has been successfully uninstalled" 
