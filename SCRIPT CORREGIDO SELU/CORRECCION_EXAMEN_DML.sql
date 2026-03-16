/*  SOLO HAS COMPLETADO LA PARTE 1 */
 
DROP DATABASE IF EXISTS empresa;
CREATE DATABASE IF NOT EXISTS empresa;
USE empresa;
 
DROP TABLE IF EXISTS Historial_Laboral;
DROP TABLE IF EXISTS Historial_Salarial;
DROP TABLE IF EXISTS Trabajos;
DROP TABLE IF EXISTS Estudios;
DROP TABLE IF EXISTS Universidades;
DROP TABLE IF EXISTS Departamentos;
DROP TABLE IF EXISTS Empleados;
 
CREATE TABLE Empleados
(
DNI CHAR(9),
Nombre VARCHAR(10) NOT NULL,
Apellido1 VARCHAR(15) NOT NULL,
Apellido2 VARCHAR(15),
Direcc1 VARCHAR(25),
Direcc2 VARCHAR(20),
Ciudad VARCHAR(20),
Municipio VARCHAR(20),
Cod_Postal VARCHAR(5),
Sexo ENUM('H','M','O'),
Fecha_Nac DATE,
CONSTRAINT Empleados_DNI_pk PRIMARY KEY(DNI)
);
 
CREATE TABLE Departamentos
(
Dpto_Cod DECIMAL(5),
Nombre_Dpto VARCHAR(30) NOT NULL UNIQUE,
Jefe CHAR(9),
Presupuesto INT NOT NULL,
Pres_Actual INT,
CONSTRAINT Departamentos_Dept_Cod_pk PRIMARY KEY(Dpto_Cod),
CONSTRAINT Departamentos_Jefe_fk FOREIGN KEY (Jefe) 
REFERENCES Empleados(DNI) ON UPDATE CASCADE
);
 
CREATE TABLE Universidades
(
Univ_Cod DECIMAL(5),
Nombre_Univ VARCHAR(25) NOT NULL,
Ciudad VARCHAR(20),
Municipio VARCHAR(20),
Cod_Postal VARCHAR(5),
CONSTRAINT Universidades_Univ_Cod_pk PRIMARY KEY (Univ_Cod)
);
 
CREATE TABLE Estudios
(
Empleado_DNI CHAR(9),
Universidad DECIMAL(5) NOT NULL,
Año SMALLINT,
Grado VARCHAR(3),
Especialidad VARCHAR(20),
CONSTRAINT Estudios_Empleado_DNI_pk 
PRIMARY KEY (Empleado_DNI, Grado, Especialidad),
CONSTRAINT Estudios_Universidad_fk 
FOREIGN KEY (Universidad) REFERENCES Universidades(Univ_Cod) 
    ON UPDATE CASCADE,
CONSTRAINT Estudios_Empleado_DNI_fk 
FOREIGN KEY (Empleado_DNI) REFERENCES Empleados(DNI) 
ON UPDATE CASCADE
);
 
CREATE TABLE Trabajos
(
Codigo DECIMAL(5),
Nombre VARCHAR(20) NOT NULL,
Salario_Min DECIMAL(4) NOT NULL,
Salario_Max DECIMAL(4) NOT NULL,
CONSTRAINT Trabajos_Nombre_uu UNIQUE (Nombre),
CONSTRAINT Trabajos_Codigo_pk PRIMARY KEY(Codigo)
);
 
CREATE TABLE Historial_Laboral
(
Empleado_DNI CHAR(9),
Trabajo_Cod DECIMAL(5),
Fecha_Inicio DATE,
Fecha_Fin DATE,
Dpto_Cod DECIMAL(5),
Supervisor_DNI CHAR(9),
CONSTRAINT H_Labl_Fechas_ck 
CHECK (Fecha_Inicio<=Fecha_Fin or Fecha_Fin IS NULL),
CONSTRAINT H_Labl_Empleado_pk 
PRIMARY KEY(Empleado_DNI,Fecha_Inicio),
CONSTRAINT H_Labl_Empleado_fk 
FOREIGN KEY (Empleado_DNI) REFERENCES Empleados(DNI) 
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT H_Labl_Trabajo_Cod_fk 
FOREIGN KEY (Trabajo_Cod) REFERENCES Trabajos(Codigo) 
ON UPDATE CASCADE,
CONSTRAINT H_Labl_Dept_Cod_fk 
FOREIGN KEY (Dpto_Cod) REFERENCES Departamentos(Dpto_Cod) 
ON UPDATE CASCADE,
CONSTRAINT H_Labl_Supervisor_fk FOREIGN KEY (Supervisor_DNI) 
REFERENCES Empleados(DNI) ON UPDATE CASCADE
);
 
