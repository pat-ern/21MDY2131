-- caso 1A (LISTO)

SELECT 
ts.descripcion||', '||sa.descripcion AS SISTEMA_SALUD,
COUNT(*) AS TOTAL_ATENCIONES,
CASE
    WHEN COUNT(*)>(
        SELECT
        AVG(COUNT(*))
        FROM tipo_salud ts
        JOIN salud sa ON sa.tipo_sal_id=ts.tipo_sal_id
        JOIN paciente pa ON pa.sal_id=sa.sal_id
        JOIN atencion ate ON ate.pac_run=pa.pac_run
        WHERE TO_CHAR((ate.fecha_atencion), 'MMYYYY') = TO_CHAR((ADD_MONTHS(sysdate, -1)), 'MMYYYY')
        GROUP BY ts.descripcion||', '||sa.descripcion
    ) THEN 'CON DESCUENTO'
    ELSE 'SIN DESCUENTO'
END AS CORRESPONDE_DESCUENTO
FROM tipo_salud ts
JOIN salud sa ON sa.tipo_sal_id=ts.tipo_sal_id
JOIN paciente pa ON pa.sal_id=sa.sal_id
JOIN atencion ate ON ate.pac_run=pa.pac_run
WHERE TO_CHAR((ate.fecha_atencion), 'MMYYYY') = TO_CHAR((ADD_MONTHS(sysdate, -1)), 'MMYYYY')
GROUP BY ts.descripcion||', '||sa.descripcion

UNION

SELECT -- TODOS LOS TIPOS DE SALUD
ts.descripcion||', '||sa.descripcion,
0,
'SIN DESCUENTO'
FROM tipo_salud ts
JOIN salud sa ON sa.tipo_sal_id=ts.tipo_sal_id
GROUP BY ts.descripcion||', '||sa.descripcion

MINUS -- SE LE RESTAN LOS MISMOS QUE APARECEN EN LA PRIMERA QUERY

SELECT 
ts.descripcion||', '||sa.descripcion,
0,
'SIN DESCUENTO'
FROM tipo_salud ts
JOIN salud sa ON sa.tipo_sal_id=ts.tipo_sal_id
JOIN paciente pa ON pa.sal_id=sa.sal_id
JOIN atencion ate ON ate.pac_run=pa.pac_run
WHERE TO_CHAR((ate.fecha_atencion), 'MMYYYY') = TO_CHAR((ADD_MONTHS(sysdate, -1)), 'MMYYYY')
GROUP BY ts.descripcion||', '||sa.descripcion

ORDER BY 1;

-- caso 1B (LISTO)


SELECT 
TO_CHAR(pac.pac_run,'09G999G999')||'-'||pac.dv_run AS "RUT PACIENTE",
pac.pnombre||' '||pac.snombre||' '||pac.apaterno||' '||pac.amaterno AS "NOMBRE PACIENTE",
ROUND((MONTHS_BETWEEN(SYSDATE, pac.fecha_nacimiento))/12) AS "AÑOS",
'Le corresponde un '||
(CASE 
    WHEN ROUND((MONTHS_BETWEEN(SYSDATE, pac.fecha_nacimiento))/12) BETWEEN 65 AND 70 THEN 2
    WHEN ROUND((MONTHS_BETWEEN(SYSDATE, pac.fecha_nacimiento))/12) BETWEEN 71 AND 75 THEN 5
    WHEN ROUND((MONTHS_BETWEEN(SYSDATE, pac.fecha_nacimiento))/12) BETWEEN 76 AND 80 THEN 8
    WHEN ROUND((MONTHS_BETWEEN(SYSDATE, pac.fecha_nacimiento))/12) BETWEEN 81 AND 85 THEN 10
    WHEN ROUND((MONTHS_BETWEEN(SYSDATE, pac.fecha_nacimiento))/12) BETWEEN 86 AND 120 THEN 20
    END)
||'% de descuento en la primera consulta del año '||TO_CHAR(&&ANNO+1)
AS "PORCENTAJE DESCUENTO",
'Beneficio por tercera edad' AS OBSERVACION
FROM paciente pac
JOIN porc_descto_3ra_edad pdte ON ROUND((MONTHS_BETWEEN(SYSDATE, pac.fecha_nacimiento))/12) BETWEEN anno_ini AND anno_ter
JOIN atencion ate ON ate.pac_run=pac.pac_run
WHERE  EXTRACT(YEAR FROM ate.fecha_atencion)=&ANNO
GROUP BY TO_CHAR(pac.pac_run,'09G999G999')||'-'||pac.dv_run,
pac.pnombre||' '||pac.snombre||' '||pac.apaterno||' '||pac.amaterno,
ROUND((MONTHS_BETWEEN(SYSDATE, pac.fecha_nacimiento))/12)
HAVING COUNT(*)>4

UNION

