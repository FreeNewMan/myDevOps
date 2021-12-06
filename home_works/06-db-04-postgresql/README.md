# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

```
version: '3.1'
networks:
  db_network:
    driver: bridge
services:
  pg_db2:
    image: postgres:13
    container_name: testpg13
    restart: always
    environment:
      - POSTGRES_PASSWORD=admin 
      - POSTGRES_USER=admin
    volumes:
      - ./data:/var/lib/postgresql/data
      - ./backup:/backup
    networks:
      - db_network
    ports:
      - 5434:5432

```
Подключитесь к БД PostgreSQL используя `psql`.
```
sudo docker exec -it testpg13 psql -U admin
```

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.
```
admin=# \?
General
  \copyright             show PostgreSQL usage and distribution terms
  \crosstabview [COLUMNS] execute query and display results in crosstab
  \errverbose            show most recent error message at maximum verbosity
  \g [(OPTIONS)] [FILE]  execute query (and send results to file or |pipe);
                         \g with no arguments is equivalent to a semicolon
  \gdesc                 describe result of query, without executing it
  \gexec                 execute query, then execute each value in its result
  \gset [PREFIX]         execute query and store results in psql variables
  \gx [(OPTIONS)] [FILE] as \g, but forces expanded output mode
  \q                     quit psql
  \watch [SEC]           execute query every SEC seconds

Help
  \? [commands]          show help on backslash commands
  \? options             show help on psql command-line options
  \? variables           show help on special variables
  \h [NAME]              help on syntax of SQL commands, * for all commands

Query Buffer
  \e [FILE] [LINE]       edit the query buffer (or file) with external editor
  \ef [FUNCNAME [LINE]]  edit function definition with external editor
  \ev [VIEWNAME [LINE]]  edit view definition with external editor
  \p                     show the contents of the query buffer
  \r                     reset (clear) the query buffer
  \s [FILE]              display history or save it to file
  \w FILE                write query buffer to file

```

**Найдите и приведите** управляющие команды для:
- вывода списка БД
```
admin=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
-----------+-------+----------+------------+------------+-------------------
 admin     | admin | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres  | admin | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
 template1 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
(4 rows)

```
- подключения к БД
```
admin=# \c admin
You are now connected to database "admin" as user "admin".
admin=# 
```
- вывода списка таблиц
```
admin=# \d
Did not find any relations.
admin=# 
```
- вывода описания содержимого таблиц
```
\d+ orders
```
- выхода из psql
```
\q
```

## Задача 2

Используя `psql` создайте БД `test_database`.
```
admin=# create database test_database;
CREATE DATABASE
admin=# 

```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
```
root@34fb9d557b4d:/# psql -U admin test_database < /backup/*.sql
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ERROR:  role "postgres" does not exist
CREATE SEQUENCE
ERROR:  role "postgres" does not exist
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE

```

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

```
test_database=# select * from pg_stats where tablename = 'orders' order by avg_width desc;
 public     | orders    | title   | f         |         0 |        16 |         -1 |                  |                   | {"Adventure psql time",Dbiezdmin,"Log gossips","Me and my bash-pet","My little database","Server gravity falls","WAL never lies","War 
and peace"} |  -0.3809524 |                   |                        | 
 public     | orders    | id      | f         |         0 |         4 |         -1 |                  |                   | {1,2,3,4,5,6,7,8}                                                                                                                     
            |           1 |                   |                        | 
 public     | orders    | price   | f         |         0 |         4 |     -0.875 | {300}            | {0.25}            | {100,123,499,500,501,900}                                                                                                             
            |   0.5952381 |                   |                        | 

test_database=# select attname, avg_width from pg_stats where tablename = 'orders' order by avg_width desc limit 1;
 title   |        16

test_database=# 

```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

```
create table orders_1 (check (price>499)) inherits (orders);
create table orders_2 (check (price<=499)) inherits (orders);

```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
>Ответ: Да, можно было. При добавлении данных СУБД будет учитывать условия по которым создано разделение таблиц, данные будут распределятся согласно этим условиям.

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.
```
pg_dump test_database -U admin -h 127.0.0.1 -p 5432 > /backup/test_data1.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

>Добавил бы атрибут UNIQUE в Create
```
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) UNIQUE NOT NULL ,
    price integer DEFAULT 0
);

```
---

