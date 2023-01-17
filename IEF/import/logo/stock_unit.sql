/*
 Go3/ Tiger3 
 Birim Aktarım
 settings.import_unit
*/
 
SET @SQLString = N'SELECT 
	ITEMS.CODE as StokKodu,
	BIRIM.CODE as EkBirim,
	BIRIM.CONVFACT2 as Carpan,
	(LTRIM(STR(BIRIMDETAY.WIDTH))+''*''+LTRIM(STR(BIRIMDETAY.LENGTH))+''*''+LTRIM(STR(BIRIMDETAY.HEIGHT))) as Boyut, 
	BIRIMDETAY.GROSSWEIGHT as Agirlik, 
	BIRIMDETAY.GROSSWEIGHT as Hacim , 
	(SELECT CASE WHEN COUNT(1)>1 THEN 1 ELSE 0 END  FROM LG_'+@FirmNr+'_ITMUNITA A WHERE A.ITEMREF=ITEMS.LOGICALREF) as Birim2  
 
FROM     LG_'+@FirmNr+'_ITMUNITA AS BIRIMDETAY INNER JOIN
        LG_'+@FirmNr+'_UNITSETL AS BIRIM ON BIRIMDETAY.UNITLINEREF = BIRIM.LOGICALREF   INNER JOIN
        LG_'+@FirmNr+'_ITEMS AS ITEMS ON BIRIMDETAY.ITEMREF = ITEMS.LOGICALREF'


EXECUTE sp_executesql @SQLString


						