
-- 01_schema.sql
DROP DATABASE IF EXISTS tienda_abarrotes;
CREATE DATABASE tienda_abarrotes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tienda_abarrotes;

-- Tablas maestras
CREATE TABLE categorias (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL UNIQUE,
  descripcion VARCHAR(255)
);

CREATE TABLE proveedores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  razon_social VARCHAR(120) NOT NULL,
  ruc VARCHAR(20) UNIQUE,
  telefono VARCHAR(30),
  email VARCHAR(120),
  direccion VARCHAR(200)
);

CREATE TABLE productos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  sku VARCHAR(50) UNIQUE,
  id_categoria INT NOT NULL,
  id_proveedor INT NULL,
  precio_compra DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  precio_venta DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  stock INT NOT NULL DEFAULT 0,
  unidad VARCHAR(20) NOT NULL DEFAULT 'UND',
  activo TINYINT NOT NULL DEFAULT 1,
  CONSTRAINT fk_prod_cat FOREIGN KEY (id_categoria) REFERENCES categorias(id),
  CONSTRAINT fk_prod_prov FOREIGN KEY (id_proveedor) REFERENCES proveedores(id)
);

CREATE TABLE clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  doc VARCHAR(30) UNIQUE,
  telefono VARCHAR(30),
  email VARCHAR(120),
  direccion VARCHAR(200)
);

CREATE TABLE empleados (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  dni VARCHAR(15) UNIQUE,
  cargo VARCHAR(60),
  telefono VARCHAR(30),
  email VARCHAR(120)
);

-- Compras
CREATE TABLE compras (
  id INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATETIME NOT NULL DEFAULT NOW(),
  id_proveedor INT NOT NULL,
  total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  observacion VARCHAR(255),
  CONSTRAINT fk_compra_prov FOREIGN KEY (id_proveedor) REFERENCES proveedores(id)
);

CREATE TABLE detalle_compras (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_compra INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unit DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(12,2) AS (cantidad * precio_unit) STORED,
  CONSTRAINT fk_dcomp_compra FOREIGN KEY (id_compra) REFERENCES compras(id) ON DELETE CASCADE,
  CONSTRAINT fk_dcomp_prod FOREIGN KEY (id_producto) REFERENCES productos(id)
);

-- Ventas
CREATE TABLE ventas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATETIME NOT NULL DEFAULT NOW(),
  id_cliente INT NULL,
  id_empleado INT NULL,
  total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  metodo_pago VARCHAR(30) NOT NULL DEFAULT 'EFECTIVO',
  observacion VARCHAR(255),
  CONSTRAINT fk_venta_cli FOREIGN KEY (id_cliente) REFERENCES clientes(id),
  CONSTRAINT fk_venta_emp FOREIGN KEY (id_empleado) REFERENCES empleados(id)
);

CREATE TABLE detalle_ventas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_venta INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unit DECIMAL(10,2) NOT NULL,
  descuento DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  subtotal DECIMAL(12,2) AS ((cantidad * precio_unit) - descuento) STORED,
  CONSTRAINT fk_dventa_venta FOREIGN KEY (id_venta) REFERENCES ventas(id) ON DELETE CASCADE,
  CONSTRAINT fk_dventa_prod FOREIGN KEY (id_producto) REFERENCES productos(id)
);

-- Movimientos de inventario (auditoría)
CREATE TABLE kardex (
  id INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATETIME NOT NULL DEFAULT NOW(),
  id_producto INT NOT NULL,
  tipo ENUM('COMPRA','VENTA','AJUSTE') NOT NULL,
  cantidad INT NOT NULL,
  referencia VARCHAR(60),
  CONSTRAINT fk_kardex_prod FOREIGN KEY (id_producto) REFERENCES productos(id)
);

-- Índices útiles
CREATE INDEX idx_prod_nombre ON productos(nombre);
CREATE INDEX idx_detven_idventa ON detalle_ventas(id_venta);
CREATE INDEX idx_detcom_idcompra ON detalle_compras(id_compra);
