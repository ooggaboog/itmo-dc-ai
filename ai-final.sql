/*Петр и Мария находятся на разных остановках троллейбуса (номер маршрута — 11 ), причем на противоположных направлениях.
Петр находится на остановке Большой проспект В.О. (10, 11) с идентификатором 15463 , а Мария на остановке Улица Кораблестроителей (9, 11) с идентификатором 16777 .
Время — середина дня и троллейбусы двигаются в обычном режиме с одинаковой скоростью в прямом и обратном направлениях.
В этих условиях Петр и Мария пытаются хотя бы приблизительно понять, на каких остановках троллейбуса нужно выйти, чтобы встретиться как можно быстрее.
Следующая серия запросов позволит в конечном счете дать ответ на этот вопрос.*/

-- 1. Какие идентификаторы направления движения соответствует остановкам Петра и Марии?
-- Введите идентификатор направления движения остановки Петра:
SELECT ID_DIRECTION FROM ROUTE_BY_STOPS 
WHERE ROUTE_NUMBER = 11 AND ID_STOP = 15463;
-- Введите идентификатор направления движения остановки Марии:
SELECT ID_DIRECTION FROM ROUTE_BY_STOPS 
WHERE ROUTE_NUMBER = 11 AND ID_STOP = 16777;


-- 2. Какие географические координаты соответствуют остановке, на которой находится Петр?
SELECT LATITUDE, LONGITUDE FROM STOPS 
WHERE ID_STOP = 15463;


-- 3. Определите идентификатор ближайшей остановки противоположного направления на маршруте 11 троллейбуса для Петра:
SELECT STOPS.ID_STOP
FROM STOPS
JOIN ROUTE_BY_STOPS ON STOPS.ID_STOP = ROUTE_BY_STOPS.ID_STOP
WHERE ROUTE_BY_STOPS.ROUTE_NUMBER = 11 
  AND ROUTE_BY_STOPS.ID_DIRECTION = 1
ORDER BY CoordinateDistance(
    (SELECT LATITUDE FROM STOPS WHERE ID_STOP = 15463),
    (SELECT LONGITUDE FROM STOPS WHERE ID_STOP = 15463),
    STOPS.LATITUDE, STOPS.LONGITUDE
)
;


-- 4. Определите расстояние до ближайшей остановки противоположного направления на маршруте 11 троллейбуса для Петра.
SELECT DISTINCT CoordinateDistance(
    (SELECT LATITUDE FROM STOPS WHERE ID_STOP = 15463),
    (SELECT LONGITUDE FROM STOPS WHERE ID_STOP = 15463),
    (SELECT LATITUDE FROM STOPS WHERE ID_STOP = 16784),
    (SELECT LONGITUDE FROM STOPS WHERE ID_STOP = 16784)
) AS distance FROM STOPS;



-- 5. Определите порядковый номер на 11 маршруте троллейбуса ближайшей остановки противоположного направления для Петра:
SELECT STOP_NUMBER FROM ROUTE_BY_STOPS
WHERE ROUTE_NUMBER = 11 
  AND ID_STOP = 16784
  AND ID_DIRECTION = 1;


-- 6. Определите порядковый номер STOP_NUMBER на 11 маршруте троллейбуса остановки Марии.
  SELECT STOP_NUMBER FROM ROUTE_BY_STOPS
WHERE ROUTE_NUMBER = 11 
  AND ID_STOP = 16777
  AND ID_DIRECTION = 1;


-- 7. Определите точное расстояние (в метрах), которое связывает остановку Марии и ближайшую остановку Петра в противоположном направлении на 11 маршруте троллейбуса.
SELECT SUM(DISTANCE_BACK) FROM ROUTE_BY_STOPS
WHERE ROUTE_NUMBER = 11 AND ID_DIRECTION = 1
AND STOP_NUMBER > 1 AND STOP_NUMBER <= 21
ORDER BY STOP_NUMBER;


-- 8. На какой остановке следует выйти Марии, чтобы расстояние, которое она проедет, оказалось как можно ближе к половине пути, определенному в пункте 7?
SELECT ID_STOP, DISTANCE_BACK FROM ROUTE_BY_STOPS
WHERE ROUTE_NUMBER = 11 AND ID_DIRECTION = 1
AND STOP_NUMBER > 1 AND STOP_NUMBER <= 21
ORDER BY STOP_NUMBER; 
-- ближе к 5110


-- 9. Какая остановка на направлении движении Петра окажется ближе всего к той остановке, на которой выйдет Мария (в пункте 8).
SELECT STOPS.ID_STOP
FROM STOPS
JOIN ROUTE_BY_STOPS ON STOPS.ID_STOP = ROUTE_BY_STOPS.ID_STOP
WHERE ROUTE_BY_STOPS.ROUTE_NUMBER = 11 
  AND ROUTE_BY_STOPS.ID_DIRECTION = 2
ORDER BY CoordinateDistance(
    (SELECT LATITUDE FROM STOPS WHERE ID_STOP = 14924),
    (SELECT LONGITUDE FROM STOPS WHERE ID_STOP = 14924),
    STOPS.LATITUDE, STOPS.LONGITUDE
)
;