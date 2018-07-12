use preventas;
--1. Hacer un PA denominado PA_Setear, donde declare  variables de tipo Fecha, Entero, Real y Cadena, inicializarlas y mostrar su valor
CREATE procedure PA_Setear as 
BEGIN
	DECLARE  @fecha date;
	DECLARE  @entero int;
	DECLARE  @real real;
	DECLARE  @cadena varchar(29);
	
	SET  @fecha =  GETDATE();
	SET @entero = 10;
	SET @real = 4.35;
	SET @cadena = 'Base de datos 2';
	
	print @fecha;
	print @entero;
	print @real;
	print @cadena;
	
END 
	EXEC PA_Setear;
--2. Hacer un PA denominado PA_Igual, en la que se le pasan 2 números y retorne 1 si son iguales, 0 si no lo son
CREATE procedure PA_Igual (@num1 int, @num2 int, @result int output) AS 
BEGIN
	IF(@num1 = @num2)  
		BEGIN
			SELECT @result = 1;
		END
	ELSE 
		BEGIN 
			SELECT @result = 0;
		END	
END 

DECLARE @result int
EXEC PA_Igual 1,5,@result output 
PRINT @result
--3. Hacer un PA denominado PA_Nombre, que reciba como parámetro su <nombre> y muestre un mensaje "Hola <nombre>"
CREATE Procedure PA_Nombre (@nombre varchar(20)) AS 
BEGIN 
	print 'Hola ' + @nombre
END 
EXEC PA_Nombre 'Paul Grimaldo'
--4. Hacer un PA denominado PA_GetProv, que reciba como parámetro el código del proveedor y retorne la ciudad donde vive el proveedor.
Create procedure PA_GetProv(@cpv int,@ciud varchar(2) output) AS 
BEGIN 
	SET @ciud = (SElect ciud from prov where prov.cprv = @cpv);
END

DECLARE @ciud varchar(2);
EXEC PA_GetProv 2,@ciud output 
print @ciud
--5. Hacer un PA denominado PA_ExisteProducto, que reciba como parámetro el código del producto y retorne 1 si existe el producto de lo contrario retorne 0.
CREATE procedure PA_ExisteProducto(@cprd int, @result int output) AS
BEGIN 
	IF EXISTS ( SELECT cprd from prod where cprd = @cprd)
		BEGIn
			SET @result = 1; 
		END  
	ElSE 
		BEGIN 
			SET @result = 0; 
		END 
END
declare @RESULT INT;
EXEC PA_ExisteProducto 6,@RESULT output 
print @RESULT
--6. Hacer un PA denominado PA_LeerProducto, que reciba como parámetro el código del producto y retorne  nombre y el color del producto si el código del producto introducido es valido, de lo contrario debe retornar nulo para ambos casos.
CREATE procedure PA_LeerProducto(@cprd int, @nombre varchar(40) output, @color varchar(15) output ) as 
BEGIN 
IF EXISTS ( SELECT cprd from prod where cprd = @cprd)
		BEGIn
			SET @nombre =  (SELECT nomp from prod where cprd = @cprd ) ; 
			SET @color =  (SELECT colo from prod where cprd = @cprd ) ;
		END  
	ElSE 
		BEGIN 
			SET @nombre =  null;
			SET @color =  null;
		END 
	
END 

DECLARE @nomp varchar(40);
DECLARE @colorp varchar(15);
EXEc PA_LeerProducto 1,@nomp output,@colorp output
print @nomp
print @colorp

--7. Hacer un PA denominado PA_TotalStock que reciba como parámetro el código del producto y retorne el TotalStock existente del producto. (El stock es la sumatoria de cantidades suministrada del producto).
CREATE procedure PA_TotalStock(@cprd int, @TotalStock decimal(12,2) output) as 
begin
	SET @TotalStock = (Select SuM(cant) from sumi where sumi.cprd = @cprd); 
end  
declare @totalStock int;
EXEC PA_TotalStock 1,@totalStock output;
print @totalStock
--8. Hacer un PA denominado PA_HayStock que reciba como parámetro el código del producto y que retorne 1 si hay Stock disponible, de lo contrario que retorne 0. 
CREATE procedure PA_HayStock(@cprd int, @result int output) as 
begin
	SET @result = 0;
	IF  (Select SuM(cant) from sumi where sumi.cprd = @cprd) >0 
		BEGIN 
			SET @result = 1;
		END 
