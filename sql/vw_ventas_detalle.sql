-- Vista de detalle de ventas: una fila por pedido, con cliente, producto y márgenes.
-- Usa JOIN (no LEFT JOIN) porque las claves foráneas garantizan que todas las ventas
-- encuentran su producto y cliente. Ingreso, costo y margen en pesos, igual que el script de Python.

DROP VIEW IF EXISTS vw_ventas_detalle;

CREATE VIEW vw_ventas_detalle AS
SELECT
    v.pedido_id,
    v.fecha,
    DATE_TRUNC('month', v.fecha)::date                                    AS mes,
    v.cliente_id,
    cl.ciudad,
    cl.canal_contacto,
    v.referencia,
    p.nombre                                                              AS producto,
    p.categoria,
    v.cantidad,
    v.precio_venta_unitario,
    p.costo_unitario,
    v.cantidad * v.precio_venta_unitario                                  AS ingreso,
    v.cantidad * p.costo_unitario                                         AS costo,
    v.cantidad * v.precio_venta_unitario - v.cantidad * p.costo_unitario  AS margen,
    v.dias_produccion_reales,
    p.dias_produccion_prometidos,
    v.dias_produccion_reales - p.dias_produccion_prometidos               AS retraso_dias,
    v.unidades_devueltas
FROM ventas v
JOIN productos p  ON p.referencia  = v.referencia
JOIN clientes  cl ON cl.cliente_id = v.cliente_id;

-- Verificación: debe devolver 600 y el ingreso total de 3.958.585.120
-- SELECT COUNT(*), SUM(ingreso) FROM vw_ventas_detalle;
