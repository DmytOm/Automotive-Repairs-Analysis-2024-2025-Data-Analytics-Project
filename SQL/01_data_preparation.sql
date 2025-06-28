CREATE TABLE repairs_2024 (
    "Назва" TEXT,
    "Дата створення" TIMESTAMP,
    "Дата змінення" TIMESTAMP,
    "Сервіс ремонту" TEXT,
    "Статус" TEXT,
    "Сервіс" TEXT,
    "Дата розрахунку" DATE,
    "Співпрацю відновлено" TEXT,
    "Послуга" TEXT,
    "Корпоративний клієнт" TEXT
);

CREATE TABLE repairs_2025 (
    "Назва" TEXT,
    "Дата створення" TIMESTAMP,
    "Дата змінення" TIMESTAMP,
    "Сервіс ремонту" TEXT,
    "Статус" TEXT,
    "Сервіс" TEXT,
    "Дата розрахунку" DATE,
    "Співпрацю відновлено" TEXT,
    "Послуга" TEXT,
    "Корпоративний клієнт" TEXT
);


CREATE TABLE repairs_all AS 
SELECT * FROM repairs_2024
UNION ALL
SELECT * FROM repairs_2025;

SELECT *
FROM repairs_all;

-- Перевірити кількість пропущених значень у кожній колонці
SELECT
  COUNT(*) AS total,
  COUNT("Дата створення") AS date_created,
  COUNT("Дата змінення") AS date_updated,
  COUNT("Дата розрахунку") AS date_done,
  COUNT("Статус") AS status,
  COUNT("Сервіс") AS service,
  COUNT("Сервіс ремонту") AS repair_type,
  COUNT("Назва") AS name,
  COUNT("Послуга") AS service_type,
  COUNT("Корпоративний клієнт") AS is_b2b
FROM repairs_all
WHERE "Статус" IN('Видано(корп. клієнт)', 'Розрахунок');

--Перевіряю значенн Null Дату розрахунку
SELECT  "Назва"
	, "Дата змінення"
	, "Дата розрахунку" 
FROM repairs_all
WHERE "Статус" IN('Видано(корп. клієнт)', 'Розрахунок') and "Дата розрахунку" IS null;


--Перевіряю значенн Null Сервіс
SELECT "Назва"
	, "Дата змінення"
	, "Дата розрахунку" 
	, "Сервіс"
	, "Статус"
FROM repairs_all
WHERE "Статус" IN('Видано(корп. клієнт)', 'Розрахунок') AND "Сервіс" IS NULL

--Перевіряю значенн Null в Послуга

SELECT "Назва"
	, "Послуга"
	, CASE 
		WHEN "Послуга" IS NULL AND left("Назва", 1) = 'T' THEN 'Турбіна' ELSE "Послуга"
	END AS "Послуга"
FROM repairs_all
WHERE "Статус" IN ('Видано(корп. клієнт)', 'Розрахунок') 
	AND "Послуга" IS NULL;



CREATE TABLE repairs_clean AS
SELECT  "Назва"
	, "Дата створення"
	, "Дата змінення"
	, "Статус"
	, CASE 
		WHEN "Сервіс" IS NULL AND RIGHT("Назва", 2) = 'HE' THEN 'Чернігів'
		WHEN "Сервіс" IS NULL AND RIGHT("Назва", 2) = 'VN' THEN 'Вінниця' 
		WHEN "Сервіс" IS NULL AND RIGHT("Назва", 2) = 'CH' THEN 'Черкаси' 
		ELSE "Сервіс"
	END AS "Сервіс"
	, CASE 
		WHEN "Дата розрахунку" IS NULL THEN "Дата змінення"::timestamp ELSE "Дата розрахунку"::timestamp
	END AS "Дата розрахунку"
	, CASE
		WHEN "Співпрацю відновлено" = 'Так' THEN 1 ELSE 0
	END as "Співпрацю відновлено"
	, CASE 
		WHEN "Послуга" IS NULL AND left("Назва", 1) = 'T' THEN 'Турбіна' ELSE "Послуга"
	END AS "Послуга"
	, CASE
		WHEN "Корпоративний клієнт" = 'Так' THEN 'B2B' ELSE 'B2C'
	END as "Корпоративний клієнт"
	--, EXTRACT(YEAR FROM "Дата створення")::text AS "Рік"
	--, EXTRACT(MONTH FROM "Дата створення")::text AS "Місяць"
FROM repairs_all
WHERE "Статус" IN('Видано(корп. клієнт)', 'Розрахунок')
;





