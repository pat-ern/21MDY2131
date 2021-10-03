-- consulta de toda la tabla

SELECT * 
FROM empleado; 

-- consulta de algunas columnas de la tabla

SELECT
nombre_emp, appaterno_emp, apmaterno_emp
FROM empleado;

-- concatenación de nombres de columnas

SELECT
nombre_emp||appaterno_emp||apmaterno_emp
FROM empleado;

-- columnas con alias

SELECT
nombre_emp||appaterno_emp||apmaterno_emp AS NOMBRE_COMPLETO
FROM empleado;

-- sin clausula AS

SELECT
nombre_emp||appaterno_emp||apmaterno_emp NOMBRE_COMPLETO
FROM empleado;

-- opción sin salto de línea en sentencias breves

SELECT
nombre_emp||appaterno_emp||apmaterno_emp NOMBRE_COMPLETO FROM empleado;

-- alias de columnas con espacio

SELECT
nombre_emp||appaterno_emp||apmaterno_emp "NOMBRE COMPLETO"
FROM empleado;

-- nombres con espacios; concatenando un espacio (valor literal)

SELECT
nombre_emp||' '||appaterno_emp||' '||apmaterno_emp "NOMBRE COMPLETO"
FROM empleado;

-- con otros valores literales requeridos

SELECT
'El empleado '||nombre_emp||' '||appaterno_emp||' '||apmaterno_emp||' '||' nació el '|| to_char(FECNAC_EMP, 'dd/mm/yyyy' "NOMBRE COMPLETO"
FROM empleado;

/*

con funcion to_char donde:

to_char(arg1, arg2)
arg1=columna
arg2=mascara

*/

-- ej

to_char(sysdate,"dd/month/yyyy")


SELECT
'El empleado '||NOMBRE_EMP||' '||APPATERNO_EMP||' '||APMATERNO_EMP||' nació el '||to_char(FECNAC_EMP, 'DD/MM/YYYY') "NOMBRE COMPLETO"
FROM EMPLEADO;

--- order by

ORDER BY nombre_emp 

--

ORDER BY fecnac_emp, appaterno_emp;

-- finalmente

SELECT
'El empleado '||NOMBRE_EMP||' '||APPATERNO_EMP||' '||APMATERNO_EMP||' nació el '||to_char(FECNAC_EMP, 'DD/MM/YYYY') "NOMBRE COMPLETO"
FROM EMPLEADO
ORDER BY FECNAC_EMP, APPATERNO_EMP;


--- script compartidos por el profe

SELECT
NOMBRE_EMP, APPATERNO_EMP, APMATERNO_EMP
FROM EMPLEADO;


SELECT
NOMBRE_EMP||APPATERNO_EMP||APMATERNO_EMP AS NOMBRE_COMPLETO
FROM EMPLEADO;

SELECT 
NOMBRE_EMP||APPATERNO_EMP||APMATERNO_EMP NOMBRE_COMPLETO 
FROM EMPLEADO;

SELECT 
'El empleado '||NOMBRE_EMP||' '||APPATERNO_EMP||' '||APMATERNO_EMP||' nació el '||FECNAC_EMP "NOMBRE COMPLETO" 
FROM EMPLEADO;

SELECT 
'El empleado '||NOMBRE_EMP||' '||APPATERNO_EMP||' '||APMATERNO_EMP||
' nació el '||to_char(FECNAC_EMP,'DD/MM/YYYY') "NOMBRE COMPLETO" 
FROM EMPLEADO
ORDER BY FECNAC_EMP ASC, APPATERNO_EMP ASC;

-- TAREA: 1_1_4
-- concatenar y en caso de null mostrar literal "sin celular"