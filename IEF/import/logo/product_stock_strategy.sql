/*
Go3/Tiger3  
Stok Strateji Aktarım
product.stock_strategy_import
*/
 
DECLARE @SQLString NVARCHAR(MAX)

SET @SQLString = N'SELECT 
	ITEMS.CODE as StokKodu, 
	0  as StratejiTürü, 
	INVDEF.MAXLEVEL  as MaximumStok,
	INVDEF.MINLEVEL  as MinimumStok,
	0  as BlokeStok,
	0  as YenidenSiparisNoktasi,
	0  as MinimumSiparisMiktari,
	0  as MinimumSiparisBirimi,
	0  as MaksimumSiparisMiktarı,
	0  as MaksimumSiparisBirimi,
	0  as SiparisTipi, 
	0  as TedarikSüresi,
	0  as YenidenSiparisNoktasındaUyar, 
	0  as  StokPrensipleri, 
	INVDEF.INVENNO  as DepoID
FROM LG_'+@FirmNr+'_ITEMS ITEMS LEFT OUTER JOIN LG_'+@FirmNr+'_INVDEF INVDEF ON ITEMS.LOGICALREF=INVDEF.ITEMREF'

EXECUTE sp_executesql @SQLString  