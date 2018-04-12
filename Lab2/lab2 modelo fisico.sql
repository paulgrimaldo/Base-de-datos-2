create database preventas



create table prov
(
cprv integer not null primary key,	-- Codigo del Proveedor
nomb char(40) not null,				-- Nombre del Proveedor
ciud char(2) not null				-- Ciudad del Proveedor
);

-- Ctear la tabla de Almacenes
create table alma
(
calm integer not null primary key,	-- Codigo del Almacen
noma char(40) not null,				-- Nombre del Almacen
ciud char(2) not null				-- Ciudad del Almacen
);

-- Ctear la tabla de Productos
create table prod
(
cprd integer not null primary key,	-- Codigo Producto
nomp char(40) not null,				-- Nombre del Producto
colo char(15) not null				-- Color del Producto
);

-- Ctear la tabla de Suministro
create table sumi
(
cprv integer not null,				-- Codigo del Proveedor
calm integer not null,				-- Codigo del Almacen
cprd integer not null,				-- Codigo del Producto
ftra date not null,					-- Fecha del suministro
cant decimal(12,2) not null,		-- Cantidad suministrada del producto
prec decimal(12,2) not null,		-- Precio del Producto
impt decimal(12,2) not null,		-- Importe 
foreign key(cprv) references prov,
foreign key(calm) references alma,
foreign key(cprd) references prod
);

-- Crear la tabla de Pre-Ventas
create table pventas
( 
nvta integer not null,				-- Numero de pre venta
nomc char(40) not null,				-- nombre del cliente
calm integer not null,				-- codigo del almacen 
ftra date not null,					-- fecha de pre venta
itot decimal(12,2) not null,		-- Importe total de la pre venta
ides decimal(12,2) not null,		-- Importe descuento de la pre venta
primary key(nvta) ,
foreign key(calm) references alma
)
-- Crear la tabla de Detalle de la Pre-Ventas
create table dventas
(
nvta integer not null,					-- Numero de la pre venta
cprd integer not null,					-- codigo del producto
cant decimal(12,2) not null,			-- cantidad
prec decimal(12,2) not null,			-- precio
impt decimal(12,2) not null,			-- importe
primary key(nvta ,cprd) ,
foreign key(nvta) references pventas,
foreign key(cprd) references prod
)

-- Crear la tabla bitacora de transacciones del la Pre-Ventas

create table log_pventas
(
ntra integer identity (1,1),			-- Numero secuencial
nvta integer not null,					-- Numero de la pre venta
ftra datetime not null,					-- fecha y hora
usua char(15) not null,					-- usuario
tipo char(1) not null,					-- Tipo de operacion (I=insert, U=update,D=delete)
primary key(ntra),					
foreign key(nvta) references pventas,
)

insert into prov values(1,'PROV1','CB')
insert into prov values(2,'PROV2','LP')
insert into prov values(3,'PROV3','SC')
insert into prov values(4,'PROV4','SC')

insert into alma values(1,'ALM1','CB')
insert into alma values(2,'ALM2','SC')
insert into alma values(3,'ALM3','LP')
insert into alma values(4,'ALM3','SC')

insert into prod values(1,'PRD1','ROJO')
insert into prod values(2,'PRD2','VERDE')
insert into prod values(3,'PRD3','CAFE')
insert into prod values(4,'PRD4','ROJO')
insert into prod values(5,'PRD5','AZUL')

insert into sumi values(1,3,1,'1/1/2013',20,5,100)
insert into sumi values(1,2,1,'10/2/2013',10,5,50)
insert into sumi values(1,2,3,'10/1/2013',80,2,160)
insert into sumi values(3,2,3,'5/3/2013',10,2,20)
insert into sumi values(3,1,3,'12/4/2013',40,2,80)
insert into sumi values(1,1,1,'1/1/2012',2,4,8)
insert into sumi values(1,2,1,'02/2/2012',100,5,500)
insert into sumi values(1,2,2,'11/12/2012',40,2,80)
insert into sumi values(3,3,3,'10/3/2014',1,2,2)
insert into sumi values(3,1,2,'12/4/2014',25,2,50)
insert into sumi values(3,1,4,'12/6/2014',15,3,45)
insert into sumi values(4,4,1,'12/6/2014',10,5,50)
insert into sumi values(4,4,2,'12/6/2014',5,2,10)