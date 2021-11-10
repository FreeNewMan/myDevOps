
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"


## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
  >Ответ:
  **docker pull nginx**
  Using default tag: latest
latest: Pulling from library/nginx
b380bbd43752: Pull complete 
fca7e12d1754: Pull complete 
745ab57616cb: Pull complete 
a4723e260b6f: Pull complete 
1c84ebdff681: Pull complete 
858292fd2e56: Pull complete 
Digest: sha256:644a70516a26004c97d0d85c7fe1d0c3a67ea8ab7ddf4aff193d9f301670cf36
Status: Downloaded newer image for nginx:latest
docker.io/library/nginx:latest

- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

>Ответ
Создаем каталог с файлом index.html дла замены стандартной страницы
**mkdir myhtml
cd myhtml
touch index.html
nano index.html**
В файле index.html прописываем указнный выше html код, сохраняем
поднимаемся на уроввень выше
**cd ..**
Создаем файл-манифест для сборки нового образа на основе скачанного оффициального nginx
**touch Dockerfile
nano Dockerfile**
В нем указываем следующее
**FROM nginx
COPY myhtml /usr/share/nginx/html**

>Сборка образа
**docker build -t lutovp/mynginx:0.0.1 .**

>Список доступных образов
vagrant@server1:~$ **docker image list**
REPOSITORY       TAG       IMAGE ID       CREATED          SIZE
lutovp/mynginx   0.0.1     543405097e86   38 seconds ago   133MB
nginx            latest    87a94228f133   3 weeks ago      133MB



>Запуск образа с пробросом 80 порта на 8888 порт хостовой машины
**docker run -d -p 8888:80 lutovp/mynginx:0.0.1**

>Смотрим состояние контейнера
agrant@server1:~$ **docker ps**
CONTAINER ID   IMAGE                  COMMAND                  CREATED              STATUS              PORTS                                   NAMES
42d3ab867ecd   lutovp/mynginx:0.0.1   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:8888->80/tcp, :::8888->80/tcp   focused_mendeleev
  nostalgic_tharp

>Смотрим из внешнего мира
**http://192.168.192.11:8888/**



Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

>Ответ
agrant@server1:~$ **docker login -u lutovp**
Password: 
WARNING! Your password will be stored unencrypted in /home/vagrant/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
>vagrant@server1:~$ **docker push lutovp/mynginx:0.0.1**
The push refers to repository [docker.io/lutovp/mynginx]
12654d2b5d4a: Pushed 
9959a332cf6e: Pushed 
f7e00b807643: Pushed 
f8e880dfc4ef: Pushed 
788e89a4d186: Pushed 
43f4e41372e4: Pushed 
e81bff2725db: Pushed 
0.0.1: digest: sha256:32d9c825e1f66b4cc586a537cc42c3a04961ac817cc1aa01c94bac9da7c575a9 size: 1777

>https://hub.docker.com/repository/docker/lutovp/mynginx

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
  >Ответ: 
  Если приложением используется СУБД, то СУБД удобнее поставить на отдельную виртуальную машину или в docker контейнер, 
  а файлы данных подключить к контейнеру подключив каталог с данными, которые в свою очередь можно положить на физический сервер или в какое-нибудь облачное хранилище. 
  Само Java приложение можно (сервер приложений) удобнее всего заключить в контейнер и запускать необходимое количество в зависимости от нагрузки на виртуальной машине.

- Nodejs веб-приложение;
>Ответ: Само Nodejs удобно заключить контейнер, js файлы приложения можно положить в папку на хосте и примонтировать к контейнеру с Node

- Мобильное приложение c версиями для Android и iOS;
>Ответ: API бекэнда этих приложений скорее всего одинаковое. Которое также можно раскидать сервер приложения в один контейнер, СУБД - в другой. Файлы данных - физическое или облачное хранилище.

- Шина данных на базе Apache Kafka;
>Ответ
Удобнее всего заключить в контейнер т.к. можно запускать сколько угодно экземпляров по мере роста нагрузки

- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
>Ответ:
Если речь идет о количестве экземпляров компонентов, то удобнее всего оперировать количеством запущенных контейнеров.

- Мониторинг-стек на базе Prometheus и Grafana;
>Ответ Компоненты удбнее распределить на два контейнера и запускать на одной виртуальной машине.

- MongoDB, как основное хранилище данных для java-приложения;
>Ответ: Удобно использовать физический сервер или виртуальную машину для обеспечения максимальной скорости чтения - записи данных

- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
-Ответ:
Для CI/CD важно обеспечить максимальую производительность I/O операций с большим количеством данных, поэтому вполне возможен вариант физического сервера или виртуальной машины.

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
  
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
  
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
  
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.
  
>Ответ
**docker pull centos**
**docker pull debian:10**
vagrant@server1:~$ docker image list
REPOSITORY       TAG       IMAGE ID       CREATED        SIZE
debian       10        2b6f409b1d24   4 weeks ago   114MB
centos       latest    5d0da3dc9764   8 weeks ago   231MB


>**docker run --rm -ti -v /data:/data -d centos**
>**docker run --rm -ti -v /data:/data -d debian:10**

>root@devuser-virtual-machine:/data# **sudo docker ps**
CONTAINER ID   IMAGE       COMMAND       CREATED          STATUS          PORTS     NAMES
0b4afc6991a2   debian:10   "bash"        3 seconds ago    Up 2 seconds              thirsty_perlman
f09e8b7110ac   centos      "/bin/bash"   22 minutes ago   Up 22 minutes             nifty_faraday


>**docker exec -it nifty_faraday bash**
>**echo 'Privet mir' > /data/testfile.txt**
>**exit**
>**echo 'Privet mir 1' > /data/testfile1.txt**
>**docker exec -it thirsty_perlman bash**
>root@0b4afc6991a2:/# **ls /data**
testfile.txt  testfile1.txt

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.
>https://hub.docker.com/repository/docker/lutovp/ansible

