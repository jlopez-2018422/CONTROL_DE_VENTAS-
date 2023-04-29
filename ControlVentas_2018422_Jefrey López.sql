/*
  Nombre: Jefrey Eduardo López Ampérez
  Carnet: 2018-422
  Código Técnico: IN5AM
  Fecha de Creación: 23-02-2022
  Fecha de Modificaión: 23-02-2022
*/
DROP DATABASE DBControlVentas_2018422;
CREATE DATABASE DBControlVentas_2018422;

USE DBControlVentas_2018422;

CREATE TABLE Productos(
	codigoProducto INT NOT NULL AUTO_INCREMENT,
    nombreProducto VARCHAR(50) NOT NULL,
    existencia INT NOT NULL,
    PRIMARY KEY PK_codigoProducto(codigoProducto)
);

CREATE TABLE Ventas(
	codigoVenta INT NOT NULL AUTO_INCREMENT,
	fechaVenta DATE NOT NULL,
    PRIMARY KEY PK_codigoVenta(codigoVenta)
);

CREATE TABLE DetalleVenta(
	codigoDetalleVenta INT NOT NULL AUTO_INCREMENT,
    codigoVenta INT NOT NULL,
    codigoProducto INT NOT NULL,
    cantidadVender INT NOT NULL,
    PRIMARY KEY PK_codigoDetalleVenta (codigoDetalleVenta),
    CONSTRAINT FK_DetalleVenta_Ventas FOREIGN KEY (codigoVenta)
		REFERENCES Ventas(codigoVenta),
	CONSTRAINT FK_DetalleVenta_Productos FOREIGN KEY(codigoProducto)
		REFERENCES Productos(codigoProducto)
    );
-- ------------------------------------------------------------------------------
CREATE TABLE Compras(
	codigoCompra INT NOT NULL AUTO_INCREMENT,
    fechaCompra DATE NOT NULL,
    PRIMARY KEY PK_CodigoCopra(CodigoCompra)
);

CREATE TABLE DetalleCompra(
    codigoDetalleCompra INT NOT NULL AUTO_INCREMENT,
    codigoCompra INT NOT NULL,
    codigoProducto INT NOT NULL,
    cantidadComprada INT NOT NULL,
    PRIMARY KEY PK_codigoDetalleCompra (codigoDetalleCompra),
    CONSTRAINT FK_DetalleCompra_Compras FOREIGN KEY (codigoCompra)
		REFERENCES Compras(codigoCompra),
	CONSTRAINT FK_DetalleCompra_Productos FOREIGN KEY(codigoProducto)
		REFERENCES Productos(codigoProducto)
    );
-- ---------------------------------------PRODUCTOS-----------------------------------------
DELIMITER $$
	CREATE PROCEDURE Sp_AgregarProducto(IN nombreProducto1 VARCHAR(50),
    IN existencia1 INT)
	BEGIN 
		INSERT INTO Productos (nombreProducto, existencia)
			VALUES(nombreProducto1, existencia1);
END$$
DELIMITER ;

CALL Sp_AgregarProducto('Televisor 50" LG', 10);
CALL Sp_AgregarProducto('Laptoop Alienware I9', 5);
CALL Sp_AgregarProducto('Lavadora Mabe de 20 kg',20);
CALL Sp_AgregarProducto('Equipo de Sonido Aiwa',7);
CALL Sp_AgregarProducto('Bocinas Boos', 3) ;

SELECT * FROM Productos;
-- ---------------------------------------VENTAS--------------------------------------------------
DELIMITER $$
CREATE PROCEDURE Sp_AgregarVenta(IN fechaVenta DATE)
	BEGIN 
		INSERT INTO Ventas(fechaVenta)
			VALUES (fechaVenta);
	END$$
DELIMITER ;

CALL Sp_AgregarVenta (now());
CALL Sp_AgregarVenta ('2020-01-01');
CALL Sp_AgregarVenta ('2018-12-01');
CALL Sp_AgregarVenta ('2010-09-11');
CALL Sp_AgregarVenta ('2003-03-01');

SELECT * FROM Ventas ;

DELIMITER $$
	CREATE TRIGGER Tr_DetalleVenta_After_Insert 
		AFTER INSERT ON DetalleVenta
        FOR EACH ROW 
        BEGIN 
			UPDATE Productos P
				SET P.existencia = P.existencia - new.cantidadVender
					WHERE codigoProducto = new.codigoProducto; 
		END$$
DELIMITER ; 

SELECT * FROM Productos;
SELECT * FROM Ventas ;
SELECT * FROM  DetalleVenta;

INSERT INTO DetalleVenta(codigoVenta, codigoProducto, cantidadVender)
	Values(2,3,3);
    
-- -----------------------------------------------COMPRAS------------------------------------------------

DELIMITER $$
CREATE PROCEDURE Sp_AgregarCompras(IN fechacomp DATE)
	BEGIN 
		INSERT INTO Compras(fechaCompra)
			VALUES (fechacomp);
	END$$
DELIMITER ;

CALL Sp_AgregarCompras (now());
CALL Sp_AgregarCompras ('2020-01-01');
CALL Sp_AgregarCompras ('2018-12-01');
CALL Sp_AgregarCompras ('2010-09-11');
CALL Sp_AgregarCompras ('2003-03-01');

DELIMITER $$
	CREATE TRIGGER Tr_DetalleCompra_After_Insert 
		AFTER INSERT ON DetalleCompra
        FOR EACH ROW 
        BEGIN 
			UPDATE Productos P
				SET P.existencia = P.existencia + new.cantidadComprada
					WHERE codigoProducto = new.codigoProducto; 
		END$$
DELIMITER ; 

		SELECT * FROM Compras ;
        SELECT * FROM Productos;
        SELECT * FROM Productos;
		SELECT * FROM  DetalleCompra; 

INSERT INTO DetalleCompra(codigoCompra, codigoProducto, cantidadComprada )
	VALUES(2,1,2);