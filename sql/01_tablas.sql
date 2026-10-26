-- Esquema del proyecto. Orden: primero las tablas que no tienen claves foráneas.

create table productos (
    referencia varchar(10) primary key,
    nombre varchar(60) not null,
    categoria varchar(30) not null,
    costo_unitario integer not null check (costo_unitario > 0),
    precio_unitario integer not null check (precio_unitario > 0),
    dias_produccion_prometidos integer not null
);

create table clientes (
    cliente_id varchar(10) primary key,
    nombre varchar(60) not null,
    ciudad varchar(40),
    canal_contacto varchar(30)
);

create table ventas (
    pedido_id varchar(10) primary key,
    fecha date not null,
    cliente_id varchar(10) not null references clientes(cliente_id),
    referencia varchar(10) not null references productos(referencia),
    cantidad integer not null check (cantidad > 0),
    precio_venta_unitario integer not null,
    dias_produccion_reales integer not null,
    unidades_devueltas integer not null default 0
);

create table cotizaciones (
    cotizacion_id varchar(10) primary key,
    fecha date not null,
    cliente_id varchar(10) not null references clientes(cliente_id),
    referencia varchar(10) not null references productos(referencia),
    cantidad integer not null,
    estado varchar(15) not null check (estado in ('Convertida', 'Perdida')),
    motivo_perdida varchar(40)
);
