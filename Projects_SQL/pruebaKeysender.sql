declare @keysender varchar(20)
declare @keysenderO varchar(20)


select @keysender='RY5'

select SUBSTRING(@keysender,LEN(@keysender)-3,LEN(@keysender))

if not exists (SELECT * FROM tReceiptElectronicMOney Where keysender LIKE '%'+@keysender + '_R%')
	begin
		--print 'no existe'
		select @keysender = @keysender+'_R01'	
		print @keysender	
	end
else
	begin
		print 'existe'
		
		select top 1 SUBSTRING(@keysender,LEN(@keysender)-3,LEN(@keysender)) 
		from tReceiptElectronicMOney 
		where keysender Where keysender LIKE '%'+@keysender + '_R%'
		ORDER BY keysender DESC		
	end