SELECT 
TO_CHAR(pac.pac_run,'09G999G999')||'-'||pac.dv_run,
pac.pnombre||' '||pac.snombre||' '||pac.apaterno||' '||pac.amaterno,
ROUND((MONTHS_BETWEEN(SYSDATE, pac.fecha_nacimiento))/12),
'Le corresponde un 2% de descuento en la primera consulta del año '||TO_CHAR(&ANNO+1)
AS,
'Beneficio por cantidad de atenciones médicas anuales'
FROM paciente pac
JOIN atencion ate ON ate.pac_run=pac.pac_run
WHERE  EXTRACT(YEAR FROM ate.fecha_atencion)=&ANNO
AND ROUND((MONTHS_BETWEEN(SYSDATE, pac.fecha_nacimiento))/12) < 65
GROUP BY TO_CHAR(pac.pac_run,'09G999G999')||'-'||pac.dv_run,
pac.pnombre||' '||pac.snombre||' '||pac.apaterno||' '||pac.amaterno,
ROUND((MONTHS_BETWEEN(SYSDATE, pac.fecha_nacimiento))/12),
pac.pac_run
HAVING COUNT(*)>=5
ORDER BY 1

UNDEFINE ANNO;


-- caso 2 (LIST)

SELECT
esp.nombre AS ESPECIALIDAD,
TO_CHAR(med.med_run, '09G999G999')||'-'||med.dv_run AS RUT,
UPPER(med.apaterno)||' '||UPPER(med.amaterno)||' '||UPPER(med.pnombre)||' '||UPPER(med.snombre) AS MEDICO
FROM especialidad esp
JOIN especialidad_medico eme ON eme.esp_id=esp.esp_id
JOIN atencion ate ON ate.esp_id=eme.esp_id
JOIN medico med ON eme.med_run=med.med_run
WHERE EXTRACT(YEAR FROM ate.fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)-1
GROUP BY 
esp.nombre,
TO_CHAR(med.med_run, '09G999G999')||'-'||med.dv_run,
med.pnombre, med.snombre, med.apaterno, med.amaterno
HAVING COUNT(*)>10
ORDER BY
esp.nombre, med.apaterno;

-- caso 3 (LISTO CON PEQUEÑOS DETALLES)

SELECT 
uni.nombre AS UNIDAD,
med.apaterno||' '||med.amaterno||' '||med.pnombre||' '||med.snombre AS MEDICO,
med.telefono,
0 AS TOTAL_ATENCIONES
FROM unidad uni
JOIN medico med ON med.uni_id=uni.uni_id
JOIN especialidad_medico esm ON esm.med_run=med.med_run
AND TRUNC(MONTHS_BETWEEN(sysdate, med.fecha_contrato)/12) > 10
GROUP BY
uni.nombre,
med.apaterno||' '||med.amaterno||' '||med.pnombre||' '||med.snombre,
med.telefono


MINUS 

SELECT 
uni.nombre AS UNIDAD,
med.apaterno||' '||med.amaterno||' '||med.pnombre||' '||med.snombre AS MEDICO,
med.telefono,
0 AS TOTAL_ATENCIONES
FROM unidad uni
JOIN medico med ON med.uni_id=uni.uni_id
JOIN especialidad_medico esm ON esm.med_run=med.med_run
JOIN atencion ate ON ate.med_run=esm.med_run
WHERE EXTRACT(YEAR FROM ate.fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)
AND TRUNC(MONTHS_BETWEEN(sysdate, med.fecha_contrato)/12) > 10
GROUP BY
uni.nombre,
med.apaterno||' '||med.amaterno||' '||med.pnombre||' '||med.snombre,
med.telefono
HAVING COUNT(*) < 
    (SELECT
    MAX(COUNT(*))
    FROM medico med
    JOIN especialidad_medico esm ON esm.med_run=med.med_run
    JOIN atencion ate ON ate.med_run=esm.med_run
    WHERE EXTRACT(YEAR FROM ate.fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)-1
    GROUP BY med.med_run)
    
UNION 

SELECT 
uni.nombre AS UNIDAD,
med.apaterno||' '||med.amaterno||' '||med.pnombre||' '||med.snombre AS MEDICO,
med.telefono,
COUNT(*) AS TOTAL_ATENCIONES
FROM unidad uni
JOIN medico med ON med.uni_id=uni.uni_id
JOIN especialidad_medico esm ON esm.med_run=med.med_run
JOIN atencion ate ON ate.med_run=esm.med_run
WHERE EXTRACT(YEAR FROM ate.fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)
AND TRUNC(MONTHS_BETWEEN(sysdate, med.fecha_contrato)/12) > 10
GROUP BY
uni.nombre,
med.apaterno||' '||med.amaterno||' '||med.pnombre||' '||med.snombre,
med.telefono
HAVING COUNT(*) < 
    (SELECT
    MAX(COUNT(*))
    FROM medico med
    JOIN especialidad_medico esm ON esm.med_run=med.med_run
    JOIN atencion ate ON ate.med_run=esm.med_run
    WHERE EXTRACT(YEAR FROM ate.fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)-1
    GROUP BY med.med_run)


ORDER BY 1;

-- caso 4 (TODO BIEN)

