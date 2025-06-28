
SELECT date_trunc('month', "Дата створення") AS "Місяць створення"
	, count(*) AS "Кількість"
FROM repairs_clean rc
WHERE date_part('month', "Дата створення") <= '5'
GROUP BY 1
ORDER BY 2,1
;

--Зміна ремонтів у % по типу Клієнтів
SELECT 
    "Корпоративний клієнт",
    "Рік створення",
    "Місяць створення",
    count,
    ROUND(
        ((count - LAG(count) OVER (
            PARTITION BY "Корпоративний клієнт", EXTRACT(MONTH FROM "Місяць створення")
            ORDER BY "Рік створення"
        ))::numeric / 
        NULLIF(LAG(count) OVER (
            PARTITION BY "Корпоративний клієнт", EXTRACT(MONTH FROM "Місяць створення")
            ORDER BY "Рік створення"
        ), 0)) * 100,
        2
    ) AS yoy_change_percent
FROM (
    SELECT 
        "Корпоративний клієнт",
        EXTRACT(YEAR FROM "Дата створення") AS "Рік створення",
        DATE_TRUNC('month', "Дата створення") AS "Місяць створення",
        COUNT(*) AS count
    FROM repairs_clean
    GROUP BY 1,2,3
) AS sub
ORDER BY "Корпоративний клієнт", "Місяць створення";



--Тривалість ремонту 
WITH duration_by_service AS ( 
	SELECT "Послуга"
		, DATE_PART('day', "Дата розрахунку" - "Дата створення") AS "duration_days"
	FROM repairs_clean rc
)
SELECT "Послуга"
	, round(avg(duration_days::numeric), 2) AS average_duration
FROM duration_by_service
GROUP BY 1
ORDER BY average_duration desc;
;

--Тривалість ремонту по Клієнтам
WITH duration_by_service AS ( 
	SELECT "Послуга"
		,  "Корпоративний клієнт"
		, DATE_PART('day', "Дата розрахунку" - "Дата створення") AS "duration_days"
	FROM repairs_clean rc
)
SELECT "Послуга"
	, "Корпоративний клієнт"
	, round(avg(duration_days::numeric), 2) AS average_duration
FROM duration_by_service
GROUP BY 1,2
ORDER BY "Корпоративний клієнт", average_duration desc;
;


--карта, порівняння з минулим роком
WITH region_count AS (
	SELECT date_part('year', rc."Дата створення" ) AS "Рік"
		, CASE
	    WHEN "Сервіс" ILIKE '%Київ%' THEN 'м. Київ'
	    WHEN "Сервіс" = 'Бровари' THEN 'Київська область'
	    WHEN "Сервіс" = 'Бориспіль' THEN 'Київська область'
	    WHEN "Сервіс" = 'Біла Церква' THEN 'Київська область'
	    WHEN "Сервіс" = 'Вишневе' THEN 'Київська область'
	    WHEN "Сервіс" = 'Ужгород' THEN 'Закарпатська область'
	    WHEN "Сервіс" IN ('Кривий Ріг', 'Дніпро', 'A Дніпро') THEN 'Дніпропетровська область'
	    WHEN "Сервіс" = 'Харків' THEN 'Харківська область'
	    WHEN "Сервіс" IN ('Черкаси', 'Умань') THEN 'Черкаська область'
	    WHEN "Сервіс" IN ('Львів', 'A Львів', 'Дрогобич') THEN 'Львівська область'
	    WHEN "Сервіс" IN ('Одеса') THEN 'Одеська область'
	    WHEN "Сервіс" = 'Суми' THEN 'Сумська область'
	    WHEN "Сервіс" IN ('Івано-Франківськ', 'A Івано-Франківськ', 'Коломия') THEN 'Івано-Франківська область'
	    WHEN "Сервіс" IN ('Полтава', 'Кременчук') THEN 'Полтавська область'
	    WHEN "Сервіс" = 'Чернігів' THEN 'Чернігівська область'
	    WHEN "Сервіс" = 'Рівне' THEN 'Рівненська область'
	    WHEN "Сервіс" = 'Запоріжжя' THEN 'Запорізька область'
	    WHEN "Сервіс" = 'Миколаїв' THEN 'Миколаївська область'
	    WHEN "Сервіс" IN ('Луцьк', 'A Луцьк', 'Ковель') THEN 'Волинська область'
	    WHEN "Сервіс" IN ('Вінниця', 'Вінниця 2') THEN 'Вінницька область'
	    WHEN "Сервіс" = 'Тернопіль' THEN 'Тернопільська область'
	    WHEN "Сервіс" IN ('Кропивницький', 'Олександрія') THEN 'Кіровоградська область'
	    WHEN "Сервіс" = 'Житомир' THEN 'Житомирська область'
	    WHEN "Сервіс" = 'Хмельницький' THEN 'Хмельницька область'
	    WHEN "Сервіс" = 'Чернівці' THEN 'Чернівецька область'
	    ELSE 'Невизначено'
	END AS "Область"
		, count(*) AS number
	FROM repairs_clean rc
	WHERE date_part('month', "Дата створення") <= 5
	GROUP BY 1,2
	ORDER BY "Рік"
)
SELECT *
	, round((number / lag(number) over(PARTITION BY "Область" ORDER BY "Рік")::NUMERIC -1) *100,2) AS prcnt_of_last_year
FROM region_count 
;


