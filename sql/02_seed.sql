
-- 02_seed.sql
USE tienda_abarrotes;

INSERT INTO categorias (nombre, descripcion) VALUES
('Bebidas', 'Gaseosas, jugos, agua'),
('Snacks', 'Galletas, papas, dulces'),
('Abarrotes', 'Arroz, azúcar, fideos, aceite'),
('Lácteos', 'Leche, yogurt, quesos'),
('Limpieza', 'Detergentes, lejía, jabones');

INSERT INTO proveedores (razon_social, ruc, telefono, email, direccion) VALUES
('Distribuidora Andina SAC', '20123456789', '999111222', 'ventas@andina.pe', 'Av. Los Proceres 123'),
('Bebidas del Sur SRL', '20654321987', '988777666', 'contacto@bdsur.com', 'Jr. Tarapacá 456');

INSERT INTO productos (nombre, sku, id_categoria, id_proveedor, precio_compra, precio_venta, stock, unidad) VALUES
('Agua 625ml', 'AG-625', 1, 2, 1.00, 1.80, 100, 'UND'),
('Gaseosa Cola 1.5L', 'COLA-15', 1, 2, 4.00, 6.50, 80, 'UND'),
('Arroz Costeño 5kg', 'AR-COS-5', 3, 1, 14.00, 19.90, 60, 'BOL'),
('Azúcar Rubia 1kg', 'AZ-R-1', 3, 1, 2.20, 3.00, 120, 'KG'),
('Fideo Spaghetti 500g', 'FD-SP-500', 3, 1, 1.50, 2.40, 90, 'PAQ'),
('Leche Entera 1L', 'LE-1L', 4, 1, 2.50, 3.80, 70, 'UND');

INSERT INTO clientes (nombre, doc, telefono, email, direccion) VALUES
('Público General', NULL, NULL, NULL, NULL),
('Juan Pérez', 'DNI 12345678', '987654321', 'juan@gmail.com', 'Av. Perú 100'),
('María Gómez', 'DNI 87654321', '912345678', 'maria@gmail.com', 'Jr. Lima 500');

INSERT INTO empleados (nombre, dni, cargo, telefono, email) VALUES
('Carlos Ruiz', '44556677', 'Cajero', '901234567', 'carlos@tienda.com'),
('Ana Torres', '55667788', 'Vendedora', '909876543', 'ana@tienda.com');

-- Compra de reposición
INSERT INTO compras (id_proveedor, total, observacion) VALUES (1, 0, 'Compra inicial');
INSERT INTO detalle_compras (id_compra, id_producto, cantidad, precio_unit) VALUES
(LAST_INSERT_ID(), 3, 20, 14.00),
(LAST_INSERT_ID(), 4, 50, 2.20),
(LAST_INSERT_ID(), 5, 40, 1.50);

-- Venta con detalle
INSERT INTO ventas (id_cliente, id_empleado, total, metodo_pago, observacion)
VALUES (1, 1, 0, 'EFECTIVO', 'Venta de prueba');
INSERT INTO detalle_ventas (id_venta, id_producto, cantidad, precio_unit, descuento) VALUES
(LAST_INSERT_ID(), 1, 2, 1.80, 0.00),
(LAST_INSERT_ID(), 6, 1, 3.80, 0.00);
