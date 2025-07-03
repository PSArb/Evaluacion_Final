USE sakila;

-- EJERCICIO 1: Selecciona todos los nombres de las películas sin que aparezcan duplicados.
-- Tablas usadas: film.
-- Campos necesitados: title.
-- Decido utilizar SELECT DISTINCT porque quiero asegurarme de que, si hay títulos repetidos en la base de datos, solo se muestre una vez cada uno. Así evito duplicados en la lista final de películas.
SELECT DISTINCT title
FROM film;

-- EJERCICIO 2: Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
-- Tablas usadas: film.
-- Campos necesitados: title, rating.
-- Selecciono el campo 'title' de la tabla 'film' porque me piden solo el nombre de las películas. Decido filtrar con WHERE usando 'rating = "PG-13"' para mostrar únicamente las películas que tienen esa clasificación.
SELECT title
FROM film
WHERE rating = 'PG-13';

-- EJERCICIO 3: Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
-- Tablas usadas: film.
-- Campos necesitados: title, description.
-- En este caso selecciono tanto 'title' como 'description' porque me piden ambas columnas. Uso el operador LIKE con '%amazing%' para buscar la palabra "amazing" en cualquier parte de la descripción, asegurando que no importa si está al principio, en medio o al final.
SELECT title, description
FROM film
WHERE description LIKE '%amazing%';

-- EJERCICIO 4: Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
-- Tablas usadas: film.
-- Campos necesitados: title, length.
-- Selecciono el campo 'title' porque me piden solo el nombre de las películas. Filtro con WHERE para obtener solo aquellas donde 'length' es mayor a 120 minutos.
SELECT title
FROM film
WHERE length > 120;

-- EJERCICIO 5: Recupera los nombres de todos los actores.
-- Tablas usadas: actor.
-- Campos necesitados: first_name, last_name.
-- Decido seleccionar los campos 'first_name' y 'last_name' de la tabla actor para mostrar el nombre completo de todos los actores registrados en la base de datos. (se puede unir con un concat)
SELECT first_name, last_name
FROM actor;

SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM actor;

-- EJERCICIO 6: Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
-- Tablas usadas: actor.
-- Campos necesitados: first_name, last_name.
-- Uso WHERE con LIKE para filtrar los actores cuyo apellido ('last_name') contiene la palabra 'Gibson'. Así puedo encontrar coincidencias aunque esté acompañado de otro texto.
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Gibson%';

-- EJERCICIO 7: Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
-- Tablas usadas: actor.
-- Campos necesitados: actor_id, first_name, last_name.
-- Uso la condición BETWEEN en el WHERE para filtrar solo los actores cuyo 'actor_id' está en el rango de 10 a 20, ambos inclusive.
-- Además, decido incluir el 'actor_id' en el SELECT para ver el identificador de cada actor junto con su nombre y apellido y comprobar los resultados.
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- EJERCICIO 8: Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
-- Tablas usadas: film.
-- Campos necesitados: title, rating.
-- Utilizo la cláusula WHERE con NOT IN para excluir las películas clasificadas como 'R' o 'PG-13', y así obtengo solo las demás.
SELECT title
FROM film
WHERE rating NOT IN ('R', 'PG-13');

-- EJERCICIO 9: Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
-- Tablas usadas: film.
-- Campos necesitados: rating.
-- Uso GROUP BY para agrupar las películas por su clasificación ('rating') y COUNT(*) para contar cuántas hay en cada grupo. Selecciono 'rating' y el recuento.
SELECT rating, COUNT(*) AS total_peliculas
FROM film
GROUP BY rating;

-- EJERCICIO 10: Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
-- Tablas usadas: customer, rental.
-- Campos necesitados: customer_id, first_name, last_name.
-- En este caso hago un JOIN entre las tablas customer y rental usando customer_id, porque quiero obtener la información del cliente y la cantidad de alquileres que tiene registrados. Uso COUNT(rental_id) para contar cuántos alquileres ha hecho cada cliente, y agrupo por customer_id.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS cantidad_alquileres
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- EJERCICIO 11: Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento.
-- Tablas usadas: category, film_category, inventory, rental, film.
-- Campos necesitados: category_id, name, film_id, inventory_id, rental_id.
-- Decido hacer varios JOIN: empiezo uniendo category con film_category para relacionar categorías y películas, luego con inventory para saber qué copias hay de cada película, y después con rental para contar los alquileres. Agrupo el resultado por el nombre de la categoría y cuento los rentals.
SELECT cat.name AS categoria, COUNT(r.rental_id) AS cantidad_alquileres
FROM category cat
JOIN film_category fc ON cat.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY cat.name;

