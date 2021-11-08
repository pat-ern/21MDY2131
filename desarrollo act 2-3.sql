--CASO 5
SELECT 
TO_CHAR(cli.numrun, '99G999G999')||'-'||cli.dvrun AS RUN_CLIENTE,
INITCAP(cli.pnombre)||' '||SUBSTR(cli.snombre, 0, 1)||'. '||INITCAP(cli.appaterno)||' '||INITCAP(cli.apmaterno) AS NOMBRE_CLIENTE,
COUNT(*) AS TOTAL_SUPER_AVANCES_VIGENTES,
TO_CHAR(SUM(ttc.monto_total_transaccion), 'L99G999G999') AS MONTO_TOTAL_SUPER_AVANCES
FROM cliente cli
JOIN tarjeta_cliente tc ON cli.numrun = tc.numrun
JOIN transaccion_tarjeta_cliente ttc ON tc.nro_tarjeta = ttc.nro_tarjeta
WHERE ttc.cod_tptran_tarjeta = 103
GROUP BY cli.numrun,cli.dvrun,cli.pnombre,cli.snombre,cli.appaterno,cli.apmaterno
ORDER BY cli.appaterno;

--CASO 6 INFORME1
SELECT 

TO_CHAR(cli.numrun, '99G999G999')||'-'||cli.dvrun AS RUN_CLIENTE,
INITCAP(cli.pnombre)||' '||SUBSTR(cli.snombre, 0, 1)||'. '||INITCAP(cli.appaterno)||' '||INITCAP(cli.apmaterno) AS NOMBRE_CLIENTE,
cli.direccion AS DIRECCION,
prov.nombre_provincia AS PROVINCIA,
reg.nombre_region AS REGION,

COUNT(CASE 
    WHEN ttc.cod_tptran_tarjeta = 101 THEN ttc.monto_total_transaccion
    ELSE NULL
END) AS CANT_COMPRAS,

TO_CHAR(NVL(SUM(CASE 
    WHEN ttc.cod_tptran_tarjeta = 101 THEN ttc.monto_total_transaccion
    ELSE NULL
END),0), 'L9G999G999')
 AS TOTAL_COMPRAS,

COUNT(CASE 
    WHEN ttc.cod_tptran_tarjeta = 102 THEN ttc.monto_total_transaccion
    ELSE NULL
END) AS CANT_AVANCES,

TO_CHAR(NVL(SUM(CASE 
    WHEN ttc.cod_tptran_tarjeta = 102 THEN ttc.monto_total_transaccion
    ELSE NULL
END),0), 'L9G999G999') AS TOTAL_AVANCES,

COUNT(CASE 
    WHEN ttc.cod_tptran_tarjeta = 103 THEN ttc.monto_total_transaccion
    ELSE NULL
END) AS CANT_SUPER,

TO_CHAR(NVL(SUM(CASE 
    WHEN ttc.cod_tptran_tarjeta = 103 THEN ttc.monto_total_transaccion
    ELSE NULL
END),0), 'L9G999G999') AS TOTAL_SUPER

FROM cliente cli

JOIN provincia prov ON cli.cod_provincia = prov.cod_provincia AND cli.cod_region = prov.cod_region
JOIN region reg ON cli.cod_region = reg.cod_region

JOIN tarjeta_cliente tc ON cli.numrun = tc.numrun
LEFT JOIN transaccion_tarjeta_cliente ttc ON tc.nro_tarjeta = ttc.nro_tarjeta

GROUP BY
TO_CHAR(cli.numrun, '99G999G999')||'-'||cli.dvrun,
INITCAP(cli.pnombre)||' '||SUBSTR(cli.snombre, 0, 1)||'. '||INITCAP(cli.appaterno)||' '||INITCAP(cli.apmaterno),
cli.direccion, prov.nombre_provincia, reg.nombre_region, cli.appaterno

ORDER BY 
REGION, cli.appaterno;

--CASO 6 INFORME2