-- CASO 1

SELECT
TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun AS "RUN CLIENTE",
INITCAP(cli.pnombre)||' '||INITCAP(cli.snombre)||' '||INITCAP(cli.appaterno)||' '||INITCAP(cli.apmaterno) AS "NOMBRE CLIENTE",
prof.nombre_prof_ofic AS "PROFESION/OFICIO",
TO_CHAR(cli.fecha_nacimiento, 'DD "de" Month') AS "DIA DE CUMPLEAÑOS"
FROM cliente cli
JOIN profesion_oficio prof 
ON cli.cod_prof_ofic=prof.cod_prof_ofic
WHERE TO_CHAR(cli.fecha_nacimiento, 'Month')=TO_CHAR(ADD_MONTHS(SYSDATE, 1), 'Month')
ORDER BY "DIA DE CUMPLEAÑOS", cli.appaterno;

-- CASO 1 VERSION PROFE

SELECT
TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun AS "RUN CLIENTE",
INITCAP(cli.pnombre)||' '||INITCAP(cli.snombre)||' '||INITCAP(cli.appaterno)||' '||INITCAP(cli.apmaterno) AS "NOMBRE CLIENTE",
prof.nombre_prof_ofic AS "PROFESION/OFICIO",
TO_CHAR(cli.fecha_nacimiento, 'DD "de" Month') AS "DIA DE CUMPLEAÑOS"
FROM cliente cli
JOIN profesion_oficio prof 
ON cli.cod_prof_ofic=prof.cod_prof_ofic
WHERE EXTRACT(MONTH FROM cli.fecha_nacimiento)=EXTRACT(MONTH FROM ADD_MONTHS(SYSDATE, 1))
ORDER BY "DIA DE CUMPLEAÑOS", cli.appaterno;

-- CASO 2

SELECT  
TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun AS "RUN CLIENTE",
cli.pnombre||' '||cli.snombre||' '||cli.appaterno||' '||cli.apmaterno as "NOMBRE CLIENTE",
TO_CHAR(SUM(monto_solicitado), 'L9G999G999') as "MONTO SOLICITADO CREDITOS",
TO_CHAR((TRUNC(SUM(monto_solicitado)/100000*1200)), 'L999G999') AS "TOTAL PESOS TODOSUMA"
FROM cliente cli
JOIN credito_cliente credc 
ON credc.nro_cliente = cli.nro_cliente
WHERE EXTRACT(YEAR FROM credc.fecha_otorga_cred) = EXTRACT(YEAR FROM SYSDATE)-1
GROUP BY 
TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun,
cli.pnombre||' '||cli.snombre||' '||cli.appaterno||' '||cli.apmaterno,
cli.appaterno
ORDER BY "TOTAL PESOS TODOSUMA", cli.appaterno;

-- CASO 2 VERSION PROFE

SELECT  
cli.numrun, cli.dvrun, cli.pnombre, cli.snombre, cli.appaterno, cli.apmaterno,
TO_CHAR(SUM(monto_solicitado), 'FML9G999G999') as "MONTO TOTAL CREDITOS",
TO_CHAR(SUM(monto_solicitado)/100000*1200, 'FML999G999') AS "TOTAL PESOS TODOSUMA"
FROM cliente cli
JOIN credito_cliente credc
ON credc.nro_cliente = cli.nro_cliente
WHERE EXTRACT(YEAR FROM credc.fecha_otorga_cred) = EXTRACT(YEAR FROM SYSDATE)-1
GROUP BY cli.numrun, cli.dvrun, cli.pnombre, cli.snombre, cli.appaterno, cli.apmaterno
ORDER BY SUM(monto_solicitado)/100000*1200), cli.appaterno;

-- CASO 3 (FALTO AGRUPAR POR MES Y SUMAR TOTAL)

SELECT	
TO_CHAR(crcl.fecha_otorga_cred, 'MMYYYY') AS "MES TRANSACCION",
UPPER(cred.nombre_credito) AS "TIPO CREDITO",
crcl.monto_credito AS "MONTO CREDITO",
crcl.monto_credito*(CASE 
	WHEN crcl.monto_credito BETWEEN 100000 AND 1000000 THEN 0.01
	WHEN crcl.monto_credito BETWEEN 1000001 AND 2000000 THEN 0.02
	WHEN crcl.monto_credito BETWEEN 2000001 AND 4000000 THEN 0.03
	WHEN crcl.monto_credito BETWEEN 4000001 AND 6000000 THEN 0.04
	WHEN crcl.monto_credito >= 6000001 THEN 0.07
END) AS "APORTE A LA SBIF"

