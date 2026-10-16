Use HeladeriaDb;
Go

-- NOTA: Ejecutar en orden. Las primeras consultas insertan los datos que usan las demás.

-- 1. - Ingresar proveedores
Insert Into Proveedor (Nombre, Telefono, Correo, Direccion)
Values ('Lácteos del Norte', '8181234567', 'ventas@lacteosnorte.com', 'Av. Juárez 120, Monterrey'),
       ('Frutas Selectas', '8187654321', 'contacto@frutasselectas.com', 'Calle Hidalgo 45, Apodaca');
Go

-- 2. - Ingresar insumos
Insert Into Insumo (Nombre, Unidad_Medida, Stock_Actual, Stock_Minimo, Costo_Unitario, Idproveedor)
Values ('Leche', 'Litro', 50, 10, 18.50, 1),
       ('Crema', 'Litro', 20, 5, 45.00, 1),
       ('Fresa', 'Kilo', 8, 10, 60.00, 2),
       ('Azúcar', 'Kilo', 30, 10, 25.00, Null);
Go

-- 3. - Ingresar productos
Insert Into Producto (Nombre, Categoría, Precio)
Values ('Helado de fresa', 'Helados', 45.00),
       ('Paleta de fresa', 'Paletas', 25.00),
       ('Malteada', 'Bebidas', 60.00);
Go

-- 4. - Ingresar recetas de los productos
Insert Into Receta (Idproducto, Idinsumo, Cantidad_Requerida)
Values (1, 1, 0.30),
       (1, 3, 0.15),
       (1, 4, 0.05),
       (2, 3, 0.10),
       (2, 4, 0.03),
       (3, 1, 0.40),
       (3, 2, 0.10);
Go

-- 5. - Registrar ventas
Insert Into Venta (Total, Metodo_Pago, Monto_Recibido, Cambio)
Values (90.00, 'Efectivo', 100.00, 10.00),
       (60.00, 'Tarjeta', 60.00, 0.00);
Go

-- 6. - Registrar el detalle de las ventas
Insert Into DetalleVenta (Idventa, Idproducto, Cantidad, Precio_Unitario, Subtotal)
Values (1, 1, 2, 45.00, 90.00),
       (2, 3, 1, 60.00, 60.00);
Go

-- 7. - Actualizar el precio de un producto
Update Producto
Set Precio = 50.00, Fecha_Modificacion = Getdate()
Where Idproducto = 1;
Go

-- 8. - Descontar del inventario los insumos usados en la venta 1
Update i
Set i.Stock_Actual = i.Stock_Actual - (r.Cantidad_Requerida * d.Cantidad),
    i.Fecha_Modificacion = Getdate()
From Insumo i
Inner Join Receta r On r.Idinsumo = i.Idinsumo
Inner Join DetalleVenta d On d.Idproducto = r.Idproducto
Where d.Idventa = 1;
Go

-- 9. - Desactivar un proveedor
Update Proveedor
Set Estatus = 'Inactivo', Fecha_Modificacion = Getdate()
Where Idproveedor = 2;
Go

-- 10. - Cancelar una venta
Update Venta
Set Estatus = 'Cancelada', Fecha_Modificacion = Getdate()
Where Idventa = 2;
Go

-- 11. - Eliminar el detalle de una venta cancelada
Delete From DetalleVenta
Where Idventa In (Select Idventa From Venta Where Estatus = 'Cancelada');
Go

-- 12. - Listar productos activos ordenados por precio
Select Idproducto, Nombre, Categoría, Precio
From Producto
Where Estatus = 'Activo'
Order By Precio Desc;
Go

-- 13. - Insumos con stock por debajo del mínimo
Select Nombre, Stock_Actual, Stock_Minimo
From Insumo
Where Stock_Actual < Stock_Minimo;
Go

-- 14. - Total vendido el día de hoy
Select Sum(Total) As Total_Del_Dia
From Venta
Where Cast(Fecha As Date) = Cast(Getdate() As Date)
And Estatus = 'Completada';
Go

-- 15. - Informe de ventas por método de pago
Select Metodo_Pago, Count(*) As Numero_Ventas, Sum(Total) As Total_Vendido
From Venta
Where Estatus = 'Completada'
Group By Metodo_Pago;
Go

-- 16. - Insumos con su proveedor (Inner Join)
Select i.Nombre As Insumo, p.Nombre As Proveedor
From Insumo i
Inner Join Proveedor p On i.Idproveedor = p.Idproveedor;
Go

