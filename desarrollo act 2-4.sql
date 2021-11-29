-- CASO 1 A

SELECT
ts.descripcion||', '||sa.descripcion AS "Sistema Salud",
count(*) AS CANT
FROM tipo_salud ts

JOIN salud sa ON ts.tipo_sal_id=sa.tipo_sal_id
JOIN paciente pa ON sa.sal_id=pa.sal_id
JOIN atencion ate ON pa.pac_run=ate.pac_run

WHERE TO_CHAR(ate.fecha_atencion, 'MMYYYY')=TO_CHAR(ADD_MONTHS(SYSDATE, -2), 'MMYYYY')
GROUP BY ts.descripcion||', '||sa.descripcion, ts.descripcion, sa.descripcion

HAVING COUNT(*) > (
    SELECT 
    ROUND(AVG(COUNT(*))) 
    FROM ATENCION
    WHERE TO_CHAR(fecha_atencion, 'MMYYYY')=TO_CHAR(ADD_MONTHS(SYSDATE, -2), 'MMYYYY')
    GROUP BY TO_CHAR(fecha_atencion, 'DDMMYYYY'))
    
ORDER BY ts.descripcion, sa.descripcion; 

-- ******************************* TAREA ******************************* (AÑADIR FORMATO DE DINERO Y NOMBRES)

-- CASO 4 A

SELECT
TO_CHAR(FECHA_ATENCION, 'YYYY/MM') AS PERIODO,
COUNT(*) AS CANT_ATENC,
SUM(COSTO) AS VALOR_TOTAL
FROM ATENCION
WHERE EXTRACT(YEAR FROM FECHA_ATENCION) >= EXTRACT(YEAR FROM SYSDATE)-3 AND EXTRACT(YEAR FROM FECHA_ATENCION)<=EXTRACT(YEAR FROM SYSDATE)
GROUP BY TO_CHAR(FECHA_ATENCION, 'YYYY/MM')
HAVING COUNT(*)>=(SELECT 
                    ROUND(AVG(COUNT(*))) 
                    FROM ATENCION
                    WHERE EXTRACT(YEAR FROM FECHA_ATENCION)=EXTRACT(YEAR FROM SYSDATE)
                    GROUP BY TO_CHAR(FECHA_ATENCION, 'YYYY/MM'))
ORDER BY PERIODO;

-- CASO 4 B

SELECT
pac.pac_run, pac.dv_run,
pac.pnombre, pac.snombre, pac.apaterno, pac.amaterno,
ate.ate_id, pga.fecha_venc_pago, pga.fecha_pago, 
CASE
    WHEN pga.fecha_pago-pga.fecha_venc_pago>0 THEN pga.fecha_pago-pga.fecha_venc_pago
    ELSE 0
END AS DIAS_MOROSIDAD,
(CASE
    WHEN pga.fecha_pago-pga.fecha_venc_pago>0 THEN pga.fecha_pago-pga.fecha_venc_pago
    ELSE 0
END)*2000 AS VALOR_MULTA
FROM paciente pac
JOIN atencion ate ON ate.pac_run = pac.pac_run
JOIN pago_atencion pga ON pga.ate_id = ate.ate_id
WHERE (CASE
        WHEN pga.fecha_pago-pga.fecha_venc_pago>0 THEN pga.fecha_pago-pga.fecha_venc_pago
        ELSE 0
END)>(SELECT
ROUND(AVG(CASE
            WHEN pga.fecha_pago-pga.fecha_venc_pago>0 THEN pga.fecha_pago-pga.fecha_venc_pago
            ELSE NULL
END))
FROM PAGO_ATENCION pga)      
ORDER BY pga.fecha_venc_pago, DIAS_MOROSIDAD DESC;   

-- CASO 5 

SELECT  
TO_CHAR(med.med_run, 'FM09G999G999')||'-'||med.dv_run AS "RUN MEDICO", 
med.pnombre||' '||med.snombre||' '||med.apaterno||' '||med.amaterno AS "NOMBRE MEDICO", 
COUNT(*) AS "TOTAL ATENCIONES MEDICAS",
TO_CHAR(med.sueldo_base, 'L9G999G999') AS "SUELDO BASE",
TO_CHAR(TRUNC((225000000*0.05)/
    (SELECT
    COUNT(*)
    FROM (  
        SELECT
        COUNT(*)
        FROM atencion
        WHERE EXTRACT(YEAR FROM fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)
        GROUP BY med_run
        HAVING COUNT(*)>7)
)), 'L9G999G999') AS "BONIFICACION POR GANANCIAS",
TO_CHAR(TRUNC((225000000*0.05)/(
    SELECT
    COUNT(*)
    FROM (  
        SELECT
        COUNT(*)
        FROM atencion
        WHERE EXTRACT(YEAR FROM fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)
        GROUP BY med_run
        HAVING COUNT(*)>7)
)+med.sueldo_base), 'L9G999G999') AS "SUELDO TOTAL"
FROM medico med
JOIN atencion ate ON ate.med_run=med.med_run
WHERE EXTRACT(YEAR FROM ate.fecha_atencion)=EXTRACT(YEAR FROM SYSDATE)
GROUP BY med.med_run, med.dv_run, med.pnombre, med.snombre, med.apaterno, 
med.amaterno, med.sueldo_base
HAVING count(*)>7
ORDER BY med.med_run , med.apaterno;
