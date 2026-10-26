-- Carga de datos desde data/. Ejecutar después de 01_tablas.sql.
-- Vacía las tablas para poder volver a cargar sin duplicar filas.

TRUNCATE TABLE cotizaciones, ventas, clientes, productos;

-- Opción A (psql, desde la raíz del proyecto):
-- \copy productos    FROM 'data/productos.csv'     WITH (FORMAT csv, HEADER true)
-- \copy clientes     FROM 'data/clientes.csv'      WITH (FORMAT csv, HEADER true)
-- \copy ventas       FROM 'data/ventas.csv'        WITH (FORMAT csv, HEADER true)
-- \copy cotizaciones FROM 'data/cotizaciones.csv'  WITH (FORMAT csv, HEADER true)

-- Opción B (DBeaver: clic derecho en cada tabla → Import Data → CSV).
-- Respetar el orden: productos, clientes, ventas, cotizaciones.