-- 17. - Todos los insumos, incluso los que no tienen proveedor (Left Join)
Select i.Nombre As Insumo, Isnull(p.Nombre, 'Sin proveedor') As Proveedor
From Insumo i
Left Join Proveedor p On i.Idproveedor = p.Idproveedor;
Go

-- 18. - Receta completa de un producto (Join de 3 tablas)
Select pr.Nombre As Producto, i.Nombre As Insumo, r.Cantidad_Requerida, i.Unidad_Medida
From Receta r
Inner Join Producto pr On r.Idproducto = pr.Idproducto
Inner Join Insumo i On r.Idinsumo = i.Idinsumo
Where pr.Idproducto = 1;
Go

-- 19. - Ticket de una venta con sus productos (Join de 3 tablas)
Select v.Idventa, v.Fecha, p.Nombre As Producto, d.Cantidad, d.Precio_Unitario, d.Subtotal, v.Total
From Venta v
Inner Join DetalleVenta d On v.Idventa = d.Idventa
Inner Join Producto p On d.Idproducto = p.Idproducto
Where v.Idventa = 1;
Go

-- 20. - Productos más vendidos
Select Top 5 p.Nombre, Sum(d.Cantidad) As Unidades_Vendidas
From DetalleVenta d
Inner Join Producto p On d.Idproducto = p.Idproducto
Group By p.Nombre
Order By Unidades_Vendidas Desc;
Go

-- 21. - Productos que nunca se han vendido (Left Join)
Select p.Idproducto, p.Nombre
From Producto p
Left Join DetalleVenta d On p.Idproducto = d.Idproducto
Where d.Iddetalle Is Null;
Go

-- 22. - Costo de producción de cada producto
Select p.Nombre As Producto, Sum(r.Cantidad_Requerida * i.Costo_Unitario) As Costo_Produccion
From Producto p
Inner Join Receta r On p.Idproducto = r.Idproducto
Inner Join Insumo i On r.Idinsumo = i.Idinsumo
Group By p.Nombre;
Go

-- 23. - Ganancia por producto (precio menos costo)
Select p.Nombre As Producto, p.Precio,
       Sum(r.Cantidad_Requerida * i.Costo_Unitario) As Costo,
       p.Precio - Sum(r.Cantidad_Requerida * i.Costo_Unitario) As Ganancia
From Producto p
Inner Join Receta r On p.Idproducto = r.Idproducto
Inner Join Insumo i On r.Idinsumo = i.Idinsumo
Group By p.Nombre, p.Precio;
Go

-- 24. - Ventas totales por categoría de producto
Select p.Categoría, Sum(d.Subtotal) As Total_Vendido
From DetalleVenta d
Inner Join Producto p On d.Idproducto = p.Idproducto
Inner Join Venta v On d.Idventa = v.Idventa
Where v.Estatus = 'Completada'
Group By p.Categoría;
Go

-- 25. - Informe de ventas por mes
Select Year(Fecha) As Anio, Month(Fecha) As Mes, Count(*) As Numero_Ventas, Sum(Total) As Total_Vendido
From Venta
Where Estatus = 'Completada'
Group By Year(Fecha), Month(Fecha)
Order By Anio, Mes;
Go

-- 26. - Productos con 2 o más unidades vendidas (Having)
Select p.Nombre, Sum(d.Cantidad) As Unidades
From DetalleVenta d
Inner Join Producto p On d.Idproducto = p.Idproducto
Group By p.Nombre
Having Sum(d.Cantidad) >= 2;
Go

-- 27. - Productos con precio mayor al promedio (subconsulta)
Select Nombre, Precio
From Producto
Where Precio > (Select Avg(Precio) From Producto);
Go

-- 28. - Union de 3 tablas: directorio general de nombres
Select Nombre, 'Proveedor' As Tipo From Proveedor
Union
Select Nombre, 'Insumo' As Tipo From Insumo
Union
Select Nombre, 'Producto' As Tipo From Producto
Order By Tipo, Nombre;
Go

-- 29. - Union de 2 tablas: alertas del sistema
Select Nombre, 'Insumo con stock bajo' As Alerta
From Insumo
Where Stock_Actual < Stock_Minimo
Union
Select Nombre, 'Producto inactivo' As Alerta
From Producto
Where Estatus = 'Inactivo';
Go

-- 30. - Union All: resumen general del negocio
Select 'Total vendido' As Concepto, Sum(Total) As Monto
From Venta
Where Estatus = 'Completada'
Union All
Select 'Valor del inventario', Sum(Stock_Actual * Costo_Unitario)
From Insumo
Union All
Select 'Valor de productos en catálogo', Sum(Precio)
From Producto
Where Estatus = 'Activo';
Go
