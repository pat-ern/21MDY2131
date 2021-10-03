
-- funciones de de grupo (a nivel de tabla)

SELECT MAX (salario) FROM empleado; -- valor mas alto (TEXTO FECHA Y NUMERO)
SELECT MIN (salario) FROM empleado; -- valor minimo (TEXTO FECHA Y NUMERO)
SELECT AVG (salario) FROM empleado; -- promedio
SELECT SUM (salario) FROM empleado; -- sumatoria
SELECT COUNT(*) (salario) FROM empleado; -- conteo de filas (?)

--

SELECT MAX(NOMBRE) FROM empleado; -- ORDENA ALFABETICAMENTE

--

SELECT SUM(salario), MAX(salario), MIN(salario) FROM empleado;

--

SELECT SUM(salario), MAX(salario), MIN(salario) FROM empleado;
WHERE id_escolaridad=50;

--

SELECT COUNT(*), COUNT(*) run(run_jefe), FROM empleado; -- NO CONSIDERA VALORES NULOS

--

SELECT COUNT(*), COUNT(*)(NVL(run(run_jefe, 0)), FROM empleado; -- NO CONSIDERA VALORES NULOS

--

SELECT MAX(fecha_contrato), MIN(fecha_contrato) FROM empleado; 

--

-- GROUP BY

SELECT COUNT(*) FROM alumno
GROUP BY carrera_id;

--

SELECT 
-- INICIO AGURPACION
COUNT(*) AS cantidad,
carreraid,
genero,
-- FIN DE AGRUPACION
FROM alumno
GROUP BY carrera_id, genero
ORDER BY carreraid;

-- SIEMPRE QUE SE VAYA A UTILIZAR UNA FUNCION DE GRUPO JUNTO A UNA COLUMNA
-- TODAS ESAS COLUMNAS DEBEN IR EN LA AGRUPACION

-- ¿CUÁNDO NO SE HACEN?...

SELECT COUNT(carreraid) AS cantidad, 
carreraid, 
genero
FROM ALUMNO
GROUP BY carreraid, genero
ORDER BY carreraid;

-- ejemplo explicito

SELECT COUNT(genero),
genero
FROM alumno
GROUP BY genero;


-- mostrar salario max x id escolaridad

SELECT
MAX(salario) AS sal_max,
id_escolaridad
FROM empleado
GROUP BY id_escolaridad
;

-- y ahora filtrar los que son mayores a 900000
-- no sirve el where (para filas)
-- sino el HAVING, hermano del where, para usarse con funciones de grupo

SELECT
MAX(salario) AS sal_max, id_escolaridad
FROM empleado
WHERE id_escolaridad=50
GROUP BY id_escolaridad
HAVING MAX(salario)>900000;

-- TAREA PARA EL VIERNES: 
-- leer ppts de experiencia
-- desarrollar:
-- caso 2 (martes)
-- caso 3 (miercoles)
-- caso 4 (jueves)
-- caso 1, 5, 6 (hacer si queda tiempo)
