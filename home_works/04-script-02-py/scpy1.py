#!/usr/bin/env python3
import os
import sys

spath = os.getcwd() + '/sysadm-homeworks'

bash_command = [f'cd {spath}', "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(spath +'/'+ prepare_result)
