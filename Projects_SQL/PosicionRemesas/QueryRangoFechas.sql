	SELECT isnull(RFS.Frecuencia,'') as Frecuencia, COUNT(RFS.OperacionCierre) AS Cantidad, DATEADD(day, DATEDIFF(day, 0,RFS.Fecha_sol), 0) AS FechaSol INTO #pos1
	FROM Remesas_FamiliaresSol RFS
	INNER JOIN Remesas_FamiliaresBenef RFB ON RFS.Solicitud = RFB.Solicitud
	INNER JOIN Movimien M ON RFS.OperacionCierre = M.Operacion
	WHERE 
	--RFS.Fecha_Sol BETWEEN CONVERT(datetime,'2014-01-01') AND 
		
	DATEDIFF(DAY,CONVERT(datetime,'2014-01-01'),RFS.Fecha_Sol) >= 0  AND DATEDIFF(DAY,CONVERT(datetime,'2014-04-20'),RFS.Fecha_Sol) <=0
	
	AND RFS.OperacionCierre IS NOT NULL
	AND M.Estado ='C'
	GROUP BY RFS.Frecuencia, DATEADD(day, DATEDIFF(day, 0,RFS.Fecha_sol), 0)

	--SET @FLAG = 'SI'
	
	--DROP TABLE #pos1 
	
	SELECT * FROM #pos1 ORDER BY Fechasol ASC
	--Select Frecuencia,Cantidad,Fecha_sol,MONTH(Fecha_Sol)AS MES from #pos1 GROUP BY MONTH(Fecha_Sol),Frecuencia,Cantidad,Fecha_Sol
	
	--SELECT RFS.Fecha_sol,RFS.Frecuencia FROM Remesas_FamiliaresSol RFS WHERE 
	--RFS.OperacionCierre IS NOT NULL
	--AND 
	--RFS.Fecha_Sol BETWEEN CONVERT(datetime,'2014-01-01') AND CONVERT(datetime,'2014-04-20')



--SELECT DATEDIFF(DAY,CONVERT(datetime,'2014-01-03'),CONVERT(datetime,'2014-01-01'))
