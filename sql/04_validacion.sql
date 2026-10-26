-- Validación: cada bloque compara la base con las cifras del reporte de Python.
-- Los valores esperados están en el comentario de cada consulta.

-- 1. Conteos de tablas (esperado: 600 / 40 / 16 / 300)
SELECT 'ventas' AS tabla, COUNT(*) FROM ventas
UNION ALL SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL SELECT 'productos', COUNT(*) FROM productos
UNION ALL SELECT 'cotizaciones', COUNT(*) FROM cotizaciones;

-- 2. Vista de detalle (esperado: 600 filas, ingreso 3958585120, margen % 19.35)
SELECT COUNT(*) AS filas,
       SUM(ingreso) AS ingreso_total,
       ROUND(100.0 * SUM(margen) / SUM(ingreso), 2) AS margen_pct
FROM vw_ventas_detalle;

-- 3. Pareto de clientes (esperado: 31 clientes, 600 pedidos, 63.2% acumulado en el top 6)
SELECT COUNT(*) AS clientes, SUM(pedidos) AS pedidos FROM vw_cliente_pareto;
SELECT pct_acumulado FROM vw_cliente_pareto WHERE ranking = 6;

-- 4. Margen por categoría (esperado: Resort 24.2, Active 21.3, Swim 14.5, Uniformes 13.4)
SELECT categoria, margen_pct FROM vw_margen_por_categoria ORDER BY margen_pct DESC;

-- 5. Ingreso mensual (esperado: 9 meses; enero 453229790; variación de febrero -21.6)
SELECT mes, ingreso, variacion_pct FROM vw_ingreso_mensual ORDER BY mes;

-- 6. Retrasos (esperado: pedidos con retraso total 77.2%; Resort 82.3%)
SELECT ROUND(100.0 * AVG(CASE WHEN retraso_dias > 0 THEN 1 ELSE 0 END), 1) AS retraso_total_pct
FROM vw_ventas_detalle;
SELECT categoria, pedidos_con_retraso_pct FROM vw_retrasos ORDER BY pedidos_con_retraso_pct DESC;

-- 7. Conversión de cotizaciones (esperado: 55.0)
SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE estado = 'Convertida') / COUNT(*), 1) AS conversion_pct
FROM cotizaciones;
