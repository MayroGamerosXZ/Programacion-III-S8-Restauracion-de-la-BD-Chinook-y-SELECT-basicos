# Programacion-III-S8-Restauracion-de-la-BD-Chinook-y-SELECT-basicos
Tarea Semana 08 25/09/25
# 📊 Base de Datos Chinook - Consultas SELECT

## 🎯 Objetivo
Este documento presenta la implementación y restauración de la base de datos **Chinook** en PostgreSQL usando Docker, así como la realización de 5 consultas SELECT fundamentales para demostrar diferentes técnicas de consulta de datos.

## 🛠️ Configuración del Entorno

### Tecnologías Utilizadas
- **PostgreSQL 15** (Contenedor Docker)
- **Docker** para containerización
- **DataGrip** como cliente de base de datos
- **Base de datos**: Chinook (muestra de tienda de música)

### Configuración del Contenedor
```bash
# Crear contenedor PostgreSQL con configuración personalizada
docker run --name PostGresChinook \
  -e POSTGRES_PASSWORD=NicoRobin1710 \
  -e POSTGRES_USER=Mayro \
  -e POSTGRES_DB=chinook \
  -p 5432:5432 \
  -d postgres:15
```

### Parámetros de Conexión
- **Host**: localhost
- **Puerto**: 5432
- **Base de datos**: chinook
- **Usuario**: Mayro
- **Contraseña**: NicoRobin1710

## 🗂️ Estructura de la Base de Datos Chinook

La base de datos Chinook simula una tienda de música digital con las siguientes tablas principales:

| Tabla | Descripción | Registros Aprox. |
|-------|-------------|------------------|
| Artist | Artistas musicales | ~275 |
| Album | Álbumes musicales | ~347 |
| Track | Canciones/Pistas | ~3,503 |
| Customer | Clientes | ~59 |
| Invoice | Facturas | ~412 |
| Employee | Empleados | ~8 |
| Genre | Géneros musicales | ~25 |

## 📝 Consultas SELECT Realizadas

### 1. Seleccionar Todas las Columnas de una Tabla

**Consulta:**
```sql
SELECT * FROM "Artist";
```

**Propósito:** Mostrar todos los campos de todos los artistas registrados.

**Resultado:** 
- **275 registros** con columnas: ArtistId, Name
- Ejemplos: AC/DC, Accept, Aerosmith, Alanis Morissette, Alice In Chains, etc.

---

### 2. Seleccionar Solo Algunas Columnas Específicas

**Consulta:**
```sql
SELECT "Name", "UnitPrice" FROM "Track";
```

**Propósito:** Mostrar únicamente el nombre y precio unitario de las canciones.

**Resultado:**
- **3,503 registros** con columnas: Name, UnitPrice
- Precios típicos: $0.99, $1.99
- Ejemplos: "For Those About To Rock (We Salute You)" - $0.99

---

### 3. Seleccionar Registros de Diferentes Tablas Sin Filtros

**Consulta:**
```sql
SELECT 
    "Artist"."Name" AS "Artista",
    "Album"."Title" AS "Album", 
    "Track"."Name" AS "Cancion"
FROM "Artist", "Album", "Track"
LIMIT 50;
```

**Propósito:** Demostrar el concepto de producto cartesiano entre múltiples tablas.

**Resultado:**
- **Producto cartesiano**: Cada artista se combina con todos los álbumes y todas las canciones
- **Combinaciones posibles**: 275 × 347 × 3,503 = ~334 millones de filas
- **Limitado a 50** para evitar saturación del sistema
- **Nota importante**: Los datos no están relacionados lógicamente (AC/DC aparece con álbumes de otros artistas)

**Comparación con JOIN:**
```sql
-- Consulta con relaciones correctas (CON FILTROS)
SELECT 
    "Artist"."Name" AS "Artista",
    "Album"."Title" AS "Album",
    "Track"."Name" AS "Cancion"
FROM "Artist" 
JOIN "Album" ON "Artist"."ArtistId" = "Album"."ArtistId"
JOIN "Track" ON "Album"."AlbumId" = "Track"."AlbumId"
LIMIT 20;
```

---

### 4. Usar LIMIT para Mostrar Solo Algunos Resultados

**Consulta Principal:**
```sql
SELECT "FirstName", "LastName", "Email", "Country"
FROM "Customer"
LIMIT 10;
```

**Propósito:** Limitar la cantidad de resultados mostrados.

**Resultado:**
- **Exactamente 10 clientes**
- Campos mostrados: FirstName, LastName, Email, Country
- Clientes de diferentes países: Brasil, Noruega, Bélgica, Canadá, etc.