CREATE TABLE Historial_Salarial
(
Empleado_DNI CHAR(9),
Salario INT NOT NULL,
Fecha_Comienzo DATE,
Fecha_Fin DATE,
CONSTRAINT H_Salarial_Fechas_ck 
CHECK (Fecha_Comienzo<=Fecha_Fin OR Fecha_Fin IS NULL),
CONSTRAINT Historial_Salarial_Empleado_pk 
PRIMARY KEY(Empleado_DNI,Fecha_Comienzo),
CONSTRAINT Historial_Salarial_Empleado_fk 
FOREIGN KEY (Empleado_DNI) REFERENCES Empleados(DNI) 
ON DELETE CASCADE ON UPDATE CASCADE
);
 
CREATE INDEX trabajo_Nombre ON TRABAJOS(Nombre ASC);
CREATE INDEX empleados_Alfab ON EMPLEADOS(Apellido1 ASC,
Apellido2 ASC, Nombre ASC);
    
ALTER TABLE HISTORIAL_LABORAL ADD 
FOREIGN KEY (EMPLEADO_DNI, FECHA_INICIO) REFERENCES
HISTORIAL_SALARIAL(EMPLEADO_DNI, FECHA_COMIENZO)
ON UPDATE CASCADE ON DELETE CASCADE;
            
USE empresa;

-- ==========================================================
-- PARTE 1: INSERTAR TRABAJOS
-- ==========================================================
INSERT INTO Trabajos (Codigo, Nombre, Salario_Min, Salario_Max) VALUES
(1, 'Aux. Administrativo', 800, 1300),
(2, 'Administrativo', 1000, 1500),
(3, 'Vendedor', 1000, 2000),
(4, 'Jefe de sección', 1500, 2000),
(5, 'Jefe de departamento', 2000, 8000),
(6, 'Director general', 2500, 9999),
(7, 'CEO', 3000, 9999),
(8, 'carterista', 0, 600),
(9, 'matón', 400, 900),
(10, 'cobrador', 500, 1200),
(11, 'ejecutivo', 1500, 3000);

-- ==========================================================
-- PARTE 2.0: ENTIDADES PREVIAS (Departamentos y Universidades)
-- ==========================================================
-- Insertamos departamentos con jefe NULL inicialmente por la restricción FK
INSERT INTO Departamentos (Dpto_Cod, Nombre_Dpto, Jefe, Presupuesto) VALUES
(10, 'Cobros, Ejecuciones y Lanzamientos', NULL, 0),
(20, 'Contabilidad y Finanzas', NULL, 0),
(30, 'Dirección General', NULL, 0);

INSERT INTO Universidades (Univ_Cod, Nombre_Univ, Ciudad) VALUES
(1, 'Universidad de Chicago', 'Chicago'),
(2, 'U. Laboral Portocarrero', 'Almería');

-- ==========================================================
-- PARTE 2.1: EMPLEADOS
-- ==========================================================
INSERT INTO Empleados (DNI, Nombre, Apellido1, Apellido2, Sexo, Fecha_Nac) VALUES
('11111111-H', 'Vito', 'Corleone', NULL, 'H', '1899-08-01'),
('12345678-Z', 'Michael', 'Corleone', NULL, 'H', '1920-12-25'),
('55555555-K', 'Valeria', 'Genovesse', NULL, 'M', '1930-04-06'),
('12123123-F', 'Ichiro', 'Nakamoto', NULL, 'O', '1980-09-16'),
('45887966-E', 'Francisco', 'Guirado', 'Ruiz', 'H', '1992-09-16');

-- ==========================================================
-- PARTE 2.2: ESTUDIOS
-- ==========================================================
INSERT INTO Estudios (Empleado_DNI, Universidad, Año, Grado, Especialidad) VALUES
('12345678-Z', 1, 1942, 'GDU', 'ADE'),
('55555555-K', 1, 1953, 'GDU', 'ADE'),
('55555555-K', 2, 1948, 'CS', 'Admin y Finanzas');

-- ==========================================================
-- PARTE 2.3: HISTORIAL SALARIAL Y LABORAL
-- Nota: Debido a la FK circular entre Historial_Laboral y Salarial, 
-- debemos insertar primero en Salarial y luego en Laboral.
-- ==========================================================

-- Michael Corleone
INSERT INTO Historial_Salarial (Empleado_DNI, Salario, Fecha_Comienzo, Fecha_Fin) VALUES
('12345678-Z', 7000, '1953-01-01', NULL),
('12345678-Z', 1900, '1948-01-01', '1953-01-01'),
('12345678-Z', 1500, '1945-01-01', '1948-01-01'),
('12345678-Z', 900, '1942-01-01', '1945-01-01');

INSERT INTO Historial_Laboral (Empleado_DNI, Trabajo_Cod, Fecha_Inicio, Fecha_Fin, Dpto_Cod, Supervisor_DNI) VALUES
('12345678-Z', 5, '1953-01-01', NULL, 10, '11111111-H'),
('12345678-Z', 4, '1948-01-01', '1953-01-01', 20, '11111111-H'),
('12345678-Z', 2, '1945-01-01', '1948-01-01', 20, '11111111-H'),
('12345678-Z', 1, '1942-01-01', '1945-01-01', 20, '11111111-H');

