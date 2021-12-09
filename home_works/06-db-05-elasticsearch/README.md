# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
```
FROM centos:7

ENV ES_VER=7.15.2 \
    ES_USER=elauser


RUN adduser ${ES_USER}
USER 0
RUN yum install wget -y \
    && wget http://mirror.centos.org/centos/7/os/x86_64/Packages/perl-Digest-SHA-5.85-4.el7.x86_64.rpm \
	&& yum install perl-Digest-SHA-5.85-4.el7.x86_64.rpm -y  \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VER}-linux-x86_64.tar.gz \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VER}-linux-x86_64.tar.gz.sha512 \
    && shasum -a 512 -c elasticsearch-${ES_VER}-linux-x86_64.tar.gz.sha512 \
    && tar -xzf elasticsearch-${ES_VER}-linux-x86_64.tar.gz  \
    && cd elasticsearch-${ES_VER}/  

COPY elasticsearch.yml /elasticsearch-${ES_VER}/config/ 

RUN chown -R ${ES_USER} /elasticsearch-${ES_VER}/ \
  &&  mkdir /var/lib/elasticsearch/ \
  && chown -R ${ES_USER} /var/lib/elasticsearch/

EXPOSE 9200

USER ${ES_USER}
CMD /elasticsearch-${ES_VER}/bin/elasticsearch
```

```
sudo sysctl -w vm.max_map_count=262144

sudo docker build -t lutovp/elasticsearch:0.0.7 .

sudo docker run -d -p 9200:9200 lutovp/elasticsearch:0.0.7 
```

```
devuser@devuser-virtual-machine:~$ sudo docker network inspect bridge
[
    {
        "Name": "bridge",
        "Id": "470d32db723ac96fd6386a2e5e6e87c8af7e6d0533b8c39ee944d2898a271b8b",
        "Created": "2021-12-08T17:18:03.649943085+05:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "7bf9fdc63a48c0303fee0372d55bf00ec2d05d8c1acf9d20fcb49bdafa36cffd": {
                "Name": "sad_johnson",
                "EndpointID": "ea56380f7bbb6be1218cbbd377ee057b9b2b54da8457877b3060dbd342c302c0",
                "MacAddress": "02:42:ac:11:00:02",
                "IPv4Address": "172.17.0.2/16",
                "IPv6Address": ""
            }
        },
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        },
        "Labels": {}
    }
]

```

```
devuser@devuser-virtual-machine:~$ curl 172.17.0.2:9200/
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "AFhF3iUzRgitfqoKxxt2uw",
  "version" : {
    "number" : "7.15.2",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "93d5a7f6192e8a1a12e154a2b81bf6fa7309da0c",
    "build_date" : "2021-11-04T14:04:42.515624022Z",
    "build_snapshot" : false,
    "lucene_version" : "8.9.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}

```


- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
```
https://hub.docker.com/r/lutovp/elasticsearch
```
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины
  

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

```
path.data: /var/lib/elasticsearch
node.name: netology_test
http.host: _site_
http.port: 9200

```

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```
PUT 192.168.186.132:9200/ind-1
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0
    }
  }
}

```

```
PUT 192.168.186.132:9200/ind-2
{
  "settings": {
    "index": {
      "number_of_shards": 2,  
      "number_of_replicas": 1
    }
  }
}
```


```
PUT 192.168.186.132:9200/ind-3
{
  "settings": {
    "index": {
      "number_of_shards": 4,  
      "number_of_replicas": 2
    }
  }
}
```

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
**GET 192.168.186.132:9200/_cat/indices/ind-***
```
green  open ind-1 tHMbznSpTRyEnZYLjPU9pw 1 0 0 0 208b 208b
yellow open ind-3 EcgVMyIiTNWPNSWVSYa5CQ 4 2 0 0 208b 208b
yellow open ind-2 WrTRDA9WT4uOYo_Y6iY3zQ 2 1 0 0 416b 416b

```