**Consulta Adicional con Ordenamiento:**
```sql
SELECT "Album"."Title", AVG("Track"."UnitPrice") AS "Precio_Promedio"
FROM "Album"
JOIN "Track" ON "Album"."AlbumId" = "Track"."AlbumId"
GROUP BY "Album"."AlbumId", "Album"."Title"
ORDER BY "Precio_Promedio" DESC
LIMIT 5;
```

---

### 5. Seleccionar Todas las Filas Utilizando *

**Consultas:**
```sql
-- Géneros musicales
SELECT * FROM "Genre";

-- Empleados
SELECT * FROM "Employee";
```

**Propósito:** Mostrar todos los campos y registros completos de tablas específicas.

**Resultados:**
- **Genre**: 25 géneros (Rock, Jazz, Metal, Alternative & Punk, etc.)
- **Employee**: 8 empleados con información completa (nombre, apellido, cargo, fecha de contratación, etc.)

## 📊 Consultas Adicionales de Análisis

### Conteo de Registros por Tabla
```sql
SELECT 
    (SELECT COUNT(*) FROM "Artist") AS "Total_Artistas",
    (SELECT COUNT(*) FROM "Album") AS "Total_Albums", 
    (SELECT COUNT(*) FROM "Track") AS "Total_Canciones",
    (SELECT COUNT(*) FROM "Customer") AS "Total_Clientes",
    (SELECT COUNT(*) FROM "Invoice") AS "Total_Facturas";
```

**Resultado:**
| Total_Artistas | Total_Albums | Total_Canciones | Total_Clientes | Total_Facturas |
|----------------|--------------|-----------------|----------------|----------------|
| 275 | 347 | 3,503 | 59 | 412 |

### Análisis de Artistas con Más Canciones
```sql
SELECT 
    "Artist"."Name" AS "Artista",
    "Album"."Title" AS "Album",
    COUNT("Track"."TrackId") AS "Numero_Canciones"
FROM "Artist"
JOIN "Album" ON "Artist"."ArtistId" = "Album"."ArtistId"
JOIN "Track" ON "Album"."AlbumId" = "Track"."AlbumId"
GROUP BY "Artist"."ArtistId", "Artist"."Name", "Album"."AlbumId", "Album"."Title"
ORDER BY "Numero_Canciones" DESC
LIMIT 10;
```

## ✅ Conclusiones

1. **Producto Cartesiano vs JOIN**: La diferencia entre consultas con y sin filtros es crucial para obtener datos coherentes.

2. **Rendimiento**: Las consultas sin filtros pueden generar millones de combinaciones, por lo que es importante usar LIMIT.

3. **Flexibilidad de SELECT**: PostgreSQL permite diferentes enfoques para consultar datos según las necesidades específicas.

4. **Importancia de las Relaciones**: Las foreign keys en Chinook permiten consultas complejas y significativas entre tablas relacionadas.

## 🚀 Comandos Docker Útiles

```bash
# Ver contenedores en ejecución
docker ps

# Iniciar contenedor
docker start PostGresChinook

# Detener contenedor
docker stop PostGresChinook

# Ver logs
docker logs PostGresChinook

# Acceder al contenedor
docker exec -it PostGresChinook bash

# Conectar a PostgreSQL desde el contenedor
docker exec -it PostGresChinook psql -U Mayro -d chinook
```



## 👤 Información del Desarrollador

**Nombre :Mayro Gameros  
**Correo Electrónico:** barriosgamerosmayro@gmail.com
**Proyecto:** Implementación Base de Datos Chinook con PostgreSQL  
**Fecha:** Septiembre 2025  
**Tecnologías:** PostgreSQL, Docker, DataGrip, SQL  

### 🎵 Datos Curiosos del Proyecto
- **Base de datos musical** con más de 3,500 canciones
- **Producto cartesiano** de ejemplo genera 334+ millones de combinaciones
- **Usuario personalizado** "Mayro" con contraseña temática de anime
- **Contenedor Docker** optimizado para desarrollo local
- **25 géneros musicales** desde Rock hasta Electronica/Dance

### 🛠️ Habilidades Demostradas
- ✅ Configuración de contenedores Docker para PostgreSQL
- ✅ Restauración de bases de datos desde archivos SQL
- ✅ Implementación de consultas SELECT con diferentes niveles de complejidad
- ✅ Análisis de rendimiento y optimización de consultas
- ✅ Documentación técnica detallada
- ✅ Uso de herramientas profesionales de administración de BD (DataGrip)

