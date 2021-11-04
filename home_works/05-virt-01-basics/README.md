
# Домашнее задание к занятию "5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения."

## Задача 1

Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.


>Ответ: 
>Полная аппаратная виртуализация: Гипервизор взаимодействует напрямую с оборудованием и явлется операционной системой для виртуальных машин.

>Паравиртуализация: Гипервизор эмулирует ресурсы через операционную систему среды запуска гипервизора, которая в свою очередь взаимодействет с обородованием через свои драйвера. 

>Виртуализация на основе ОС: В окружениии основной операционной системы создаются изолированные окружения виртуальных машин операционные системы которых используют ядра такокого же типа как и операционнй системы среды запуска вирутальных машин.


## Задача 2

Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.

Организация серверов:
- физические сервера,
- паравиртуализация,
- виртуализация уровня ОС.

Условия использования:
- Высоконагруженная база данных, чувствительная к отказу.
 
  >Ответ: Я бы выбрал виртулизацию на уровня ОС, т.к исключается слой эмуляции оборудования по ресурсам ОС, что приведет более выскокй производительности. Т.к. требуется отказоустойчивость, то нужна виртуализация, для возможности более быстрого восстановлегия окружения в случае отказа или увеличения ресурсов для повышения производительности.

- Различные web-приложения.
  
  >Ответ: Web-приложения могут быть зависимы от операционной системы: существуют стеки технологий которые требуют win окружение( Например IIS, ASP, MS SQL Server). Поэтому логичнее использовать паравиртуализацию, чтобы не было ограничений по типу запускаемых операционных систем. Необходимую производительность можно обеспечить добавлением виртуальных машин и настройкой балансировщика нагрузки на отдельном хосте.

- Windows системы для использования бухгалтерским отделом.
  
  >Ответ:
  Для Win систем логичнее использовать гипервизор Hyper-V, который относится к типу виртуализации на основе ОС.

- Системы, выполняющие высокопроизводительные расчеты на GPU.
  >Ответ: 
  Для высконагруженных расчетных систем логичнее использовать физические сервера, чтбы свести к минимум программные слои для обеспечения максимальной производительности расчетов.


Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

## Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.

>Ответ:
Если нет особоых требований, но виртуальные машины могуть быть как Win так и Linux, то логичным выбор систем с возможность паравиртуализации для абстрагирования от типа оборудования. Это либо продукты VMware или Xen

2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.
3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.
4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

## Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.