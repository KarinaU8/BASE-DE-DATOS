
# 🛒 Tienda de Abarrotes – Base de Datos (MySQL)

Proyecto académico listo para subir a GitHub. Incluye esquema SQL, datos de ejemplo, vistas, triggers y procedimientos para gestionar una **tienda de abarrotes** (categorías, productos, proveedores, compras, inventario, ventas, clientes, empleados).

## 📂 Estructura
```
sql/
  01_schema.sql
  02_seed.sql
  03_views.sql
  04_procedures_triggers.sql
  05_queries_demo.sql
docs/
  DER.md
diagrams/
  er_diagram.mmd
scripts/
  setup_mysql.sql
.gitignore
LICENSE
README.md
```

## 🚀 Requisitos
- MySQL 8.x (recomendado) o MariaDB 10.5+
- Usuario con privilegios para crear base de datos

## ▶️ Instalación rápida
```bash
# 1) Crear DB y cargar todo
mysql -u root -p < scripts/setup_mysql.sql

# 2) (Opcional) Cargar por partes
mysql -u root -p < sql/01_schema.sql
mysql -u root -p < sql/02_seed.sql
mysql -u root -p < sql/03_views.sql
mysql -u root -p < sql/04_procedures_triggers.sql
mysql -u root -p < sql/05_queries_demo.sql
```

## ✨ Funcionalidades
- Gestión de **productos** con **categorías** y **proveedores**
- **Compras** y **ventas** con detalle y **actualización automática de stock** vía triggers
- **Clientes** y **empleados**
- Vistas para **ventas diarias**, **top productos**, **valorización de inventario**
- Procedimientos `registrar_compra` y `registrar_venta`

## 🧪 Datos de ejemplo
Se incluyen categorías, productos, proveedores, clientes, empleados, compras y ventas de prueba.

## 🔐 Nota
Este proyecto no incluye UI ni backend; es un esquema de BD con utilitarios para pruebas y aprendizaje.
