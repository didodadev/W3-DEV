/*
LogoGo3/LogoTiger3 
Marka Aktarım
settings.import_brand
*/
 

SET @SQLString = N'SELECT 
	CODE Kod,
	DESCR as Marka,
	 '''' as Aciklama 
from LG_'+@FirmNr+'_MARK'

EXECUTE sp_executesql @SQLString
 