# Análisis comercial y operativo · Tulum

Proyecto demostrativo de análisis de ventas, margen y cumplimiento de producción, con **Python (pandas)**, **PostgreSQL** y **Power BI**. Los datos son **simulados**.

## Problema de negocio

Tulum necesita entender qué productos y categorías dejan más margen, qué clientes compran con frecuencia y dónde se incumplen los plazos de producción. Este proyecto convierte los datos de ventas, productos, clientes y cotizaciones en indicadores para tomar decisiones.

## Preguntas que responde

1. ¿Qué categorías y referencias generan más margen?
2. ¿Cómo evolucionan los ingresos mes a mes?
3. ¿Qué clientes concentran el ingreso y cuántos recompran?
4. ¿En qué categorías se incumple más el plazo de producción?
5. ¿Qué canales de contacto generan más ingreso?
6. ¿Por qué se pierden cotizaciones?

## Estructura

```
tulum-analisis-comercial/
├── data/                  # CSV de entrada y reporte Excel generado
│   ├── ventas.csv
│   ├── productos.csv
│   ├── clientes.csv
│   ├── cotizaciones.csv
│   └── reporte_tulum.xlsx # salida de generar_reporte.py
├── powerbi/               # Dashboard de Power BI (DATOSTULUM.pbix)
├── sql/                   # Consultas SQL (PostgreSQL)
├── docs/                  # Documentación adicional
├── assets/                # Imágenes para el README y la presentación
├── generar_reporte.py     # Limpieza, cálculo de indicadores y exportación a Excel
└── requirements.txt       # Dependencias de Python
```

## Cómo ejecutarlo

Requiere Python 3.10 o superior.

```bash
pip install -r requirements.txt
python generar_reporte.py
```

El script puede ejecutarse desde cualquier carpeta; siempre lee `data/` relativo a su propia ubicación y escribe `data/reporte_tulum.xlsx`.

## Qué hace `generar_reporte.py`

1. **Carga** las cuatro tablas y normaliza los nombres de columna (minúsculas, sin espacios).
2. **Une** ventas con productos y clientes. Si alguna venta no encuentra su producto o cliente, el script se detiene con un error en lugar de perder filas en silencio.
3. **Calcula** los indicadores:
   - `ingreso = cantidad × precio_venta_unitario`
   - `costo = cantidad × costo_unitario`
   - `margen = ingreso − costo`
   - `retraso_dias = días reales de producción − días prometidos`
4. **Agrupa** por referencia, categoría, mes, cliente, canal y motivo de pérdida de cotización.
5. **Exporta** nueve hojas de análisis más una hoja `Controles` con filas, nulos y duplicados por tabla.

## Definiciones

| Indicador | Cálculo |
|---|---|
| Margen % | Margen total ÷ ingreso total. Es un promedio ponderado por ingreso, no un promedio simple de los márgenes por categoría. |
| Pedidos | Pedidos únicos (`pedido_id`). |
| Pedidos con retraso % | Pedidos con días reales de producción mayores a los prometidos. |
| Clientes que recompran % | Clientes con más de un pedido ÷ clientes activos. |
| Conversión de cotizaciones % | Cotizaciones en estado *Convertida* ÷ total de cotizaciones. |

**Limitación:** el margen solo considera el costo unitario del producto. No incluye otros gastos, devoluciones ni ajustes.

## Resultados principales (datos simulados, ene–sep 2026)

- Ingreso total: **$3.958 M COP**
- Margen total: **19,35%**
- Pedidos: **600** de **31** clientes activos
- Pedidos con retraso: **77,2%**
- Resort tiene el mayor margen por categoría (24,17%) y también el mayor porcentaje de pedidos con retraso (82,3%).

## Dashboard de Power BI

El archivo `powerbi/DATOSTULUM.pbix` contiene el tablero con KPIs, filtros por fecha, categoría y canal, y gráficos por categoría, producto y mes. Las medidas principales son *Ingreso Total*, *Margen Total*, *Margen %*, *Total Pedidos*, *Pedidos con Retraso* y *Pedidos con Retraso %*.

## Próximos pasos

- Cruzar los retrasos con fechas de producción, proveedor o tipo de producto para entender sus causas.
- Analizar por qué las cotizaciones se pierden (`Cotizaciones_perdidas`).
- Migrar las consultas de limpieza a PostgreSQL y conectar Power BI directamente a la base.
