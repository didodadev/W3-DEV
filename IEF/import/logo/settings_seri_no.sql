
/*
LogoGo3/LogoTiger3 Databaselerinden bilgi alır
Seri No İmport
settings.import_seri_no
*/
DECLARE @SQLString NVARCHAR(MAX)
SET @SQLString = N'SELECT 

		CASE WHEN SERILOTN.SLTYPE=2 THEN  SERILOTN.CODE ELSE '''' END as SeriNo,
		CASE WHEN SERILOTN.SLTYPE=1 THEN  SERILOTN.CODE ELSE '''' END as LotNo,
		0 as ReferansNo,
		ITEMS.CODE as StokKodu,
		STLINE.SOURCEINDEX as DepoID,
		1 as LokasyonID,
		0 as AlisGarantiKategorisiId,
		 CONVERT(VARCHAR,STLINE.DATE_ , 104)  as GarantiBaslamaTarihi,
		CONVERT(VARCHAR, SLTRANS.EXPDATE  , 104)  as GarantiBitisTarihi
	from LG_'+@FirmNr+'_'+@DonemNr+'_SLTRANS SLTRANS INNER JOIN LG_'+@FirmNr+'_ITEMS ITEMS ON 
	SLTRANS.ITEMREF=ITEMS.LOGICALREF INNER JOIN LG_'+@FirmNr+'_'+@DonemNr+'_SERILOTN SERILOTN ON 
	SLTRANS.SLREF=SERILOTN.LOGICALREF INNER JOIN LG_'+@FirmNr+'_'+@DonemNr+'_STLINE STLINE ON 
	STLINE.LOGICALREF=SLTRANS.STTRANSREF'


EXECUTE sp_executesql @SQLString
 