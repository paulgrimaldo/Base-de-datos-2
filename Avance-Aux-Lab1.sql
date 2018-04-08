use Demo;
-- 1. Hacer un programa que muestre en pantalla la palabra "Hola Mundo"
print 'Hola mundo';
-- 2. Hacer un programa donde declare variables de tipo Fecha, Entero, Real y Cadena, inicializarlas y mostrar su valor
DECLARE @fecha DATE;
SET @fecha = GETDATE();
print @fecha;
DECLARE @entero int;
SET @entero= 5;
print @entero;
DECLARE @real real;
SET @real = 5.4;
print @real;
DECLARE @cadena varchar(59);
SET @cadena= 'Base de datos 2 la mejor materia.'
print @cadena;
-- 3. Hacer un programa, en la que se asigne dos números a variable y muestre en otra variable la suma de los dos
DECLARE @num1 int = 4;
DECLARE @num2 int = 5;
DECLARE @suma int = @num1 + @num2;
print @suma;
-- 4. Hacer un programa que asigne en una variable su <nombre> y muestre "Hola <nombre>"
DECLARE @nombre varchar(59) = 'Paul Fernando Grimaldo Bravo';
print 'Hola '+@nombre;
-- 5. Hacer un programa que muestre la lista de productos suministrados hasta la fecha por el proveedor PRV2, la lista debe mostrar: Nro Item,Código Producto, Nombre del Producto y Cantidad, al final de la lista se debe mostrar la sumatoria de las cantidades de los productos suministrados
declare @suma decimal(12,2) = 0;
declare @item int = 0;
declare @cant decimal(12,2)
declare @cprd int;
declare @nomp varchar(40);

declare cursorp cursor for 
	Select prod.cprd, prod.nomp,sumi.cant 
	from prod, sumi , prov 
	where prod.cprd = sumi.cprd
	and prov.cprv = sumi.cprv
	and prov.nomb = 'PROV2';
	OPEN cursorp
	FETCH NEXT FROM cursorp into @cprd,@nomp,@cant
WHILE @@FETCH_STATUS=0
	BEGIN 
		set @item = @item +1;
		print CAST(@item as varchar(20)) + ','+CAST(@cprd as varchar(20)) + ','+@nomp+ ','+CAST(@cant as varchar(20))
		set @suma = @suma + @cant;
		FETCH NEXT FROM cursorp into @cprd,@nomp,@cant
	END
	close cursorp;
	deallocate cursorp;
	
	print 'Sumatoria de cantidades '+CAST(@suma as varchar(20))

-- 6. Hacer un programa que muestre la lista de productos suministrados a la ciudades de Santa Cruz y La Paz, la lista debe mostrar: Nro Item,Código Producto, Nombre del Producto, Cantidad y Precio, al final de la lista se debe mostrar la promedio de las precios de los productos suministrados
declare @suma decimal(12,2) = 0;
declare @item int = 0;
declare @cant decimal(12,2)
declare @cprd int;
declare @nomp varchar(40);
declare @precio decimal(12,2);
declare cursorp cursor for 
	Select prod.cprd, prod.nomp,sumi.cant, sumi.prec
	from prod, sumi , alma 
	where prod.cprd = sumi.cprd
	and alma.calm= sumi.calm
	and alma.ciud in ('SC','LP')
	order by prod.nomp;

	OPEN cursorp
	FETCH NEXT FROM cursorp into @cprd,@nomp,@cant,@precio
WHILE @@FETCH_STATUS=0
	BEGIN 
		set @item = @item +1;
		print CAST(@item as varchar(20)) + ','+CAST(@cprd as varchar(20)) + ','+@nomp+ ','+CAST(@cant as varchar(20))+ ','+CAST(@cant as varchar(20))
		set @suma = @suma + @precio;
		FETCH NEXT FROM cursorp into @cprd,@nomp,@cant,@precio
	END
	close cursorp;
	deallocate cursorp;
	IF(@suma !=0)
	print 'Promedio de precios'+CAST(@suma/@item as varchar(20))
	ELSE 
	print 'Promedio de precios '+CAST(0 as varchar(20))