-- EJERCICIO 12: Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
-- Tablas usadas: film.
-- Campos necesitados: rating, length.
-- Selecciono el campo 'rating' y calculo el promedio de 'length' usando AVG(). Agrupo el resultado por 'rating' para ver el promedio de duración en cada clasificación.
SELECT rating, AVG(length) AS promedio_duracion
FROM film
GROUP BY rating;

-- EJERCICIO 13: Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
-- Tablas usadas: film, film_actor, actor.
-- Campos necesitados: film_id, title, actor_id, first_name, last_name.
-- En este caso hago un JOIN entre film, film_actor y actor. Decido hacerlo así porque la relación entre películas y actores es muchos a muchos, y film_actor me ayuda a encontrar qué actores aparecen en la película con título "Indian Love". Después, selecciono el nombre y apellido de esos actores.
SELECT a.first_name, a.last_name
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.title = 'Indian Love';

-- EJERCICIO 14: Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
-- Tablas usadas: film.
-- Campos necesitados: title, description.
-- Selecciono el campo 'title' de la tabla film y filtro usando WHERE con LIKE para buscar tanto "dog" como "cat" en la descripción. Uso OR para que me sirva cualquiera de las dos palabras.
SELECT title
FROM film
WHERE description LIKE '%dog%'
   OR description LIKE '%cat%';

-- EJERCICIO 15: Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
-- Tablas usadas: film.
-- Campos necesitados: title, release_year.
-- Selecciono el campo 'title' y uso WHERE con BETWEEN para filtrar aquellas películas cuyo año de lanzamiento ('release_year') está entre 2005 y 2010, ambos incluidos.
SELECT title
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- EJERCICIO 16: Encuentra el título de todas las películas que son de la misma categoría que "Family".
-- Tablas usadas: category, film_category, film.
-- Campos necesitados: name, film_id, title, category_id.
-- Primero identifico el category_id de la categoría "Family" en la tabla category. Después, relaciono ese ID con film_category para obtener los film_id, y por último uno con film para conseguir los títulos. Utilizo JOIN en cada paso.
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- EJERCICIO 17: Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
-- Tablas usadas: film.
-- Campos necesitados: title, rating, length.
-- Filtro primero por rating = 'R' y luego agrego otra condición con AND para asegurarme de que la duración ('length') es mayor a 120 minutos.
SELECT title
FROM film
WHERE rating = 'R'
  AND length > 120;

-- EJERCICIO 18 (BONUS): Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
-- Tablas usadas: actor, film_actor.
-- Campos necesitados: actor_id, first_name, last_name, film_id.
-- En este EJERCICIO hago un JOIN entre actor y film_actor para contar cuántas películas ha hecho cada actor. Utilizo GROUP BY para agrupar por actor y HAVING para quedarme solo con los que tienen más de 10 películas.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS cantidad_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10;

-- EJERCICIO 19 (BONUS): ¿Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor?
-- Tablas usadas: actor, film_actor.
-- Campos necesitados: actor_id, first_name, last_name.
-- Para resolver esto, decido usar una subconsulta con NOT EXISTS. Selecciono los actores cuyo actor_id no aparece en la tabla film_actor, es decir, que nunca han actuado en ninguna película.
SELECT a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS (
    SELECT 1 FROM film_actor fa WHERE fa.actor_id = a.actor_id
);

-- EJERCICIO 20 (BONUS): Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
-- Tablas usadas: category, film_category, film.
-- Campos necesitados: category_id, name, film_id, length.
-- Hago JOIN entre category, film_category y film para poder obtener la duración ('length') de cada película por categoría. Uso GROUP BY para agrupar por categoría y AVG() para sacar el promedio, y luego filtro con HAVING para mostrar solo las que superan los 120 minutos.
SELECT c.name AS categoria, AVG(f.length) AS promedio_duracion
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120;

-- EJERCICIO 21 (BONUS): Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
-- Tablas usadas: actor, film_actor.
-- Campos necesitados: actor_id, first_name, last_name, film_id.
-- Repito la lógica del EJERCICIO 18, pero cambio el filtro a HAVING COUNT(fa.film_id) >= 5 para mostrar los actores que han hecho al menos 5 películas.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS cantidad_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) >= 5;