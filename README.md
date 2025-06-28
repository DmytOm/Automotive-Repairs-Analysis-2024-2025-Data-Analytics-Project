    Auto Repair Analytics (2024–2025)

Аналіз понад 60 000 записів з CRM для оцінки ефективності СТО, тривалості ремонтів, відмінностей між B2B і B2C клієнтами, а також регіональних та часових патернів.

    Goal

Провести повноцінний аналітичний цикл двома окремими підходами:
повністю в Python — від очищення до фінального аналізу;
повністю в SQL — з власною логікою очищення, об’єднанням таблиць, підрахунками метрик і вивантаженням CSV;

На основі CSV-файлів, створених у SQL, побудовано візуалізації в Tableau.
Data Sources
repairs_2024.csv
repairs_2025.csv
Project Structure

    Python Pipeline

Об'єднання та попередня перевірка даних

Очищення даних: null-значення, SLA, дати, типи послуг

Додавання колонок: duration_days, is_b2b, month, year, region

Аналіз B2B vs B2C, типів послуг, регіональних відмінностей

Візуалізації в matplotlib / seaborn

Експорт у .csv

    SQL Pipeline

01_data_preparation.sql: створення repairs_all, очищення полів, створення repairs_clean
02_repair_analysis_queries.sql: аналітичні запити для експорту
Тривалість ремонту
Порівняння B2B/B2C
YoY-аналіз
Аналіз регіонів
Експорт .csv для подальшої роботи у Tableau
Tableau Dashboards
Завантажено експортовані CSV-файли
Побудовано графіки, KPI, мапу
Додано YoY-аналіз, середню тривалість, розбивку по клієнтам

    Key Files

Файл                                            Призначення

01_data_preparation.sql                         Створення та очищення таблиць

02_repair_analysis_queries.sql                  SQL-запити для експорту метрик

duration_by_service.csv                         Тривалість ремонту по послугах

duration_by_type_clients.csv                    Тривалість ремонту по типу клієнтів

monthly_repairs_upto_may.csv                    Щомісячна динаміка ремонтів

repairs_by_region_yoy.csv                       Регіональний аналіз з YoY-змінами

yoy_client_type_comparison.csv                  YoY по типах клієнтів

    Tools Used

Python: pandas, seaborn, matplotlib
SQL: PostgreSQL (через DBeaver)
BI: Tableau Public
Інше: CSV, Excel

    Outcome

Два незалежні підходи аналітики (Python vs SQL)
Побудовано класифікацію клієнтів та послуг
Визначено середню тривалість ремонтів по клієнтах та послугах
Порівняно обсяги ремонтів у розрізі регіонів і часу
Tableau-дешборд на основі SQL-метрик

    Автор

👤 Дмитрій Омельченко  
📫 Email: [dmitriyomelchenko96@icloud.com]  
🔗 [[LinkedIn ](https://www.linkedin.com/in/dmytriiomelchenko/)]
