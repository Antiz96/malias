#!/bin/bash

sed -i '/alias_manager/d' ~/.bashrc && source ~/.bashrc && unalias alias_manager && rm -rf ~/.alias_manager && echo "The Alias Manager program has been successfully uninstalled" 
