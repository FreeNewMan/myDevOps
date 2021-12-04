# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

>Ответ:
1. Поставим Postgres client для подключение к Postgresql в контейнере
**sudo apt install postgresql-client**
2. Установим Docker compose
**sudo apt install docker-compose**
```
version: '3.1'
networks:
  db_network:
    driver: bridge
services:
  pg_db:
    image: postgres:12
    container_name: testpg
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
      - 5432:5432
```
3. Запуск 
   **sudo docker-compose up -d**
## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
>Ответ:
**create user test_admin_user with password '1';**
**create database test_db;**
**\c test_db**

- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
>***CREATE TABLE orders (
	id serial PRIMARY KEY,
	name varchar,
    price integer);***

 >***CREATE TABLE clients (
	id serial PRIMARY KEY,
	surname varchar,
    country varchar,
    order_id integer,
    FOREIGN KEY (order_id)
      REFERENCES orders (id)
        );***
   
   >***CREATE INDEX idx_client_country ON clients (country);***

- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
>***GRANT ALL PRIVILEGES
ON ALL TABLES IN SCHEMA public 
TO test_admin_user;***
- создайте пользователя test-simple-user
>***create user test_simple_user with password '1';***
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
>***GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public 
TO test_simple_user;***

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
>test_db=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
-----------+-------+----------+------------+------------+-------------------
 admin     | admin | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres  | admin | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
 template1 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
 test_db   | admin | UTF8     | en_US.utf8 | en_US.utf8 | 
- описание таблиц (describe)
>***test_db=# \d orders***
                                 Table "public.orders"
 Column |       Type        | Collation | Nullable |              Default               
--------+-------------------+-----------+----------+------------------------------------
 id     | integer           |           | not null | nextval('orders_id_seq'::regclass)
 name   | character varying |           |          | 
 price  | integer           |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)
***test_db=# \d clients***
                                  Table "public.clients"
  Column  |       Type        | Collation | Nullable |               Default               
----------+-------------------+-----------+----------+-------------------------------------
 id       | integer           |           | not null | nextval('clients_id_seq'::regclass)
 surname  | character varying |           |          | 
 country  | character varying |           |          | 
 order_id | integer           |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "idx_client_country" btree (country)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```
test_db=# SELECT distinct  grantee                                       
FROM   information_schema.table_privileges 
WHERE  table_schema like '%public%':
     grantee      
admin
 test_admin_user
 test_simple_user
(3 rows)
```
- список пользователей с правами над таблицами test_db
>***SELECT table_catalog, table_schema, table_name, privilege_type, grantee
FROM   information_schema.table_privileges 
WHERE  table_catalog like '%test_db%' and table_schema like '%public%' order by table_name, grantee
;***
```
table_catalog | table_schema | table_name | privilege_type |     grantee      
---------------+--------------+------------+----------------+------------------
 test_db       | public       | clients    | INSERT         | admin
 test_db       | public       | clients    | TRIGGER        | admin
 test_db       | public       | clients    | REFERENCES     | admin
 test_db       | public       | clients    | TRUNCATE       | admin
 test_db       | public       | clients    | DELETE         | admin
 test_db       | public       | clients    | UPDATE         | admin
 test_db       | public       | clients    | SELECT         | admin
 test_db       | public       | clients    | INSERT         | test_admin_user
 test_db       | public       | clients    | TRIGGER        | test_admin_user
 test_db       | public       | clients    | REFERENCES     | test_admin_user
 test_db       | public       | clients    | TRUNCATE       | test_admin_user
 test_db       | public       | clients    | DELETE         | test_admin_user
 test_db       | public       | clients    | UPDATE         | test_admin_user
 test_db       | public       | clients    | SELECT         | test_admin_user
 test_db       | public       | clients    | DELETE         | test_simple_user
 test_db       | public       | clients    | INSERT         | test_simple_user
 test_db       | public       | clients    | SELECT         | test_simple_user
 test_db       | public       | clients    | UPDATE         | test_simple_user
 test_db       | public       | orders     | INSERT         | admin
 test_db       | public       | orders     | TRIGGER        | admin
 test_db       | public       | orders     | REFERENCES     | admin
 test_db       | public       | orders     | TRUNCATE       | admin
 test_db       | public       | orders     | DELETE         | admin
 test_db       | public       | orders     | UPDATE         | admin
 test_db       | public       | orders     | SELECT         | admin
 test_db       | public       | orders     | INSERT         | test_admin_user
 test_db       | public       | orders     | TRIGGER        | test_admin_user
 test_db       | public       | orders     | REFERENCES     | test_admin_user
 test_db       | public       | orders     | TRUNCATE       | test_admin_user
 test_db       | public       | orders     | DELETE         | test_admin_user
 test_db       | public       | orders     | UPDATE         | test_admin_user
 test_db       | public       | orders     | SELECT         | test_admin_user
 test_db       | public       | orders     | DELETE         | test_simple_user
 test_db       | public       | orders     | SELECT         | test_simple_user
 test_db       | public       | orders     | UPDATE         | test_simple_user
 test_db       | public       | orders     | INSERT         | test_simple_user
(36 rows)
```
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders


