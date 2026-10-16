Create Database HeladeriaDb;
Go

Use HeladeriaDb;
Go

-- 1. Tabla Proveedor
Create Table Proveedor (
    Idproveedor Int Identity(1,1) Primary Key,
    Nombre Varchar(150) Not Null,
    Telefono Varchar(50),
    Correo Varchar(100),
    Direccion Varchar(255),
    Fecha_Creacion Datetime Not Null Default Getdate(),
    Fecha_Modificacion Datetime,
    Estatus Varchar(50) Not Null Default 'Activo'
);
Go

-- 2. Tabla Insumo
Create Table Insumo (
    Idinsumo Int Identity(1,1) Primary Key,
    Nombre Varchar(150) Not Null,
    Unidad_Medida Varchar(50) Not Null,
    Stock_Actual Decimal(10,2) Not Null Default 0,
    Stock_Minimo Decimal(10,2) Not Null Default 0,
    Costo_Unitario Decimal(10,2) Not Null Default 0,
    Idproveedor Int,
    Fecha_Creacion Datetime Not Null Default Getdate(),
    Fecha_Modificacion Datetime,
    Estatus Varchar(50) Not Null Default 'Activo',
    Constraint Fk_Insumo_Proveedor Foreign Key (Idproveedor) References Proveedor(Idproveedor)
);
Go

-- 3. Tabla Producto
Create Table Producto (
    Idproducto Int Identity(1,1) Primary Key,
    Nombre Varchar(150) Not Null,
    Categoría Varchar(100) Not Null,
    Precio Decimal(10,2) Not Null,
    Estado Bit Not Null Default 1,
    Fecha_Creacion Datetime Not Null Default Getdate(),
    Fecha_Modificacion Datetime,
    Estatus Varchar(50) Not Null Default 'Activo'
);
Go

-- 4. Tabla Receta
Create Table Receta (
    Idreceta Int Identity(1,1) Primary Key,
    Idproducto Int Not Null,
    Idinsumo Int Not Null,
    Cantidad_Requerida Decimal(10,2) Not Null,
    Fecha_Creacion Datetime Not Null Default Getdate(),
    Fecha_Modificacion Datetime,
    Estatus Varchar(50) Not Null Default 'Activo',
    Constraint Fk_Receta_Producto Foreign Key (Idproducto) References Producto(Idproducto),
    Constraint Fk_Receta_Insumo Foreign Key (Idinsumo) References Insumo(Idinsumo)
);
Go

-- 5. Tabla Venta
Create Table Venta (
    Idventa Int Identity(1,1) Primary Key,
    Fecha Datetime Not Null Default Getdate(),
    Total Decimal(10,2) Not Null,
    Metodo_Pago Varchar(50) Not Null,
    Monto_Recibido Decimal(10,2) Not Null,
    Cambio Decimal(10,2) Not Null,
    Fecha_Creacion Datetime Not Null Default Getdate(),
    Fecha_Modificacion Datetime,
    Estatus Varchar(50) Not Null Default 'Completada'
);
Go

-- 6. Tabla DetalleVenta
Create Table DetalleVenta (
    Iddetalle Int Identity(1,1) Primary Key,
    Idventa Int Not Null,
    Idproducto Int Not Null,
    Cantidad Int Not Null,
    Precio_Unitario Decimal(10,2) Not Null,
    Subtotal Decimal(10,2) Not Null,
    Fecha_Creacion Datetime Not Null Default Getdate(),
    Fecha_Modificacion Datetime,
    Estatus Varchar(50) Not Null Default 'Activo',
    Constraint Fk_DetalleVenta_Venta Foreign Key (Idventa) References Venta(Idventa),
    Constraint Fk_DetalleVenta_Producto Foreign Key (Idproducto) References Producto(Idproducto)
);
Go