-- 7. Hacer un programa que muestre la lista de productos suministrados por los proveedores de la ciudad de Santa Cruz a la ciudad de La Paz,  la lista debe mostrar: Nro Item,Código Producto, Nombre del Producto, Cantidad, Precio e Importe Total,  al final de la lista se debe mostrar la sumatoria de las precios de los productos suministrados
declare @suma decimal(12,2) = 0;
declare @item int = 0;
declare @cant decimal(12,2)
declare @cprd int;
declare @nomp varchar(40);
declare @precio decimal(12,2);
declare @impt decimal(12,2)
declare cursorp cursor for 
	Select prod.cprd, prod.nomp,sumi.cant, sumi.prec, sumi.impt
	from prod, sumi , alma , prov
	where prod.cprd = sumi.cprd
	and alma.calm= sumi.calm
	and prov.cprv= sumi.cprv
	and prov.ciud = 'SC'
	and alma.ciud = 'LP'
	order by prod.nomp;

	OPEN cursorp
	FETCH NEXT FROM cursorp into @cprd,@nomp,@cant,@precio,@impt
WHILE @@FETCH_STATUS=0
	BEGIN 
		set @item = @item +1;
		print CAST(@item as varchar(20)) + ','+CAST(@cprd as varchar(20)) + ','+@nomp+ ','+CAST(@cant as varchar(20))+ ','+CAST(@cant as varchar(20))+ ','+CAST(@impt as varchar(20))
		set @suma = @suma + @precio;
		FETCH NEXT FROM cursorp into @cprd,@nomp,@cant,@precio,@impt
	END
	close cursorp;
	deallocate cursorp;

	print 'Sumatoria de precios'+CAST(@suma as varchar(20))


-- 8. Hacer una funcion denominada "Suma", que reciba dos numeros y retorne la suma de ambos numeros
CREATE FUNCTION Suma(@num1 int, @num2 int) returns int
as BEGIN
	return @num1+@num2;
	END;

Select dbo.SUMA(4,5)
-- 9. Hacer una funcion denominada "GetCiudad", que reciba como parámetro el código del proveedor y retorne la ciudad donde vive el proveedor.
CREATE FUNCTION GETCIUDAD(@cprv int) returns varchar(2) 
AS BEGIN
		return (Select prov.ciud from prov where prov.cprv = @cprv); 
	END;
	select dbo.GETCIUDAD(1);
--10. Hacer una funcion denominada "GetNombre", que reciba el codigo del proveedor y retorne su nombre
CREATE FUNCTION GETNOMBRE(@cprv int) returns varchar(40) 
AS BEGIN
		return (Select prov.nomb from prov where prov.cprv = @cprv); 
	END;
	select dbo.GETNOMBRE(1);
--11. Hacer una funcion denominada "CalcularPuntos", que reciba el codigo del proveedor y calcule los puntos de bonificacion en base a los siguientes criterios:
--      Si el proveedor suministro entre 1 y 20 bs se le asigna 10 puntos.
--      Si el proveedor suministro entre 11 y 50 bs se le asigna 15 puntos.      
--      Si el proveedor suministro mas de 51 bs se le asigna 20 puntos.
	----Function hecha en clase;
--12. Hacer una funcion denominada "GetStock", que devuelva el Stock existente de un producto existente en una ciudad en particular.
	CREATE FUNCTION GetStock(@cprd int, @ciud varchar(2)) returns decimal(12,2)
	AS 
		BEGIN
			return (Select SUM(cant) from sumi,alma where sumi.calm = alma.calm  and sumi.cprd = @cprd 
			and alma.ciud = @ciud)
		END;
	select dbo.GETSTOCK(1,'LP')	
