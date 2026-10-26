-- Vistas del proyecto. Ejecutar después de 02_carga.sql y de vw_ventas_detalle.sql.
-- Las cinco vistas basadas en ventas usan vw_ventas_detalle, así todas comparten la misma lógica.
-- ATENCIÓN: estas definiciones fueron reconstruidas. Antes de ejecutar, guarda el DDL actual
-- de cada vista (DBeaver: clic derecho → Ver DDL) por si quieres comparar.

DROP VIEW IF EXISTS vw_cliente_pareto, vw_cotizaciones_resumen, vw_ingreso_mensual,
                    vw_margen_por_categoria, vw_margen_por_referencia, vw_retrasos;

-- Clientes ordenados por ingreso, con ranking y porcentaje acumulado (Pareto).
CREATE VIEW vw_cliente_pareto AS
WITH por_cliente AS (
    SELECT cliente_id, ciudad, canal_contacto,
           COUNT(DISTINCT pedido_id) AS pedidos,
           SUM(ingreso)              AS ingreso,
           SUM(margen)               AS margen
    FROM vw_ventas_detalle
    GROUP BY cliente_id, ciudad, canal_contacto
)
SELECT
    cliente_id, ciudad, canal_contacto, pedidos, ingreso, margen,
    ROW_NUMBER() OVER (ORDER BY ingreso DESC, cliente_id)                    AS ranking,
    ROUND(100.0 * SUM(ingreso) OVER (ORDER BY ingreso DESC, cliente_id
                                     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
          / SUM(ingreso) OVER (), 1)                                         AS pct_acumulado,
    pedidos > 1                                                              AS recompra
FROM por_cliente;

-- Cotizaciones por estado y motivo de pérdida, con su porcentaje del total.
CREATE VIEW vw_cotizaciones_resumen AS
SELECT
    estado,
    motivo_perdida AS motivo,
    COUNT(*)       AS cotizaciones,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_del_total
FROM cotizaciones
GROUP BY estado, motivo_perdida;

-- Ingreso y margen por mes, con variación respecto al mes anterior.
CREATE VIEW vw_ingreso_mensual AS
WITH mensual AS (
    SELECT mes, SUM(ingreso) AS ingreso, SUM(margen) AS margen
    FROM vw_ventas_detalle
    GROUP BY mes
)
SELECT
    mes,
    ingreso,
    margen,
    ROUND(100.0 * (ingreso - LAG(ingreso) OVER (ORDER BY mes))
          / NULLIF(LAG(ingreso) OVER (ORDER BY mes), 0), 1) AS variacion_pct
FROM mensual;

-- Margen por categoría. Margen % ponderado por ingreso (margen total / ingreso total).
CREATE VIEW vw_margen_por_categoria AS
SELECT
    categoria,
    SUM(ingreso) AS ingreso,
    SUM(margen)  AS margen,
    ROUND(100.0 * SUM(margen) / NULLIF(SUM(ingreso), 0), 1) AS margen_pct
FROM vw_ventas_detalle
GROUP BY categoria;

-- Margen y devoluciones por referencia.
CREATE VIEW vw_margen_por_referencia AS
SELECT
    referencia,
    producto,
    categoria,
    SUM(cantidad)                                                   AS unidades,
    SUM(ingreso)                                                    AS ingreso,
    SUM(margen)                                                     AS margen,
    ROUND(100.0 * SUM(margen) / NULLIF(SUM(ingreso), 0), 1)         AS margen_pct,
    ROUND(100.0 * SUM(unidades_devueltas) / NULLIF(SUM(cantidad), 0), 2) AS devolucion_pct
FROM vw_ventas_detalle
GROUP BY referencia, producto, categoria;

-- Cumplimiento de plazos de producción por categoría.
CREATE VIEW vw_retrasos AS
SELECT
    categoria,
    ROUND(AVG(dias_produccion_prometidos), 1) AS dias_prometidos,
    ROUND(AVG(dias_produccion_reales), 1)     AS dias_reales,
    ROUND(AVG(retraso_dias), 1)               AS retraso_promedio,
    ROUND(100.0 * AVG(CASE WHEN retraso_dias > 0 THEN 1 ELSE 0 END), 1) AS pedidos_con_retraso_pct
FROM vw_ventas_detalle
GROUP BY categoria;
