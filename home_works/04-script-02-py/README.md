# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательные задания

1. Есть скрипт:
	```python
    #!/usr/bin/env python3
	a = 1
	b = '2'
	c = a + b
	```
	* Какое значение будет присвоено переменной c?
      ``` 
	  Переменной c ничего не будет присвоено, т.к. a и b содержат разные типы данных
	  ```
	* Как получить для переменной c значение 12?
		```
		c = int(str(a) + b)
		```
	* Как получить для переменной c значение 3?
		```
		c = a + int(b)
		```

2. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

	```python
    #!/usr/bin/env python3

    import os

	bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
	result_os = os.popen(' && '.join(bash_command)).read()
    is_change = False
	for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(prepare_result)
            break

	```

	Ответ:
	```python

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
       
 	```

1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

	Ответ:
	```python

       # !/usr/bin/env python3
       import os
       import sys
       
       spath = os.getcwd()+'/sysadm-homeworks'
       if len(sys.argv) == 2:
           spath = sys.argv[1]
       
       bash_command = [f'cd {spath}', "git status"]
       result_os = os.popen(' && '.join(bash_command)).read()
       is_change = False
       for result in result_os.split('\n'):
           if result.find('modified') != -1:
               prepare_result = result.replace('\tmodified:   ', '')
               print(spath+'/'+prepare_result)
       
 	```

1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.

Ответ:
```python
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

```

