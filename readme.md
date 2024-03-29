#Описание жизненного цикла задачи (разработки нового функционала)

Задачи могут появляться из разных источников. Пользователи приложения могут что-то предлагать 
или указывать на какие-то недочеты (внешние). Также задачи могут возникать внутри компании/разработчика продукта (внутренние).

В зависимости от источника, предложения по улучшению или созданию нового могут отличаться степенью проработки приложения 
и адекватностью оценки трудозатрат и времени которое нужно для реализации.

Прежде чем попасть непосредственно исполнителю или группе разработчиков, та или иная хотелка должна пройти 
определенную фильтрацию (обычно менеджеры работают с клиентом) и доводку в плане оценки ресурсов, затем прорабатываются/согласовываются технические детали реализации.

Итак, задача создана, готова к реализации по следующим шагам:

1. Разработка

Задача попадает к условному разработчику или группе.
Реализация задачи должна производиться с использованием инструментов, методологий, стандартов принятых в компании. 
Это идентичная среда разработки, проверенные библиотеки, стиль написания кода, использование лучших(принятых в компании) практик.
Код должен быть максимально покрыт всевозможными тестами.

2. Тестирование

На этом этапе производится автоматизирование тестирование. Контроль степени покрытия тестами. 
При не прохождении тестов или недостаточности покрытия, задача возвращается на доработку

На этом этапе важна роль DevOps специалиста в части обеспечения необходимой инфраструктурой 
для максимального удобства с высокой степенью автоматизации и контроля процесса.

Также на этом этапе могут быть привлечены тестировщики, люди которые будут показывать конечный результат пользователям.

3. Разворот в изолированном окружении - максимально приближенном к продакшену. 

Если тесты все прошли удачно, решение разворачивается в изолированном окружении (песочнице) 
которое может быть быстро развернуто и удалено в кротчайшие сроки и максимально автоматизирован. 
Здесь DevOps отвечает за соответствующую инфраструктуру.

4. Разворот в продакшн
Разворот в продакшн производится автоматически после успешного прохождения всех тестов.
Должна существовать возможность отката изменения в случае отказа от решения по каким либо причинам 
(решение больше не актуально или другие изменения в ситуации или в бизнесе).

5. Мониторинг 
После того как решение запущено в продакшн желательно наличие метрик по анализу степени использования этого решения, а также сбор данных по ошибкам.\

6. Вывод из эксплуатации
В какой-то момент решение устаревает или больше не используется, его нужно выводить из эксплуатации или производить его модернизацию, 
то есть создавать новые задачи, возвращаться к пункту 1.






