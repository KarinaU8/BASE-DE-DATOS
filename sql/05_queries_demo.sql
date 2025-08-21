
-- 05_queries_demo.sql
USE tienda_abarrotes;

-- 1) Top 5 productos más vendidos
SELECT * FROM v_top_productos LIMIT 5;

-- 2) Ventas por día (últimos 7 días)
SELECT * FROM v_ventas_diarias ORDER BY fecha DESC LIMIT 7;

-- 3) Valorización de inventario (top 10)
SELECT * FROM v_valor_inventario LIMIT 10;

-- 4) Productos con stock bajo (<= 10)
SELECT id, nombre, stock FROM productos WHERE stock <= 10 ORDER BY stock ASC;

-- 5) Buscar por texto
SELECT id, nombre, precio_venta, stock FROM productos WHERE nombre LIKE '%arroz%';