|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

>Ответ
**insert into orders (id, name, price) values (nextval('orders_id_seq'), 'Шоколад', 10);
insert into orders (id, name, price) values (nextval('orders_id_seq'), 'Принтер', 3000);
insert into orders (id, name, price) values (nextval('orders_id_seq'), 'Книга', 500);
insert into orders (id, name, price) values (nextval('orders_id_seq'), 'Монитор', 7000);
insert into orders (id, name, price) values (nextval('orders_id_seq'), 'Гитара', 4000);**

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

>Ответ
**insert into clients (id, surname, country) values (nextval('clients_id_seq'), 'Иванов Иван Иванович', 'USA');
insert into clients (id, surname, country) values (nextval('clients_id_seq'), 'Петров Петр Петрович', 'Canada');
insert into clients (id, surname, country) values (nextval('clients_id_seq'), 'Иоганн Себастьян Бах', 'Japan');
insert into clients (id, surname, country) values (nextval('clients_id_seq'), 'Ронни Джеймс Диоч', 'Russia');
insert into clients (id, surname, country) values (nextval('clients_id_seq'), 'Ritchie Blackmore', 'Russia');**

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
```
 **select count(*) from orders;**
 count 
-------
     5
(1 row)

 **select count(*) from clients;**
 count 
------
     5
(1 row)
```

- приведите в ответе:
    - запросы 
    - результаты их выполнения.

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.
```
test_db=# select * from clients;
 id |       surname        | country | order_id 
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |         
  2 | Петров Петр Петрович | Canada  |         
  4 | Ронни Джеймс Диоч    | Russia  |         
  5 | Ritchie Blackmore    | Russia  |         
  3 | Иоганн Себастьян Бах | Japan   |         
(5 rows)

```
test_db=# **select * from orders;**
 id |  name   | price 
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)
test_db=# **update clients set order_id=3 where id =1;**
UPDATE 1
test_db=# **update clients set order_id=4 where id =2;**
UPDATE 1
test_db=# **update clients set order_id=5 where id =3;**
UPDATE 1
test_db=# 
```
```
>test_db=#  **select t.surname, tr.name from clients t inner join orders tr on (t.order_id = tr.id);**
>       surname        |  name   
>----------------------+---------
> Иванов Иван Иванович | Книга
> Петров Петр Петрович | Монитор
> Иоганн Себастьян Бах | Гитара
>(3 rows)

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
```
test_db=# explain select t.surname, tr.name from clients t inner join orders tr on (t.order_id = tr.id);
                                QUERY PLAN                                
--------------------------------------------------------------------------
 Hash Join  (cost=37.00..57.24 rows=810 width=64)
   Hash Cond: (t.order_id = tr.id)
   ->  Seq Scan on clients t  (cost=0.00..18.10 rows=810 width=36)
   ->  Hash  (cost=22.00..22.00 rows=1200 width=36)
         ->  Seq Scan on orders tr  (cost=0.00..22.00 rows=1200 width=36)
(5 rows)
```
>Читается вся таблица clients и по внешнему ключу происходт обращение к таблице orders и по ней тоже происходит поиск значения по всей таблице с выбором каждого ряд из clients
## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
>**sudo docker exec -it testpg bash**

>**pg_dump test_db -U admin -h 127.0.0.1 -p 5432 > /backup/test_db.sql**
>root@47b5a2b1f990:/# ls /backup
>test_db.sql

Остановите контейнер с PostgreSQL (но не удаляйте volumes).
>**sudo docker stop testpg**

Поднимите новый пустой контейнер с PostgreSQL.
>Отредатировал compose file. Добавил еще контейнер и пробросил postgres на другой порт. Создал папку data1 для второго контйнера
```
version: '3.1'
networks:
  db_network:
    driver: bridge
services:
  pg_db:
    image: postgres:12
    container_name: testpg
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
      - 5432:5432
  pg_db1:
    image: postgres:12
    container_name: testpg1
    restart: always
    environment:
      - POSTGRES_PASSWORD=admin 
      - POSTGRES_USER=admin
    volumes:
      - ./data1:/var/lib/postgresql/data
      - ./backup:/backup
    networks:
      - db_network
    ports:
      - 5433:5432 
```

```
devuser@devuser-virtual-machine:~/home_works/db_1$ sudo docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                       NAMES
d7fd363ced00   postgres:12   "docker-entrypoint.s…"   7 minutes ago   Up 7 minutes   0.0.0.0:5433->5432/tcp, :::5433->5432/tcp   testpg1
47b5a2b1f990   postgres:12   "docker-entrypoint.s…"   5 hours ago     Up 7 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   testpg
```
Восстановите БД test_db в новом контейнере.
Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

```
>Подключаемся к новому контйнеру
psql -h 192.168.186.132 -p 5433 -U admin
```
```
Password for user admin: 
psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1))
Type "help" for help.

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
***
Создаем пустую базу и пользователей

create database test_db;
create user test_simple_user with password '1';
create user test_admin_user with password '1';

Выходим

Восстанавливаем
```
sudo psql -h 192.168.186.132 -p 5433 -U admin  test_db < ./backup/test_db.sql
```



---


