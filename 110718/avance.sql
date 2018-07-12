use preventas;
select * from pventas
select * from dventas
use preventas
select * from sumi
---- si no existe la cantidad aboratar 
--- si el producto no existe abortart 
-- si viola reglas de la bd abortar 
--si hay excepcion abortar 

alter procedure PA_GrabaPreventa(@calm int, @nombreC varchar(50),@nVenta int) 
as 
begin
	declare @codPr int;
	declare @cantidad decimal(12,2);
	declare @stock decimal(12,2);
	declare @precio decimal(12,2);
	--verificamos que no exista la cabecera de la venta
	BEGIN TRY
	--Coomenzamos la transaccion
	BEGIN TRAN 
	if((select count(*) from pventas where pventas.nvta =@nVenta)=0)
		begin	
			insert into pventas values(@nVenta,@nombreC,@calm,GETDATE(),0,0);
			declare cursor_pedidos cursor for select cprd, cant from pedidos;
			open cursor_pedidos
			fetch next from cursor_pedidos into @codPr, @cantidad;
			WHILE @@FETCH_STATUS = 0 
			BEGIN
				IF((select count(*) from prod where prod.cprd = @codPr) > 0 )
					BEGIN 
						exec PA_StockxAlmacen @codPr,@calm,@stock output
						print 'Actual{producto:'+cast(@codPr as nvarchar(10))+ 'cantidad:'+cast(@cantidad as nvarchar(10))+'}'
						IF( @cantidad <= @stock)
							BEGIN 
								--Obtengo el precio promedio 
								set @precio = dbo.PPP_productor(@codPr,@calm);
								-- Obtengo el importe para ese producto 
								declare @importe decimal(12,2) = @cantidad* @precio;
								--Registro el detalle de la venta
								insert into dventas values(@nVenta,@codPr,@cantidad,@precio,@importe);
								--Confirmo la transaccion
							END
						ELSE 
							BEGIN
								print 'He abortado la transaccion, No existe la cantidad solicitada'
								rollback tran;
								break;						
							END
					END
				ElSE
					BEGIN
						print 'He abortado la transaccion, El producto no existe'
						rollback tran;
						break;
					END 
				--sacar nuevos datos del cursor
				fetch next from cursor_pedidos into @codPr, @cantidad;
			END
			close	cursor_pedidos;
			deallocate cursor_pedidos;
			if(@@ERROR =0)
			BEGIN
				commit tran 
			END	
		end
	else 
		begin
			print 'He abortado la transaccion, ya existe esa nota de venta'
		end
	END TRY
	BEGIN CATCH	
		SELECT ERROR_MESSAGE() 
		print 'He abortado la transaccion, agarre un error en el catch'
		if(@@TRANCOUNT=1)
		BEGIN
			rollback tran
		END
	END CATCH 
end 

exec PA_GrabaPreventa 1,'sr Carlos menen',100;


select * from pventas
select * from dventas
select * from pedidos
select * from sumi where sumi.cprd=4

delete from pedidos where (cprd=2 or cprd=3)
delete from pventas where pventas.nvta = 100
delete from dventas where dventas.nvta =100


disable trigger INS_DESCUENTO on dventas
disable trigger TR_del_dventas on dventas;
disable trigger TR_ins_dventas on dventas;
disable trigger TR_stock_dventas on dventas;
disable trigger TR_upd_dventas on dventas;
disable trigger TR_UpdProducto on dventas;




