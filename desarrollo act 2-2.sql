-- CASO 1


SELECT
	TO_CHAR(numrun, 'FM09G999G999')||'-'||dvrun AS "RUN CLIENTE",
	INITCAP(pnombre)||' '||INITCAP(snombre)||' '||INITCAP(appaterno)||' '||INITCAP(apmaterno) as "NOMBRE CLIENTE",
	prof.nombre_prof_ofic AS "PROFESION/OFICIO",
	TO_CHAR(fecha_nacimiento, 'DD "de" Month') AS "DIA DE CUMPLEAÑOS"
FROM 
	cliente cli
JOIN 
	profesion_oficio prof 
	ON cli.cod_prof_ofic=prof.cod_prof_ofic
WHERE 
	TO_CHAR(cli.fecha_nacimiento, 'Month')=TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'Month')
ORDER BY 
	"DIA DE CUMPLEAÑOS", 
	cli.appaterno;


-- CASO 2


SELECT  
    TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun AS "RUN CLIENTE",
    cli.pnombre||' '||cli.snombre||' '||cli.appaterno||' '||cli.apmaterno as "NOMBRE CLIENTE",
    TO_CHAR(SUM(monto_solicitado), 'L9G999G999') as "MONTO SOLICITADO CREDITOS",
    TO_CHAR((TRUNC(SUM(monto_solicitado)/100000*1200)), 'L999G999') AS "TOTAL PESOS TODOSUMA"
FROM 
    cliente cli
JOIN 
    credito_cliente credc 
    ON credc.nro_cliente = cli.nro_cliente
WHERE 
    EXTRACT(YEAR FROM credc.fecha_solic_cred) = EXTRACT(YEAR FROM SYSDATE)-1
GROUP BY 
    TO_CHAR(cli.numrun, 'FM09G999G999')||'-'||cli.dvrun,
    cli.pnombre||' '||cli.snombre||' '||cli.appaterno||' '||cli.apmaterno,
    cli.appaterno
ORDER BY
    "TOTAL PESOS TODOSUMA",
    cli.appaterno;


-- CASO 3

