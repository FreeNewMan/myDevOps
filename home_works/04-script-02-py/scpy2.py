# !/usr/bin/env python3
import socket

apps = ['drive.google.com', 'mail.google.com', 'google.com']
apps_ip = []

for  i in apps:
    chost = socket.gethostbyname(i)
    apps_ip.append(chost)

for idx, i in enumerate(apps):
    chost = socket.gethostbyname(i)
    apps_ip.append(chost)

j = 0
while (1 == 1):
    print(apps[j] +' - '+apps_ip[j])
    j += 1
    if j == 3:
        j = 0
        print(' ')
    cur_ip = socket.gethostbyname(apps[j])
    if cur_ip != apps_ip[j]:
        print('Error: URL сервиса ' + apps[j] + ' IP mismatch ' +' Старый IP:' + apps_ip[j]+' Новый IP: '+cur_ip)
        break