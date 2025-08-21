
-- 04_procedures_triggers.sql
USE tienda_abarrotes;
DELIMITER $$

-- Actualiza totales de cabecera
CREATE PROCEDURE recalcular_total_compra(IN p_id_compra INT)
BEGIN
  UPDATE compras c
  JOIN (
    SELECT id_compra, IFNULL(SUM(subtotal),0) AS suma FROM detalle_compras WHERE id_compra = p_id_compra
  ) s ON s.id_compra = c.id
  SET c.total = s.suma;
END$$

CREATE PROCEDURE recalcular_total_venta(IN p_id_venta INT)
BEGIN
  UPDATE ventas v
  JOIN (
    SELECT id_venta, IFNULL(SUM(subtotal),0) AS suma FROM detalle_ventas WHERE id_venta = p_id_venta
  ) s ON s.id_venta = v.id
  SET v.total = s.suma;
END$$

-- Registrar compra y actualizar stock
CREATE PROCEDURE registrar_compra(
  IN p_id_proveedor INT,
  IN p_id_producto INT,
  IN p_cantidad INT,
  IN p_precio_unit DECIMAL(10,2)
)
BEGIN
  DECLARE v_id_compra INT;
  INSERT INTO compras(id_proveedor, total, observacion) VALUES (p_id_proveedor, 0, 'Compra SP');
  SET v_id_compra = LAST_INSERT_ID();
  INSERT INTO detalle_compras(id_compra, id_producto, cantidad, precio_unit)
  VALUES (v_id_compra, p_id_producto, p_cantidad, p_precio_unit);
  CALL recalcular_total_compra(v_id_compra);

  -- stock y kardex
  UPDATE productos SET stock = stock + p_cantidad, precio_compra = p_precio_unit WHERE id = p_id_producto;
  INSERT INTO kardex(id_producto, tipo, cantidad, referencia) VALUES (p_id_producto, 'COMPRA', p_cantidad, CONCAT('C#', v_id_compra));
END$$

-- Registrar venta y actualizar stock
CREATE PROCEDURE registrar_venta(
  IN p_id_cliente INT,
  IN p_id_empleado INT,
  IN p_id_producto INT,
  IN p_cantidad INT,
  IN p_precio_unit DECIMAL(10,2),
  IN p_descuento DECIMAL(10,2)
)
BEGIN
  DECLARE v_id_venta INT;
  -- Valida stock
  IF (SELECT stock FROM productos WHERE id = p_id_producto) < p_cantidad THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
  END IF;

  INSERT INTO ventas(id_cliente, id_empleado, total, metodo_pago, observacion)
  VALUES (p_id_cliente, p_id_empleado, 0, 'EFECTIVO', 'Venta SP');
  SET v_id_venta = LAST_INSERT_ID();

  INSERT INTO detalle_ventas(id_venta, id_producto, cantidad, precio_unit, descuento)
  VALUES (v_id_venta, p_id_producto, p_cantidad, p_precio_unit, p_descuento);
  CALL recalcular_total_venta(v_id_venta);

  -- stock y kardex
  UPDATE productos SET stock = stock - p_cantidad WHERE id = p_id_producto;
  INSERT INTO kardex(id_producto, tipo, cantidad, referencia) VALUES (p_id_producto, 'VENTA', p_cantidad, CONCAT('V#', v_id_venta));
END$$

-- Triggers para actualizar totales y kardex en inserciones manuales
CREATE TRIGGER trg_detcomp_ai AFTER INSERT ON detalle_compras
FOR EACH ROW
BEGIN
  CALL recalcular_total_compra(NEW.id_compra);
  UPDATE productos SET stock = stock + NEW.cantidad, precio_compra = NEW.precio_unit WHERE id = NEW.id_producto;
  INSERT INTO kardex(id_producto, tipo, cantidad, referencia) VALUES (NEW.id_producto, 'COMPRA', NEW.cantidad, CONCAT('C#', NEW.id_compra));
END$$

CREATE TRIGGER trg_detven_ai AFTER INSERT ON detalle_ventas
FOR EACH ROW
BEGIN
  IF (SELECT stock FROM productos WHERE id = NEW.id_producto) < NEW.cantidad THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
  END IF;
  CALL recalcular_total_venta(NEW.id_venta);
  UPDATE productos SET stock = stock - NEW.cantidad WHERE id = NEW.id_producto;
  INSERT INTO kardex(id_producto, tipo, cantidad, referencia) VALUES (NEW.id_producto, 'VENTA', NEW.cantidad, CONCAT('V#', NEW.id_venta));
END$$
DELIMITER ;
