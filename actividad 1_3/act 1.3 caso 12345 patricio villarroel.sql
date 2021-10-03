-- CASO 1

SELECT
NUMRUN_CLI||'-'||DVRUN_CLI AS "RUN CLIENTE",
LOWER(PNOMBRE_CLI)||' '||INITCAP(SNOMBRE_CLI)||' '||APPATERNO_CLI||' '||APMATERNO_CLI AS "NOMBRE COMPLETO CLIENTE",
FECHA_NAC_CLI AS "FECHA NACIMIENTO"
FROM CLIENTE
WHERE TO_CHAR(FECHA_NAC_CLI, 'DD/MM') = TO_CHAR(SYSDATE+1, 'DD/MM');

SELECT
NUMRUN_CLI||'-'||DVRUN_CLI AS "RUN CLIENTE",
LOWER(PNOMBRE_CLI)||' '||INITCAP(SNOMBRE_CLI)||' '||APPATERNO_CLI||' '||APMATERNO_CLI AS "NOMBRE COMPLETO CLIENTE",
FECHA_NAC_CLI AS "FECHA NACIMIENTO"
FROM CLIENTE
WHERE EXTRACT(DAY FROM FECHA_NAC_CLI)=EXTRACT(DAY FROM SYSDATE+1)
AND EXTRACT(MONTH FROM FECHA_NAC_CLI)=EXTRACT (MONTH FROM SYSDATE+1);

-- CASO 2

SELECT
NUMRUN_EMP||'-'||DVRUN_EMP AS "RUN EMPLEADO",
PNOMBRE_EMP||' '||SNOMBRE_EMP||' '||APPATERNO_EMP||' '||APMATERNO_EMP AS "NOMBRE COMPLETO EMPLEADO",
SUELDO_BASE AS "SUELDO BASE",
ROUND(SUELDO_BASE/100000) AS "PORCENTAJE MOVILIZACIÓN",
ROUND (SUELDO_BASE*(ROUND(SUELDO_BASE/100000)/100)) AS "VALOR MOVILIZACIÓN"
FROM EMPLEADO
ORDER BY ROUND(SUELDO_BASE/100000) DESC;

-- CASO 3

SELECT
NUMRUN_EMP||' '||DVRUN_EMP AS "RUN EMPLEADO",
PNOMBRE_EMP||' '||SNOMBRE_EMP||' '||APPATERNO_EMP||' '||APMATERNO_EMP AS "NOMBRE COMPLETO EMPLEADO",
SUELDO_BASE AS "SUELDO BASE",
FECHA_NAC AS "FECHA NACIMIENTO",
SUBSTR(PNOMBRE_EMP,0,3)||LENGTH(PNOMBRE_EMP)||'*'||SUBSTR(SUELDO_BASE,-1)||DVRUN_EMP||ROUND(MONTHS_BETWEEN(SYSDATE, FECHA_CONTRATO)/12) AS "USUARIO", 
SUBSTR(NUMRUN_EMP,3,1)||EXTRACT(YEAR FROM FECHA_CONTRATO)+2||SUBSTR(SUELDO_BASE, -3)-1||SUBSTR(APPATERNO_EMP,-2)||EXTRACT(MONTH FROM SYSDATE) AS "CLAVE"
FROM EMPLEADO
ORDER BY APPATERNO_EMP ASC;

-- CASO 4

CREATE TABLE HIST_REBAJA_ARRIENDO AS
SELECT
EXTRACT(YEAR FROM SYSDATE) AS ANNO_PROCESO,
NRO_PATENTE,
VALOR_ARRIENDO_DIA AS VALOR_ARRIENDO_DIA_SR,
VALOR_GARANTIA_DIA AS VALOR_GARANTIA_DIA_SR,
EXTRACT(YEAR FROM SYSDATE)-ANIO AS ANNOS_ANTIGUEDAD,
VALOR_ARRIENDO_DIA-VALOR_ARRIENDO_DIA*(EXTRACT(YEAR FROM SYSDATE)-ANIO)/100 AS "VALOR_ARRIENDO_DIA_CR",
VALOR_GARANTIA_DIA-VALOR_GARANTIA_DIA*(EXTRACT(YEAR FROM SYSDATE)-ANIO)/100 AS "VALOR_GARANTIA_DIA_CR"
FROM CAMION
WHERE EXTRACT(YEAR FROM SYSDATE)-ANIO>5
ORDER BY ANNOS_ANTIGUEDAD DESC, NRO_PATENTE ASC;

-- CASO 5

-- Valor ajustado 2021 MULTA: 27.324

SELECT
TO_CHAR(SYSDATE, 'MM/YYYY') AS "MES_ANNO_PROCESO",
NRO_PATENTE,
FECHA_INI_ARRIENDO,
DIAS_SOLICITADOS,
FECHA_DEVOLUCION,
(FECHA_INI_ARRIENDO+DIAS_SOLICITADOS-FECHA_DEVOLUCION)*-1 AS DIAS_ATRASO,
(FECHA_INI_ARRIENDO+DIAS_SOLICITADOS-FECHA_DEVOLUCION)*-1*&MULTA_DIARIA AS VALOR_MULTA
FROM ARRIENDO_CAMION
WHERE EXTRACT(MONTH FROM FECHA_DEVOLUCION)=EXTRACT(MONTH FROM SYSDATE)-1
AND TO_CHAR(FECHA_DEVOLUCION, 'YYYY')=TO_CHAR(SYSDATE, 'YYYY')
AND FECHA_INI_ARRIENDO+DIAS_SOLICITADOS-FECHA_DEVOLUCION<0
ORDER BY FECHA_INI_ARRIENDO ASC, NRO_PATENTE ASC;

-- version profe

SELECT
TO_CHAR(SYSDATE, 'MM/YYYY') AS "MES_ANNO_PROCESO",
NRO_PATENTE,
FECHA_INI_ARRIENDO,
DIAS_SOLICITADOS,
FECHA_DEVOLUCION,
FECHA_DEVOLUCION-(FECHA_INI_ARRIENDO+DIAS_SOLICITADOS) AS DIAS_ATRASO,
(FECHA_DEVOLUCION-(FECHA_INI_ARRIENDO+DIAS_SOLICITADOS))*&MULTA_DIARIA AS VALOR_MULTA
FROM ARRIENDO_CAMION
WHERE TO_CHAR(FECHA_INI_ARRIENDO, 'MM/YYYY') = TO_CHAR(ADD_MONTHS(SYSDATE,-1),'MM/YYYY')
AND FECHA_DEVOLUCION-(FECHA_INI_ARRIENDO+DIAS_SOLICITADOS)>0
ORDER BY FECHA_INI_ARRIENDO ASC, NRO_PATENTE ASC;