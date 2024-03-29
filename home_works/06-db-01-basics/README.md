# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде
>Ответ: NoSQL. MongoDB например. Json позволяет хранить разные наборы данных с разной структурой и уровенм вложенности. То есть сразу закадывать какую-то жесткую струкутру не имеет смысла. 

- Склады и автомобильные дороги для логистической компании
>Ответ: Склады, дороги - Здесь можно достатовно точно опредленить структуру хранения данных и необходимые атрибуты. Подойдет Реляционная модель данны. Любая Sql СУБД. 
- Генеалогические деревья
Ответ: Генеалогия это есть иерархия. Логично использовать иерархические СУБД.
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации
>Ответ: Key-value СУБД: Redis или MemCache
- Отношения клиент-покупка для интернет-магазина
>Ответ: Здесь можно попробовать использовать Column-oriented СУБД. Например, в качестве ключа использовать логин клиента. Все покупки перечислть в столбцах. Для веб решения важно быстро обрабатыать заказы, поэтому согласованностью с реальными остатками и другое на складе можно пренебречь.

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)
>Ответ: AP. Система доступна (A) и разделена на несколько узлов(P) жертвуя согласованностью (C)
  
- При сетевых сбоях, система может разделиться на 2 раздельных кластера
>Ответ: CP. Согласована (С), и устойчива к разделению (P), но может быть недоступна на какое-то время (A)

- Система может не прислать корректный ответ или сбросить соединение
>Ответ: Может быть либо С либо P или CP, т.к. нет гарантии доступности A

А согласно PACELC-теореме, как бы вы классифицировали данные реализации?
PACELC вводит понятие времени отклика(L) с опредленным уровенем солгасованности(C) при разделении (P)


- Данные записываются на все узлы с задержкой до часа (асинхронная запись)
>Ответ: Система разделена на несколько узлов (P), данные могут отличаться на всех узлах в разный момент времени. Если бы не было разделения, то система была бы солгасована (С). PA/EC

- При сетевых сбоях, система может разделиться на 2 раздельных кластера
>Ответ: PC/EL. При отсутсвии разделения даныне отдаются с минимальной задеркой (EL). В случае разделения (P) на два кластера  может возникнуть задержка (L) которая требуется для обеспечения одинакового отклика от обоих кластеров, т.е. согласованности (C).

- Система может не прислать корректный ответ или сбросить соединение
>Ответ: Система может не прислать ответ, или ответ может быть очень долгим из-за большой задержки согласования данных жертвуя A- достпностью. EC/PC.


## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?
>Ответ: ACID требования напралены на обеспечение 100% согласованности и непртиворечивости данных при волнении кажой операции (транзакции)
BASE подход направлен на обеспечение максимальной доступности системы жертвуя согласованностью данных, т.к. на согласование данных может уходить значительное время.
Эти два подхода противоставляют друг друга. Совместить оба набора принципов 1 в 1 в рамках одной системы не получится. Возможны отступления в этих подходах при проектировании разных чистей одщей системы, то есть это уже будет две разные системы (одна направлена на производительность, друга на согласованность).


## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?

>Ответ: Pub/Sub системы оперируют структурами данных называемыми сообщениями, где отправители(pulishers)публикуют сообщения, а подписчики (subscribers) их читают. Таким образом можно выелить 3 ролевые функции этого механизма: Издатель, Подписчик, Система обработки сообщений.
Само сообщение имеет структуру key-value (ключ - занчение). Простая структура данных позволяет создавать высокопроизводительные системы, которые в основном используются для кэширования данных и обработки большого потока данных (очередей). Для каждого сообщения можно установить время жизни, что позволяет автоматически очищать систему от устаревших данных.




---