-- Valeria Genovesse
INSERT INTO Historial_Salarial (Empleado_DNI, Salario, Fecha_Comienzo, Fecha_Fin) VALUES
('55555555-K', 4000, '1956-01-01', NULL),
('55555555-K', 1600, '1953-01-01', '1956-01-01'),
('55555555-K', 1600, '1949-01-01', '1953-01-01'),
('55555555-K', 1500, '1948-01-01', '1949-01-01');

INSERT INTO Historial_Laboral (Empleado_DNI, Trabajo_Cod, Fecha_Inicio, Fecha_Fin, Dpto_Cod, Supervisor_DNI) VALUES
('55555555-K', 5, '1956-01-01', NULL, 20, '11111111-H'),
('55555555-K', 4, '1953-01-01', '1956-01-01', 20, '12345678-Z'),
('55555555-K', 3, '1949-01-01', '1953-01-01', 20, '12345678-Z'),
('55555555-K', 2, '1948-01-01', '1949-01-01', 20, '12345678-Z');

-- Vito Corleone
INSERT INTO Historial_Salarial (Empleado_DNI, Salario, Fecha_Comienzo, Fecha_Fin) VALUES
('11111111-H', 8000, '1920-01-01', NULL),
('11111111-H', 1500, '1917-01-01', '1920-01-01'),
('11111111-H', 900, '1915-01-01', '1917-01-01');

INSERT INTO Historial_Laboral (Empleado_DNI, Trabajo_Cod, Fecha_Inicio, Fecha_Fin, Dpto_Cod, Supervisor_DNI) VALUES
('11111111-H', 7, '1920-01-01', NULL, 30, NULL),
('11111111-H', 11, '1917-01-01', '1920-01-01', 10, NULL),
('11111111-H', 10, '1915-01-01', '1917-01-01', 10, NULL);

-- Ichiro Nakamoto
INSERT INTO Historial_Salarial (Empleado_DNI, Salario, Fecha_Comienzo, Fecha_Fin) VALUES
('12123123-F', 1700, '2010-01-01', '2016-01-01'),
('12123123-F', 1600, '2000-01-01', '2010-01-01');

INSERT INTO Historial_Laboral (Empleado_DNI, Trabajo_Cod, Fecha_Inicio, Fecha_Fin, Dpto_Cod, Supervisor_DNI) VALUES
('12123123-F', 3, '2010-01-01', '2016-01-01', 20, '12345678-Z'),
('12123123-F', 2, '2000-01-01', '2010-01-01', 20, '12345678-Z');

-- Francisco Guirado Ruiz
INSERT INTO Historial_Salarial (Empleado_DNI, Salario, Fecha_Comienzo, Fecha_Fin) VALUES
('45887966-E', 1500, '2015-01-01', NULL);

INSERT INTO Historial_Laboral (Empleado_DNI, Trabajo_Cod, Fecha_Inicio, Fecha_Fin, Dpto_Cod, Supervisor_DNI) VALUES
('45887966-E', 2, '2015-01-01', NULL, 20, '12345678-Z');

-- ==========================================================
-- PARTE 3: MODIFICAR DEPARTAMENTOS
-- ==========================================================
UPDATE Departamentos 
SET Jefe = '12345678-Z', Presupuesto = 1000000 
WHERE Nombre_Dpto = 'Cobros, Ejecuciones y Lanzamientos';

UPDATE Departamentos 
SET Jefe = '55555555-K', Presupuesto = 800000 
WHERE Nombre_Dpto = 'Contabilidad y Finanzas';

-- ==========================================================
-- PARTE 4: INCREMENTO SALARIAL 15% (1948 - 1954)
-- ==========================================================
UPDATE Historial_Salarial
SET Salario = Salario * 1.15
WHERE Fecha_Comienzo >= '1948-01-01' AND (Fecha_Fin <= '1954-12-31' AND Fecha_Fin IS NOT NULL);

-- ==========================================================
-- PARTE 5: BORRAR AUX. ADMINISTRATIVOS ANTERIORES A 1948
-- ==========================================================
-- Nota: Hay que borrar de Historial_Laboral (la FK se encarga del resto si estuviera en cascada, 
-- pero aquí borramos la entrada laboral específica).
DELETE FROM Historial_Laboral
WHERE Trabajo_Cod = (SELECT Codigo FROM Trabajos WHERE Nombre = 'Aux. Administrativo')
AND Fecha_Fin < '1948-01-01';


-- Consultar el catálogo de trabajos disponibles
SELECT * FROM Trabajos;

-- Consultar la lista de empleados registrados
SELECT * FROM Empleados;

-- Consultar los departamentos (aquí verás los presupuestos y jefes actualizados)
SELECT * FROM Departamentos;

-- Consultar las universidades registradas
SELECT * FROM Universidades;

-- Consultar los títulos académicos de los empleados
SELECT * FROM Estudios;

-- Consultar el historial laboral (aquí verás que ya no existen auxiliares anteriores a 1948)
SELECT * FROM Historial_Laboral;

-- Consultar el historial de sueldos (aquí verás los sueldos con el incremento del 15% aplicado)
SELECT * FROM Historial_Salarial;