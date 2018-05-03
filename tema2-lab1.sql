use preventas;
--1. Crear la Base de Datos "preventas" usando el Esquema Fisico de la Base de Datos preventa
--2. Elabora los siguientes Trigger para las tablas de la Base de Datos preventas

--1. Hacer un TRIGGER denominado TR_stock_dventas, que despues de insertar una fila a la 
     --tabla dventas valide si hay stock suficiente del producto (usar PA_HayStockxAlmacen), 
     --si no hay Stock suficiente se debe cancelar el INSERT usando ROLLBACK

	 alter trigger TR_stock_dventas on dventas for insert 
	 as 
	 begin
		declare @nvta int = (select nvta from inserted)
		print @nvta
		declare @cprd int = (select cprd from inserted)
		print @cprd
		declare @calm int = (select pventas.calm from pventas where pventas.nvta =@nvta)
		print @calm
		declare @cant decimal(12,2) = (select cant from inserted)
		print @cant
		declare @s int
		exec PA_StockxAlmacen @cprd,@calm,@s output
		print @s
		if(@s<@cant)
			begin 
				rollback
				print ' Se aborto la transaccion'
			end 
	 end

	 insert into dventas values (1,1,1,4,4)
	 select * from pventas where nvta = 1 --// --nvta =1, calm = 1
	 select * from dventas where nvta = 1
	 delete from dventas where nvta = 1 and cprd = 1
	 select * from sumi where cprd = 1
	 select * from alma 
--2. Hacer un TRIGGER denominado TR_del_dventas, que después de borrar una fila en la 
     --tabla dventas actualice el Importe Total en la tabla pventas (usar PA_TotalPreVenta). 

create trigger TR_del_dventas on dventas for delete as 
begin 
 declare @nvta int = (select nvta from deleted)
 declare @impt decimal(12,2) = (select impt from deleted)
 declare @imptTotal decimal(12,2) 
 exec PA_TotalPreVenta @nvta, @imptTotal output
 set @imptTotal = @imptTotal -@impt
 update pventas set  [itot] = @imptTotal where [nvta] = @nvta
 print 'Datos actualizados'
end 
--3. Hacer un TRIGGER denominado TR_ins_dventas, que después de insertar una fila en la 
     --tabla dventas actualice el Importe Total en la tabla pventas (usar PA_TotalPreVenta). 
create trigger TR_ins_dventas on dventas after insert as 
begin 
 declare @nvta int = (select nvta from inserted)
 declare @impt decimal(12,2) = (select impt from inserted)
 declare @imptTotal decimal(12,2) 
 exec PA_TotalPreVenta @nvta, @imptTotal output
 set @imptTotal = @imptTotal +@impt
 update pventas set  [itot] = @imptTotal where [nvta] = @nvta
 print 'Datos actualizados'
end 

--4. Hacer un TRIGGER denominado TR_upd_dventas, que después de actualizar una fila en la 
     --tabla dventas actualice el Importe Total (itot) en la tabla pventas 
     --(usar PA_TotalPreVenta).
create trigger TR_upd_dventas on dventas after update as 
begin 
 declare @nvta int = (select nvta from inserted)
 declare @impt decimal(12,2) = (select impt from inserted)
 declare @oldImpt decimal(12,2) = (select impt from deleted)
 declare @imptTotal decimal(12,2) 
 exec PA_TotalPreVenta @nvta, @imptTotal output
 set @imptTotal = @imptTotal -@oldImpt +@impt
 update pventas set  [itot] = @imptTotal where [nvta] = @nvta
 print 'Datos actualizados'
end 
select * from dventas	where nvta = 1 and cprd =1
select * from pventas where nvta = 1
update dventas set cant =2, impt = 8 where  nvta = 1 and cprd =1

--5. Hacer un TRIGGER denominado TR_del_dventas, que después de borrar una fila en la 
     --tabla dventas actualice el Importe de descuento (ides) en la tabla pventas 
     --(usar PA_DescPreVenta). Ademas si ya no hay mas filas para esa venta en la tabla 
     --dventas que también eliminé la filade la tabla pventas.
--6. Hacer un TRIGGER denominado TR_ins_dventas, que después de insertar una fila en la 
     tabla dventas actualice el Importe de descuento (ides) en la tabla pventas 
     (usar PA_DescPreVenta). 
--7. Hacer un TRIGGER denominado TR_upd_dventas, que después de actualizar una fila en la 
     tabla dventas actualice el Importe de descuento (ides) en la tabla pventas 
     (usar PA_DescPreVenta).
--8. Hacer un TRIGGER denominado TR_del_PreVentas, que borre toda la venta incluyendo su 
     detalle (usar PA_DelPreVentas).
--9. Hacer un TRIGGER denominado TR_ins_log, que despues de insertar una fila en la tabla 
     pventas inserte  los datos en la tabla log_pventas
--10. Hacer un TRIGGER denominado TR_del_log, que despues de borarr una fila en la tabla 
      pventas inserte  los datos en la tabla log_pventas
--11. Hacer un TRIGGER denominado TR_upd_log, que despues de actualizar una fila en la 
      tabla pventas inserte los datos en la tabla log_pventas