--13. Hacer una funcion denominada "GetInven", que devuelva el Inventario Valorado de un producto.
	CREATE FUNCTION GetInven(@cprd int) returns decimal(12,2)
	AS 
		BEGIN 
			return (Select SUM(sumi.cant * sumi.prec) from sumi where cprd = @cprd);
		END;
--14. Hacer una funcion denominada "GetProdxCiud", que devuelva en una tabla los Productos existentes en una ciudad en particular
	CREATE FUNCTION GetProdxCiud(@ciud varchar(2)) returns table 
	AS return (Select prod.* from prod,sumi,alma
	where sumi.cprd=prod.cprd and sumi.calm = alma.calm and alma.ciud = @ciud);
--15. Hacer una funcion denominada "GetProvxProd", que devuelva en una tabla los Proveedores que suministraron algún Producto
	create function GetProvxProd() returns table 
	as return (select prov.* from prov where exists (select sumi.* from sumi where sumi.cprv = prov.cprv));
--16. Hacer una funcion denominada "GetProvNoSumi", que devuelva en una tabla los Proveedores que todavía no suministraron productos.
	-- Tarea en clases.
--17. Hacer una funcion denominada "GetProvSumi", que devuelva en una tabla los nombres de los proveedores que suministraron algún producto color rojo
--18. Hacer una funcion denominada "GetProdxProv", que devuelva en una tabla productos existente en un almacen y que fueron suministrado por un proveedor en particular
--19. Hacer una funcion denominada "GetProdxColor", que devuelva en una tabla productos de color amarillo suministrados por un proveedor
--20. Hacer una funcion denominada "GetProvTodo", que devuelva en una tabla los nombres de los proveedores que suministraron todos los productos.
		CREATE FUNCTION GetProvTodo() returns table as 
		return (select prov.* from prov where (select count(distinct cprd)
		from sumi
		where sumi.cprv = prov.cprv) = (select count(*)
										from prod));
		select * from GetProvTodo()

--21. Hacer una funcion denominada "GetProvOutCiud", que devuelva en una tabla los nombres de los proveedores que suministraron algún producto fuera de su ciudad.
	--Tarea en clases. 
--23. Hacer una funcion denominada "GetMaxCantxCiud", que devuelva la cantidad más alta suministrada de un producto en una ciudad en particular.
--24. Hacer una funcion denominada "GetUltFecxProv", que devuelva la ultima fecha que se suministró un producto por un proveedor en particular.
		CREATE FUNCTION GetUltFecxProv(@cprv int) returns date 
		as BEGIN
				return (select  TOP 1 sumi.ftra from sumi 
					where sumi.cprv = @cprv
					order by sumi.ftra desc
				)
			END;

			select dbo.GetUltFecxProv(3);
--25. Hacer una funcion denominada "GetPrimFecxColor", que devuelva la en qué fecha por primera vez suministró algún producto de color Rojo.
--26. Hacer una funcion denominada "GetPromxProv", que devuelva el importe promedio de productos suministrados por un proveedor.
		create function GetPromxProv(@cprv int) returns decimal(12,2)
		as begin 
			return (select AVG(sumi.impt) from sumi where sumi.cprv = @cprv)
		end ;
		select dbo.GetPromxProv(1);
--27. Hacer un programa que muestre la lista de productos suministrados por un proveedor cuyos importes superen a 10 Bs, la lista debe mostrar: Nro Item, Código del Producto, Nombre del Producto, Fecha, Cantidad, Precio e Importe, al final de la lista se debe mostrar el descuento equivale al 10% del Importe total, siempre y cuando la sumatoria de los importes de los productos suministrados sea mayor 20.
--28. Hacer un programa que muestre la lista con el importe promedio de cada productos suministrado, la lista debe mostrar: Nro Item,Código Producto, Nombre del Producto y Promedio.


