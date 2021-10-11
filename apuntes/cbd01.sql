-- cbd01

SELECT * 

-- SELECT * devuelve todas las columnas

SELECT
run, nombre
FROM estudiante;

-- ESTUDIANTE es la tabla

-- las sentencias select se componen por 'cláusulas'

WHERE

-- la cláusula "WHERE" me permite seleccionar las filas que cumplen con cierta condicion

-- ¿cómo seleccionar en la misma sentencia una columna que este en otra tabla? con la clausula JOIN

JOIN
ON  

-- ejemplo:

SELECT
run, nombre, nom_car
FROM carrera ca 
-- CA es un alias para la tabla dentro de la sentencia
JOIN estudiante es
ON es.id_car=ca.id_car
-- ON va a especificar la condición de unión
-- es decir que las ID_CAR de cada columna (ES y CA) sean idénticas

-- otros
-- usamos 18c o 19c de sql