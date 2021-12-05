# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
```
version: '3.1'
networks:
  db_network:
    driver: bridge
services:
  mydb:
    image: mysql:8
    command: --default-authentication-plugin=mysql_native_password
    container_name: testmysql
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=admin 
    volumes:
      - ./mdata:/var/lib/mysql
      - ./backup:/backup
    networks:
      - db_network
    ports:
      - 3306:3306

```
```
sudo docker exec -it testmysql mysql -u root -p 
```


Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.
```

sudo docker exec -it testmysql bash

mysql -u root -p 

create database test_db;

exit

mysql -u root -p test_db < /backup/test_dump.sql

```



Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.
```
sudo docker exec -it testmysql bash

mysql -u root -p 
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.

For server side help, type 'help contents'

```


Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.
```
mysql> status
--------------
mysql  Ver 8.0.27 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		27
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.27 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			52 min 45 sec

Threads: 2  Questions: 86  Slow queries: 0  Opens: 184  Flush tables: 3  Open tables: 102  Queries per second avg: 0.027
--------------

```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.
```
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

```

**Приведите в ответе** количество записей с `price` > 300.
```
mysql> select count(*) from orders where price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.01 sec)

```


В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

```
CREATE USER 'test'@'localhost'
  IDENTIFIED WITH mysql_native_password BY 'test-pass'
  PASSWORD EXPIRE INTERVAL 180 DAY
  FAILED_LOGIN_ATTEMPTS 3 
  ATTRIBUTE '{"Surname": "Pretty", "Name": "James"}';

  ALTER USER 'test'@'localhost'
  WITH MAX_QUERIES_PER_HOUR 100;
 
```
Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

```
GRANT SELECT ON test_db.* TO 'test'@'localhost';
```
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

'''
select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user = 'test';

mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user = 'test';
+------+-----------+----------------------------------------+
| USER | HOST      | ATTRIBUTE                              |
+------+-----------+----------------------------------------+
| test | localhost | {"Name": "James", "Surname": "Pretty"} |
+------+-----------+----------------------------------------+
1 row in set (0.00 sec)


'''

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.
```
mysql> SHOW PROFILES;
+----------+------------+-------------------+
| Query_ID | Duration   | Query             |
+----------+------------+-------------------+
|        1 | 0.00058600 | SELECT DATABASE() |
|        2 | 0.00753725 | show databases    |
|        3 | 0.00394550 | show tables       |
|        4 | 0.00090075 | SET profiling = 1 |
+----------+------------+-------------------+
4 rows in set, 1 warning (0.00 sec)

```

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

>Ответ: InnoDB
```
mysql> SHOW TABLE STATUS WHERE Name = 'orders';
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
| orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2021-12-04 18:33:28 | NULL        | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.00 sec)
```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
```
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+-----------------------------------------+
| Query_ID | Duration   | Query                                   |
+----------+------------+-----------------------------------------+
|        1 | 0.00058600 | SELECT DATABASE()                       |
|        2 | 0.00753725 | show databases                          |
|        3 | 0.00394550 | show tables                             |
|        4 | 0.00090075 | SET profiling = 1                       |
|        5 | 0.00139625 | show tables                             |
|        6 | 0.00052025 | show engines                            |
|        7 | 0.00142775 | SHOW TABLE STATUS WHERE Name = 'orders' |
|        8 | 0.00135450 | SHOW TABLE STATUS WHERE Name = 'orders' |
|        9 | 0.00142225 | SHOW TABLE STATUS WHERE Name = 'orders' |
|       10 | 0.02349650 | ALTER TABLE orders ENGINE = MyISAM      |
|       11 | 0.02323000 | ALTER TABLE orders ENGINE = InnoDB      |
|       12 | 0.02037600 | ALTER TABLE orders ENGINE = MyISAM      |
|       13 | 0.00057425 | show engines                            |
|       14 | 0.00030150 | show engines                            |
+----------+------------+-----------------------------------------+
14 rows in set, 1 warning (0.00 sec)

```
- на `InnoDB`

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
```
innodb_flush_log_at_trx_commit = 2 
```
  
- Нужна компрессия таблиц для экономии места на диске
```
innodb_file_per_table = ON
```

- Размер буффера с незакомиченными транзакциями 1 Мб
```
innodb_log_buffer_size = 1M
```

- Буффер кеширования 30% от ОЗУ
```
innodb_buffer_pool_size = 300M
```

- Размер файла логов операций 100 Мб
```
innodb_log_file_size = 100M
```

Приведите в ответе измененный файл `my.cnf`.

>Копируем из контйнера на хост, редактируем 
```
sudo docker cp testmysql:/etc/mysql/my.cnf my.cnf

devuser@devuser-virtual-machine:/etc/mysql$ sudo nano my.cnf
devuser@devuser-virtual-machine:~/home_works/db_mysql$ sudo nano my.cnf

  GNU nano 4.8                                                                 my.cnf                                                                  Modified  
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

innodb_flush_log_at_trx_commit = 2

innodb_file_per_table = ON

innodb_log_buffer_size = 1M

innodb_buffer_pool_size = 300M

innodb_log_file_size = 100M


```
>Копируем обратно в контейнер
```
sudo docker cp my.cnf testmysql:/etc/mysql/my.cnf
```
>Перезапускаем контейнер
```
sudo docker stop testmysql
sudo docker start testmysql
```
---