FROM credito_cliente crcl

JOIN credito cred
ON cred.cod_credito = crcl.cod_credito

WHERE EXTRACT(YEAR FROM crcl.fecha_otorga_cred) = EXTRACT(YEAR FROM SYSDATE)-1

ORDER BY 
"MES TRANSACCION", 
"TIPO CREDITO";

-- CASO 3 VERSION PROFE

SELECT	
TO_CHAR(ccli.fecha_otorga_cred, 'MMYYYY') AS "MES TRANSACCION",
cred.nombre_credito AS "TIPO CREDITO",
TO_CHAR(SUM(ccli.monto_credito), 'L99G999G999') AS "MONTO CREDITO",
TO_CHAR(SUM(ccli.monto_credito)*(CASE 
	WHEN SUM(ccli.monto_credito) BETWEEN 100000 AND 1000000 THEN 0.01
	WHEN SUM(ccli.monto_credito) BETWEEN 1000001 AND 2000000 THEN 0.02
	WHEN SUM(ccli.monto_credito) BETWEEN 2000001 AND 4000000 THEN 0.03
	WHEN SUM(ccli.monto_credito) BETWEEN 4000001 AND 6000000 THEN 0.04
	WHEN SUM(ccli.monto_credito) >= 6000001 THEN 0.07
END), 'L99G999G999') AS "APORTE A LA SBIF"
FROM credito cred
JOIN credito_cliente ccli
ON cred.cod_credito = ccli.cod_credito
AND EXTRACT(YEAR FROM ccli.fecha_otorga_cred) = EXTRACT(YEAR FROM SYSDATE)-1
GROUP BY 
TO_CHAR(ccli.fecha_otorga_cred, 'MMYYYY'),
cred.nombre_credito
ORDER BY 
"MES TRANSACCION",
"TIPO CREDITO";

-- CASO 4 (FALTO SUMAR AHORRO MINIMO MENSUAL AL MONTO TOTAL AHORRADO)

SELECT

TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun AS "RUN CLIENTE",
cli.pnombre||' '||cli.snombre||' '||cli.appaterno||' '||cli.apmaterno AS "NOMBRE CLIENTE",
TO_CHAR(SUM(pdic.monto_total_ahorrado), 'L99G999G999') AS "MONTO TOTAL AHORRADO",
CASE
    WHEN SUM(pdic.monto_total_ahorrado) BETWEEN 100000 and 1000000 THEN 'BRONCE'
    WHEN SUM(pdic.monto_total_ahorrado) BETWEEN 1000001 and 4000000 THEN 'PLATA'
    WHEN SUM(pdic.monto_total_ahorrado) BETWEEN 4000001 and 8000000 THEN 'SILVER'
    WHEN SUM(pdic.monto_total_ahorrado) BETWEEN 8000001 and 15000000 THEN 'GOLD'   
    WHEN SUM(pdic.monto_total_ahorrado) > 15000000 THEN 'PLATINIUM'   
END AS "CATEGORIA CLIENTE"    

FROM cliente cli

JOIN producto_inversion_cliente pdic
ON pdic.nro_cliente = cli.nro_cliente

GROUP BY 
TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun,
cli.pnombre||' '||cli.snombre||' '||cli.appaterno||' '||cli.apmaterno,
cli.appaterno

ORDER BY
cli.appaterno,
SUM(pdic.monto_total_ahorrado) DESC;


-- CASO 4 VERS PROFE

SELECT

cli.numrun, cli.dvrun, cli.pnombre, cli.snombre, cli.appaterno, cli.apmaterno,
TO_CHAR(SUM(pdic.monto_total_ahorrado+pdic.ahorro_minimo_mensual), 'L99G999G999') AS "MONTO TOTAL AHORRADO",
CASE
    WHEN SUM(pdic.monto_total_ahorrado+pdic.ahorro_minimo_mensual) BETWEEN 100000 and 1000000 THEN 'BRONCE'
    WHEN SUM(pdic.monto_total_ahorrado+pdic.ahorro_minimo_mensual) BETWEEN 1000001 and 4000000 THEN 'PLATA'
    WHEN SUM(pdic.monto_total_ahorrado+pdic.ahorro_minimo_mensual) BETWEEN 4000001 and 8000000 THEN 'SILVER'
    WHEN SUM(pdic.monto_total_ahorrado+pdic.ahorro_minimo_mensual) BETWEEN 8000001 and 15000000 THEN 'GOLD'   
    WHEN SUM(pdic.monto_total_ahorrado+pdic.ahorro_minimo_mensual) > 15000000 THEN 'PLATINIUM'   