end
declare @r int;
exec PA_HayStock 10,@r output
print @r
--9. Hacer un PA denominado PA_StockxAlmacen que reciba el código del producto y el código del almacén, y que retorne el Stock existente del producto en el almacén. (El stock es la sumatoria de cantidades suministrada del producto en un determinado almacén).
alter procedure PA_StockxAlmacen( @cprd int, @calm int , @stock decimal(12,2) output) as 
begin 
	if(select sum(cant) from sumi where cprd = @cprd and calm =@calm)>0
		begin
			set @stock = (select sum(cant) from sumi where cprd = @cprd and calm =@calm );
		end	
	else 
		set @stock = 0 ;
end 
declare @stock decimal(12,2);
exec PA_StockxAlmacen 2,4,@stock output
print @stock
--10. HAcer un PA denominado PA_HayStockxAlmacen que reciba como parámetro el código del producto y el código del almacén, y que retorne 1 si hay Stock disponible del producto en esa ciudad, de lo contrario que retorne 0.  (usar PA_StockxAlmacen)
create procedure PA_HayStockxAlmacen(@cprd int, @calm int , @result decimal(12,2) output) as
begin
	set @result = 0;
	declare @stock decimal(12,2);
	exec PA_StockxAlmacen @cprd,@calm,@stock output
	IF(@stock >0)
		begin 
			set @result = 1;
		end 
end 
declare @result int;
exec PA_HayStockxAlmacen 2,4,@result output
print @result
--11. Hacer un denominado PA_ValidarPreVenta, que reciba el Numero de Venta y que retorne 1 si todos los productos de la Pre Venta cuenta con Stock suficiente, de lo contrario retorna 0. (PA_StockxAlmacen).  Se debe insertar datos a la tabla pventas y dventas para probar.
create procedure PA_ValidarPreVenta(@numventa int, @result int output)
as begin 
	declare @calm int = (select pventas.calm from pventas where pventas.nvta = @numventa);
	print @calm;
	declare @cprd int;
	declare @cant int;
	declare cursorProd cursor for 
		select dventas.cprd,dventas.cant from dventas where dventas.nvta = @numventa;
	open cursorProd;
	fetch next from cursorProd into @cprd,@cant
	set @result = 1;
	while @@FETCH_STATUS=0
		begin
			declare @stock decimal(12,2);

			exec PA_StockxAlmacen @cprd,@calm,@stock output
				print 'Stock prod' + cast(@cprd as varchar(10)) + ' cant '+cast(@cant as varchar(10)) + ' stock ' + cast(@stock as varchar(20))
				IF(@cant>=@stock)
					begin 
						set @result = 0 
					end
			fetch next from cursorProd into @cprd,@cant
		end;
	close cursorProd;
	deallocate cursorProd;
end

declare @r int;
exec PA_ValidarPreVenta 1,@r output

print @r

--12. Hacer un PA denominado PA_TotalPreVenta, que reciba el Numero de Venta y que retorne  el Importe Total de la Pre Venta. 
create procedure PA_TotalPreVenta(@nvta int, @imptToto decimal(12,2) OUTPUT) 
AS BEGIN
	set @imptToto =  (SELECT itot from pventas where nvta = @nvta)
END 
--13. Hacer un PA denominado PA_DescPreVenta, que reciba como parámetro Numero de Venta y retorne el importe de descuento de la Pre Ventas, el descuento es dado bajo los siguientes criterios:
--    Si el importe total de la pre venta esta entre 10 y 20 bs se aplica un descuento de 10%
--    Si el importe total de la pre venta esta entre 11 y 50 bs se aplica un descuento de 15% 
--    Si el importe total de la pre venta es mayor a 50 bs se aplica un descuento de 20% 
--14. Hacer un PA denominado PA_PromPreVenta, que reciba como parámetro Numero de Venta y retorne el importe promedio de las cantidades los producto de la Pre Ventas.
--15. Hacer un PA denominado PA_DelDetPreVentas, que reciba como parámetro Numero de Ventas y elimina las tuplas de las tablas dventas.
--16. hacer un PA denominado PA_ProvSumistra, que reciba  el código del proveedor y retorne 1 si el proveedor ha suministrado algún Producto, de lo contrario retorna 0.
--17. Hacer un PA denominado PA_ListaProvSumistra, que muestre la lista de los Proveedores que Suministraron algún Producto (usar PA_ProvSumistra).