/*El número de cuenta debe ser 


  los 3 primeros dígitos del run del cliente 
+ el primer carácter del código de la TARJETA 
+ los dos siguientes dígitos del run 
+ el segundo carácter del código de la TARJETA 
+ los 3 siguientes dígitos del run 
+ el ultimo carácter del código de la TARJETA, 


	apertura de la cuenta, 
	monto solicitado, 
	tipo de la cuenta y 
	mensaje del sistema: 
		si el estado de la cuenta es ‘S’ debe responder “cuenta aceptada”, 
		caso contrario cuenta rechazada. 

La consulta debe devolver de manera automática solamente las cuentas que se gestionaron en el mes y año en que se ejecutó la sentencia 
su estado es aceptado. 

Ordenar el resultado de manera ascendente por la fecha de apertura.*/


SELECT
TO_CHAR(SYSDATE, 'MONTH YYYY') AS "FECHA SENTENCIA",

SUBSTR(TO_CHAR(RUN_CLI), 1, 3)|| --  los 3 primeros dígitos del run del cliente
SUBSTR(CAT_TARJETA, 1, 1)|| -- + el primer carácter del código de la TARJETA 
SUBSTR(TO_CHAR(RUN_CLI), 4, 2)|| -- + los dos siguientes dígitos del run 
SUBSTR(CAT_TARJETA, 2, 1)|| -- + el segundo carácter del código de la TARJETA 
SUBSTR(TO_CHAR(RUN_CLI), 6, 3)|| -- + los 3 siguientes dígitos del run 
SUBSTR(CAT_TARJETA, -1, 1) -- + el ultimo carácter del código de la TARJETA, 
AS "NRO DE CUENTA",

FECHA_APERTURA AS "APERTURA CUENTA",

TO_CHAR(MONTO_SOLICITADO, 'L999G999G999') AS "MONTO SOLICITUD CUENTA",

CASE CAT_TARJETA 
	WHEN 'VIS' THEN 'CUENTA VISTA'
	WHEN 'AHO' THEN 'CUENTA DE AHORRO'
	WHEN 'COR' THEN 'CUENTA CORRIENTE'
	WHEN 'PRE' THEN 'CUENTA PREPAGO'
END AS "TIPO DE CUENTA",

CASE ESTADO
	WHEN 'S' THEN 'CUENTA ACEPTADA'
	ELSE 'CUENTA RECHAZADA'
END AS "ESTADO CUENTA FINAL"

FROM PRODUCTO_CLIENTE

WHERE ESTADO IN('S') AND TO_CHAR(SYSDATE, 'MM/YYYY')=TO_CHAR(FECHA_APERTURA, 'MM/YYYY')

ORDER BY FECHA_APERTURA;