declare @item int = 0;
declare @cprd int;
declare @nomp varchar(40);
declare @cant int =0;
declare @impt decimal(12,2);
declare cursorp cursor for 
	Select distinct prod.cprd, prod.nomp 
	from sumi,prod where sumi.cprd = prod.cprd;

	OPEN cursorp
	FETCH NEXT FROM cursorp into @cprd,@nomp
WHILE @@FETCH_STATUS=0
	BEGIN 
		set @item = @item +1;
		
		set @cant = (select COUNT(*) from sumi where sumi.cprd = @cprd);
		set @impt = (select AVG(sumi.impt ) from sumi where  sumi.cprd = @cprd);

		print CAST(@item as varchar(20)) + ','+CAST(@cprd as varchar(20)) + ','+@nomp+ ','+CAST(@cant as varchar(20))+ ','+CAST(@impt as varchar(20))
		
		FETCH NEXT FROM cursorp into @cprd,@nomp
	END
	close cursorp;
	deallocate cursorp;
	
--29. Hacer un programa que muestre la lista con el Stock existente de cada producto existente en la ciudad de Santa Cruz, la lista debe mostrar: Nro Item,Código Producto, Nombre del Producto y Stock.
--30. Hacer un programa que muestre la lista con el Inventario Valorado existente por cada almacén. la lista debe mostrar:Nro Item,Código Almacen, Nombre del Almacen y Importe.
declare @item int = 0;
declare @calm int;
declare @nomalm varchar(40);
declare @impt decimal(12,2);
declare cursorp cursor for 
	Select distinct alma.calm, alma.noma 
	from alma,sumi where alma.calm = sumi.calm;

	OPEN cursorp
	FETCH NEXT FROM cursorp into @calm,@nomalm
WHILE @@FETCH_STATUS=0
	BEGIN 
		set @item = @item +1;
		

		set @impt = (select SUM(sumi.cant * sumi.prec) from sumi where  sumi.calm = @calm);

		print CAST(@item as varchar(20)) + ','+CAST(@calm as varchar(20)) + ','+@nomalm+ ','+CAST(@impt as varchar(20))
		
		FETCH NEXT FROM cursorp into @calm,@nomalm
	END
	close cursorp;
	deallocate cursorp;	
--31. Hacer un programa que muestre la lista con las cantidades más alta suministrada de cada producto en la ciudad de La Paz, siempre que la cantidad total de cada producto supere a 20, la lista debe mostrar: Nro Item,Código Producto, Nombre del Producto y CantidaAlta. 
--32. Hacer un programa que muestre la lista con las últimas fechas de cada producto suministrada por el proveedor PRV3, la lista debe mostrar: Nro Item,Código Producto, Nombre del Producto y UltimaFecha.
declare @item int = 0;
declare @cprd int;
declare @nomp varchar(40);
declare @fecha date;
declare cursorp cursor for 
	Select prod.cprd, prod.nomp , MAX(sumi.ftra) as fecha
	from prod, sumi , prov	
	where sumi.cprd = prod.cprd and sumi.cprv = prov.cprv
	and prov.nomb = 'PROV3'
	group by prod.cprd, prod.nomp;


	OPEN cursorp
	FETCH NEXT FROM cursorp into @cprd,@nomp,@fecha
WHILE @@FETCH_STATUS=0
	BEGIN 
		set @item = @item +1;
		


		print CAST(@item as varchar(20)) + ','+CAST(@cprd as varchar(20)) + ','+@nomp+ ','+CAST(@fecha as varchar(20));
		
		FETCH NEXT FROM cursorp into @cprd,@nomp,@fecha
	END
	close cursorp;
	deallocate cursorp;

--33. Hacer un programa que muestre la lista con las fechas que por primera vez un proveedor suministró algún producto, la lista debe mostrar: Nro Item,Código Producto, Nombre del Producto y PrimeraFecha. 
