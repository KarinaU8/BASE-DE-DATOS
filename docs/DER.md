
# Diagrama Entidad-Relación +

Entidades principales:
- categorias(id, nombre, descripcion)
- proveedores(id, razon_social, ruc, telefono, email, direccion)
- productos(id, nombre, sku, id_categoria, id_proveedor, precio_compra, precio_venta, stock, unidad, activo)
- clientes(id, nombre, doc, telefono, email, direccion)
- empleados(id, nombre, dni, cargo, telefono, email)
- compras(id, fecha, id_proveedor, total, observacion)
- detalle_compras(id, id_compra, id_producto, cantidad, precio_unit, subtotal)
- ventas(id, fecha, id_cliente, id_empleado, total, metodo_pago, observacion)
- detalle_ventas(id, id_venta, id_producto, cantidad, precio_unit, descuento, subtotal)
- kardex(id, fecha, id_producto, tipo, cantidad, referencia)

Relaciones clave:
- productos N:1 categorias
- productos N:1 proveedores 
- detalle_compras N:1 compras y N:1 productos
- detalle_ventas N:1 ventas y N:1 productos
- ventas N:1 clientes  y N:1 empleados 
- kardex N:1 productos