Получите состояние кластера `elasticsearch`, используя API.

**GET 192.168.186.132:9200/_cluster/health/**
```
{
    "cluster_name": "elasticsearch",
    "status": "yellow",
    "timed_out": false,
    "number_of_nodes": 1,
    "number_of_data_nodes": 1,
    "active_primary_shards": 8,
    "active_shards": 8,
    "relocating_shards": 0,
    "initializing_shards": 0,
    "unassigned_shards": 10,
    "delayed_unassigned_shards": 0,
    "number_of_pending_tasks": 0,
    "number_of_in_flight_fetch": 0,
    "task_max_waiting_in_queue_millis": 0,
    "active_shards_percent_as_number": 44.44444444444444
}
```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
```
Потому что создали индексы с указним количества реплик, а т.к. нода всего одна, реплицировать некуда, потое yelow
```
Удалите все индексы.

**DELETE 192.168.186.132:9200/ind-\***

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

>В elasticsearch.yml добаляем:
```
path:
  repo:
    - /mnt/backups
    - /mnt/long_term_backups
```

```
FROM centos:7

ENV ES_VER=7.15.2 \
    ES_USER=elauser


RUN adduser ${ES_USER}
USER 0
RUN yum install wget -y \
    && wget http://mirror.centos.org/centos/7/os/x86_64/Packages/perl-Digest-SHA-5.85-4.el7.x86_64.rpm \
	&& yum install perl-Digest-SHA-5.85-4.el7.x86_64.rpm -y  \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VER}-linux-x86_64.tar.gz \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VER}-linux-x86_64.tar.gz.sha512 \
    && shasum -a 512 -c elasticsearch-${ES_VER}-linux-x86_64.tar.gz.sha512 \
    && tar -xzf elasticsearch-${ES_VER}-linux-x86_64.tar.gz  \
	&& rm perl-Digest-SHA-5.85-4.el7.x86_64.rpm \
	&& rm elasticsearch-${ES_VER}-linux-x86_64.tar.gz.sha512 \
	&& rm elasticsearch-${ES_VER}-linux-x86_64.tar.gz \
    && cd elasticsearch-${ES_VER}/  

COPY elasticsearch.yml /elasticsearch-${ES_VER}/config/ 

RUN chown -R ${ES_USER} /elasticsearch-${ES_VER}/ \
  && mkdir /var/lib/elasticsearch/ \
  && chown -R ${ES_USER} /var/lib/elasticsearch/ \
  && mkdir /mnt/backups/ \
  && mkdir /mnt/long_term_backups/ \
  && chown -R ${ES_USER} /mnt/backups/ \
  && chown -R ${ES_USER} /mnt/long_term_backups/
EXPOSE 9200

USER ${ES_USER}
CMD /elasticsearch-${ES_VER}/bin/elasticsearch
```



```
sudo docker build -t lutovp/elasticsearch:0.0.8 .

sudo docker run --name testelastic -d -p 9200:9200 \
-v /home/devuser/home_works/db_elastic/data:/var/lib/elasticsearch \
-v /home/devuser/home_works/db_elastic/backups:/mnt/backups \
-v /home/devuser/home_works/db_elastic/long_term_backups:/mnt/long_term_backups lutovp/elasticsearch:0.0.8

```

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.


Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

```
PUT 192.168.186.132:9200/_snapshot/netology_backup
  {
    "type": "fs",
    "settings": {
    "location": "/mnt/backups",
     "compress": true
  }
}

```
```
{
    "acknowledged": true
}
```

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```
PUT 192.168.186.132:9200/test
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0
    }
  }
}

```
```
{
    "acknowledged": true,
    "shards_acknowledged": true,
    "index": "test"
}
```
```
GET 192.168.186.132:9200/_cat/indices/
```

```
green open .geoip_databases 4KQVlXYhTX-V3Xh3NV97YQ 1 0 42 0 41.1mb 41.1mb
green open test             Sj9-VLNgQCWUg1_H_oWR8A 1 0  0 0   208b   208b
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

```
PUT 192.168.186.132:9200/_snapshot/netology_backup/snapshot_001?wait_for_completion=true
```
```
{
    "snapshot": {
        "snapshot": "snapshot_001",
        "uuid": "Yneel8sQSRmcFZbxsVUXlw",
        "repository": "netology_backup",
        "version_id": 7150299,
        "version": "7.15.2",
        "indices": [
            ".geoip_databases",
            "test"
        ],
        "data_streams": [],
        "include_global_state": true,
        "state": "SUCCESS",
        "start_time": "2021-12-09T09:57:08.748Z",
        "start_time_in_millis": 1639043828748,
        "end_time": "2021-12-09T09:57:10.152Z",
        "end_time_in_millis": 1639043830152,
        "duration_in_millis": 1404,
        "failures": [],
        "shards": {
            "total": 2,
            "failed": 0,
            "successful": 2
        },
        "feature_states": [
            {
                "feature_name": "geoip",
                "indices": [
                    ".geoip_databases"
                ]
            }
        ]
    }
}
```
**Приведите в ответе** список файлов в директории со `snapshot`ами.
```
GET 192.168.186.132:9200/_snapshot/netology_backup/_all
```
```
{
    "snapshots": [
        {
            "snapshot": "snapshot_001",
            "uuid": "Yneel8sQSRmcFZbxsVUXlw",
            "repository": "netology_backup",
            "version_id": 7150299,
            "version": "7.15.2",
            "indices": [
                ".geoip_databases",
                "test"
            ],
            "data_streams": [],
            "include_global_state": true,
            "state": "SUCCESS",
            "start_time": "2021-12-09T09:57:08.748Z",
            "start_time_in_millis": 1639043828748,
            "end_time": "2021-12-09T09:57:10.152Z",
            "end_time_in_millis": 1639043830152,
            "duration_in_millis": 1404,
            "failures": [],
            "shards": {
                "total": 2,
                "failed": 0,
                "successful": 2
            },
            "feature_states": [
                {
                    "feature_name": "geoip",
                    "indices": [
                        ".geoip_databases"
                    ]
                }
            ]
        }
    ],
    "total": 1,
    "remaining": 0
}
```

```
devuser@devuser-virtual-machine:~/home_works/db_elastic$ ls backups
index-0  index.latest  indices  meta-Yneel8sQSRmcFZbxsVUXlw.dat  snap-Yneel8sQSRmcFZbxsVUXlw.dat
devuser@devuser-virtual-machine:~/home_works/db_elastic$ ls backups

```


Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.
```
DELETE 192.168.186.132:9200/test

```
```
{
    "acknowledged": true
}
```
```
PUT 192.168.186.132:9200/test-2
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0
    }
  }
}
```
```
{
    "acknowledged": true,
    "shards_acknowledged": true,
    "index": "test-2"
}
```

```
GET 192.168.186.132:9200/_cat/indices
```

```
green open .geoip_databases 4KQVlXYhTX-V3Xh3NV97YQ 1 0 42 0 41.1mb 41.1mb
green open test-2           RAqNud5WQfq-po7kLXwfbg 1 0  0 0   208b   208b
```


[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```
DELETE 192.168.186.132:9200/_all
```
```
{
    "acknowledged": true
}
```

```
POST 192.168.186.132:9200/_snapshot/netology_backup/snapshot_001/_restore
{
  "indices": "*,-.*",
  "feature_states": [ "geoip" ]
}
```

```
GET 192.168.186.132:9200/_cat/indices

```
```
green open .geoip_databases I7_K7bpPQXayz6f5tpebdA 1 0 42 0 41.1mb 41.1mb
green open test             V43FhutKT66XhRiqQ_T8BA 1 0  0 0   208b   208b
```

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---
