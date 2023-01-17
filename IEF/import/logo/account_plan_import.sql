/*
LogoGo3/LogoTiger3 Databaselerinden bilgi alır
Hesap Planı Aktarım
settings.import_account_plan
*/
 

DECLARE @SQLString NVARCHAR(MAX) 

SET @SQLString = N'SELECT 
	   EMUHACC.CODE as HesapNo,
	   EMUHACC.DEFINITION_ as HesapAdi,
	   '''' as UFRSKod,
	   '''' as UFRSAciklama,
	   SPECODES.SPECODE as OzelKod,
	   SPECODES.DEFINITION_ AS OzelKodAciklama
FROM  LG_'+@FirmNr+'_EMUHACC AS EMUHACC LEFT OUTER JOIN
      LG_'+@FirmNr+'_SPECODES AS SPECODES ON EMUHACC.SPECODE = SPECODES.SPECODE AND SPECODES.SPECODETYPE = 35 AND SPECODES.CODETYPE = 1'


EXECUTE sp_executesql @SQLString


 