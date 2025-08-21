
-- 03_views.sql
USE tienda_abarrotes;

-- Ventas por día
CREATE OR REPLACE VIEW v_ventas_diarias AS
SELECT DATE(fecha) AS fecha, SUM(total) AS total_dia, COUNT(*) AS numero_ventas
FROM ventas
GROUP BY DATE(fecha)
ORDER BY fecha DESC;

-- Top productos por unidades vendidas
CREATE OR REPLACE VIEW v_top_productos AS
SELECT p.id, p.nombre, SUM(dv.cantidad) AS unidades_vendidas
FROM detalle_ventas dv
JOIN productos p ON p.id = dv.id_producto
GROUP BY p.id, p.nombre
ORDER BY unidades_vendidas DESC;

-- Valorización de inventario (stock x precio compra)
CREATE OR REPLACE VIEW v_valor_inventario AS
SELECT p.id, p.nombre, p.stock, p.precio_compra, (p.stock * p.precio_compra) AS valor_compra
FROM productos p
ORDER BY valor_compra DESC;
