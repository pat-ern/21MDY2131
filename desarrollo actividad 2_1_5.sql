--caso 1

SELECT 
carreraid as "IDENTIFICACION DE LA CARRERA",
COUNT(*) as "TOTAL ALUMNOS MATRICULADOS",
'Le corresponden '||TO_CHAR(COUNT(*)*&ASIGNACION, 'FML999G999')||' del presupuesto total asignado para publicidad' as "MONTO POR PUBLICIDAD"
FROM alumno
GROUP BY carreraid
ORDER BY 
"TOTAL ALUMNOS MATRICULADOS" DESC, 
"IDENTIFICACION DE LA CARRERA" DESC;

-- caso 2

SELECT 
carreraid AS CARRERA,
COUNT(*) AS "TOTAL DE ALUMNOS"
FROM alumno
GROUP BY carreraid
HAVING COUNT(*)>4
ORDER BY CARRERA;

-- caso 3

SELECT 
TO_CHAR(run_jefe, '09G999G999') AS "RUN JEFE SIN DV",
COUNT(*) AS "TOTAL DE EMPLEADOS A SU CARGO",
TO_CHAR(MAX(salario), '9G999G999') AS "SALARIO MAXIMO",
COUNT(*)*10||'% del salario máximo' AS "PORCENTAJE DE BONIFICACION",
TO_CHAR(COUNT(*)/10*MAX(salario), 'L999G999') AS "BONIFICACION"
FROM empleado
WHERE run_jefe is NOT NULL
GROUP BY run_jefe
--HAVING COUNT(*)>1
ORDER BY COUNT(*);

-- caso 4

SELECT 
id_escolaridad AS ESCOLARIDAD,
CASE id_escolaridad
    WHEN 10 THEN 'BÁSICA'
    WHEN 20 THEN 'MEDIA CIENTÍFICA HUMANISTA'
    WHEN 30 THEN 'MEDIA TÉCNICO PROFESIONAL'
    WHEN 40 THEN 'SUPERIOR CENTRO DE FORMACIÓN TÉCNICA'
    WHEN 50 THEN 'SUPERIOR INSTITUTO PROFESIONAL'
    WHEN 60 THEN 'SUPERIOR UNIVERSIDAD'
END AS "DESCRIPCION ESCOLARIDAD",
COUNT(*) AS "TOTAL DE EMPLEADOS",
TO_CHAR(MAX(salario), 'L9G999G999') AS "SALARIO MAXIMO",
TO_CHAR(MIN(salario), 'L999G999') AS "SALARIO MINIMO",
TO_CHAR(SUM(salario), 'L9G999G999') AS "SALARIO TOTAL",
TO_CHAR(ROUND(AVG(salario)), 'L999G999') AS "SALARIO PROMEDIO"
FROM empleado
GROUP BY id_escolaridad
ORDER BY COUNT(*) DESC;

-- caso 5

SELECT
tituloid AS COD_LIBRO,
COUNT(*) AS CANT_SOL,
CASE
    WHEN COUNT(*) <=1 THEN 'No se requieren nuevos ejemplares'
    WHEN COUNT(*) BETWEEN 2 AND 3 THEN 'Se requiere comprar 1 nuevo ejemplar'
    WHEN COUNT(*) BETWEEN 4 AND 5 THEN 'Se requieren comprar 2 nuevos ejemplares'
    ELSE 'Se requieren comprar 4 nuevos ejemplares'
END AS Sugerencia    
FROM prestamo
WHERE EXTRACT(YEAR FROM fecha_ini_prestamo) = EXTRACT(YEAR FROM SYSDATE)-1
GROUP BY tituloid
ORDER BY COUNT(*) DESC;

-- caso 6

SELECT
    run_emp,
    TO_CHAR(fecha_ini_prestamo, 'mm/yyyy') AS Fecha,
    COUNT(*) AS CANT_PRESTAMOS,
    TO_CHAR(COUNT(*)*10000, 'FML999G999') AS BONO
FROM prestamo

WHERE 
    EXTRACT(YEAR FROM fecha_ini_prestamo) = EXTRACT(YEAR FROM SYSDATE)-1

GROUP BY 
    run_emp, 
    TO_CHAR(fecha_ini_prestamo, 'mm/yyyy')

ORDER BY 
    fecha, 
    COUNT(*)*10000 DESC,
    run_emp DESC;