SELECT
TO_CHAR(fecha_atencion, 'YYYY/MM'),
COUNT(*) AS TOTAL_DE_ATENCIONES,
SUM(COSTO) AS VALOR_TOTAL_ATENCIONES
FROM atencion
WHERE EXTRACT(YEAR FROM fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)
GROUP BY TO_CHAR(fecha_atencion, 'YYYY/MM')
HAVING COUNT(*) >= 
    ((SELECT
    AVG(COUNT(*)) 
    FROM atencion
    WHERE EXTRACT(YEAR FROM fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)
    GROUP BY TO_CHAR(fecha_atencion, 'YYYY/MM')))
UNION
SELECT
TO_CHAR(fecha_atencion, 'YYYY/MM'),
COUNT(*) AS TOTAL_DE_ATENCIONES,
SUM(COSTO) AS VALOR_TOTAL_ATENCIONES
FROM atencion
WHERE EXTRACT(YEAR FROM fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)-1
GROUP BY TO_CHAR(fecha_atencion, 'YYYY/MM')
HAVING COUNT(*) >= 15
UNION
SELECT
TO_CHAR(fecha_atencion, 'YYYY/MM'),
COUNT(*) AS TOTAL_DE_ATENCIONES,
SUM(COSTO) AS VALOR_TOTAL_ATENCIONES
FROM atencion
WHERE EXTRACT(YEAR FROM fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)-2
GROUP BY TO_CHAR(fecha_atencion, 'YYYY/MM')
HAVING COUNT(*) >= 40
ORDER BY 1;

-- caso 5 (TODO BIEN)

SELECT
'Medico con bonificación del 5% de las ganancias' AS BONIFICACION_GANANCIAS,
TO_CHAR(med.med_run, '09G999G999')||'-'||med.dv_run AS RUN_MEDICO,
med.pnombre||' '||med.snombre||' '||med.apaterno||' '||med.amaterno AS MEDICO,
COUNT(*) AS TOTAL_ATENCIONES_MEDICAS,
TO_CHAR(med.sueldo_base, 'L9G999G999') AS SUELDO_BASE,
TO_CHAR(TRUNC((225000000*0.05)/((
    SELECT
    COUNT(*)
    FROM (
        SELECT 
        COUNT(*) 
        FROM atencion ate 
        WHERE EXTRACT(YEAR FROM ate.fecha_atencion)=EXTRACT(YEAR FROM SYSDATE) 
        GROUP BY ate.med_run 
        HAVING COUNT(*)>7 )))), 'L9G999G999') AS BONIFICACION_X_GANANCIAS,
TO_CHAR(med.sueldo_base+TRUNC((225000000*0.05)/((
    SELECT
    COUNT(*)
    FROM (
        SELECT 
        COUNT(*) 
        FROM atencion ate 
        WHERE EXTRACT(YEAR FROM ate.fecha_atencion)=EXTRACT(YEAR FROM SYSDATE) 
        GROUP BY ate.med_run 
        HAVING COUNT(*)>7 )))), 'L9G999G999') AS SUELDO_TOTAL
FROM atencion ate
JOIN medico med on ate.med_run=med.med_run
WHERE EXTRACT(YEAR FROM ate.fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)
HAVING COUNT(*)>7
GROUP BY TO_CHAR(med.med_run, '09G999G999'), med.dv_run, med.pnombre, med.snombre, med.apaterno, med.amaterno, med.sueldo_base

UNION

SELECT
'Medico con bonificación del 2% de las ganancias',
TO_CHAR(med.med_run, '09G999G999')||'-'||med.dv_run,
med.pnombre||' '||med.snombre||' '||med.apaterno||' '||med.amaterno,
COUNT(*),
TO_CHAR(med.sueldo_base, 'L9G999G999'),
TO_CHAR(TRUNC((225000000*0.02)/
    ((SELECT
    COUNT(*)
    FROM (
        SELECT 
        COUNT(*) 
        FROM atencion ate 
        WHERE EXTRACT(YEAR FROM ate.fecha_atencion)=EXTRACT(YEAR FROM SYSDATE) 
        GROUP BY ate.med_run 
        HAVING COUNT(*)<=7 )))), 'L9G999G999'),
TO_CHAR(med.sueldo_base+TRUNC((225000000*0.02)/((
    SELECT
    COUNT(*)
    FROM (
        SELECT 
        COUNT(*) 
        FROM atencion ate 
        WHERE EXTRACT(YEAR FROM ate.fecha_atencion)=EXTRACT(YEAR FROM SYSDATE) 
        GROUP BY ate.med_run 
        HAVING COUNT(*)<=7 )))), 'L9G999G999')
FROM atencion ate
JOIN medico med on ate.med_run=med.med_run
WHERE EXTRACT(YEAR FROM ate.fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)
HAVING COUNT(*)<=7
GROUP BY TO_CHAR(med.med_run, '09G999G999'), med.dv_run, med.pnombre, med.snombre, med.apaterno, med.amaterno, med.sueldo_base
ORDER BY RUN_MEDICO;
