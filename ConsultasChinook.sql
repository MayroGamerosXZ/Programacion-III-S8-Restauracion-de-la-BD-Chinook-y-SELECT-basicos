-- 1. SELECCIONAR TODAS LAS COLUMNAS DE UNA TABLA
-- Mostrar todos los datos de la tabla Artist
SELECT * FROM "artist";



-- 2. SELECCIONAR SOLO ALGUNAS COLUMNAS DE UNA TABLA
-- Mostrar solo el nombre y el precio unitario de los tracks
SELECT "name", "unit_price"
FROM "track";



-- 3. SELECCIONAR REGISTROS DE DIFERENTES TABLAS SIN FILTROS
-- Mostrar datos de múltiples tablas (Artist, Album, Track)
SELECT
    "artist"."name" AS "Artista",
    "album"."title" AS "Album",
    "track"."name" AS "Cancion"
FROM "artist", "album", "track";



-- 4. USAR LIMIT PARA MOSTRAR SOLO ALGUNOS RESULTADOS
-- Mostrar solo los primeros 10 clientes
SELECT "first_name", "last_name", "email", "country"
FROM "customer"
LIMIT 10;

-- Mostrar los primeros 5 álbumes más caros (ordenados por precio promedio)
SELECT "album"."title", AVG("track"."unit_price") AS "Precio_Promedio"
FROM "album"
JOIN "track" ON "album"."album_id" = "track"."album_id"
GROUP BY "album"."album_id", "album"."title"
ORDER BY "Precio_Promedio" DESC
LIMIT 5;



-- 5. SELECCIONAR TODAS LAS FILAS DE UNA TABLA UTILIZANDO *
-- Mostrar todos los géneros musicales disponibles
SELECT * FROM "genre";

-- Mostrar todos los empleados de la empresa
SELECT * FROM "employee";