END AS "CATEGORIA CLIENTE"    

FROM cliente cli

JOIN producto_inversion_cliente pdic 
ON pdic.nro_cliente = cli.nro_cliente

GROUP BY 
cli.numrun, cli.dvrun, cli.pnombre, cli.snombre, cli.appaterno, cli.apmaterno

ORDER BY
cli.appaterno,
SUM(pdic.monto_total_ahorrado+pdic.ahorro_minimo_mensual) DESC;

-- CASO 5

SELECT
EXTRACT(YEAR FROM SYSDATE) AS "AÑO TRIBUTARIO",
TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun AS "RUN CLIENTE",
INITCAP(cli.pnombre)||' '||UPPER(SUBSTR(cli.snombre, 1, 1))||' '||INITCAP(cli.appaterno)||' '||INITCAP(cli.apmaterno) AS "NOMBRE CLIENTE",
COUNT(*) AS "TOTAL PROD. INV AFECTOS IMPTO",
TO_CHAR(SUM(pric.monto_total_ahorrado+pric.ahorro_minimo_mensual), 'L99G999G999') AS "MONTO TOTAL AHORRADO"
FROM producto_inversion_cliente pric
JOIN cliente cli 
ON cli.nro_cliente = pric.nro_cliente
WHERE pric.cod_prod_inv IN(30, 35, 40, 45, 50, 55)
GROUP BY 
EXTRACT(YEAR FROM SYSDATE),
cli.appaterno,
TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun,
INITCAP(cli.pnombre)||' '||UPPER(SUBSTR(cli.snombre, 1, 1))||' '||INITCAP(cli.appaterno)||' '||INITCAP(cli.apmaterno)
ORDER BY cli.appaterno;

-- CASO 6 A

SELECT
TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun AS "RUN CLIENTE",
INITCAP(cli.pnombre)||' '||INITCAP(cli.snombre)||' '||INITCAP(cli.appaterno)||' '||INITCAP(cli.apmaterno) AS "NOMBRE CLIENTE",
COUNT(*) AS "TOTAL CREDITOS SOLICITADOS",
TO_CHAR(SUM(ccli.monto_credito),'L99G999G999') AS "MONTO TOTAL CREDITOS"
FROM cliente cli
JOIN credito_cliente ccli
ON cli.nro_cliente = ccli.nro_cliente
WHERE EXTRACT(YEAR FROM ccli.fecha_otorga_cred) = &ANNIO_CONSULTA
GROUP BY
cli.appaterno,
TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun,
INITCAP(cli.pnombre)||' '||INITCAP(cli.snombre)||' '||INITCAP(cli.appaterno)||' '||INITCAP(cli.apmaterno)
ORDER BY cli.appaterno;

-- CASO 6 B


SELECT
TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun AS "RUN CLIENTE",
INITCAP(cli.pnombre)||' '||INITCAP(cli.snombre)||' '||INITCAP(cli.appaterno)||' '||INITCAP(cli.apmaterno) AS "NOMBRE CLIENTE",
CASE mov.cod_tipo_mov
    WHEN 1 THEN TO_CHAR(SUM(mov.monto_movimiento), 'L99G999G999')
    WHEN 2 THEN 'No realizó'
END AS ABONO,
CASE mov.cod_tipo_mov
    WHEN 2 THEN TO_CHAR(SUM(mov.monto_movimiento), 'L99G999G999')
    WHEN 1 THEN 'No realizó'
END AS RESCATE
FROM cliente cli
JOIN movimiento mov
ON cli.nro_cliente = mov.nro_cliente
WHERE EXTRACT(YEAR FROM mov.fecha_movimiento) = &ANNIO_CONSULTA
GROUP BY 
TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun,
INITCAP(cli.pnombre)||' '||INITCAP(cli.snombre)||' '||INITCAP(cli.appaterno)||' '||INITCAP(cli.apmaterno),
cli.appaterno,
mov.cod_tipo_mov
ORDER BY cli.appaterno;
