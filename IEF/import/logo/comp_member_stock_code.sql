/*
LogoGo3/LogoTiger3  
Üye Stok Kodu Aktarım
settings.form_company_stock_code_import
*/

SET @SQLString = N'SELECT 
CLCARD.CODE as UyeKodu,
ITEMS.CODE as StokKodu,
SUPPASGN.ICUSTSUPCODE as UyeStokKodu
FROM   LG_'+@FirmNr+'_SUPPASGN AS SUPPASGN INNER JOIN
       LG_'+@FirmNr+'_ITEMS AS ITEMS ON SUPPASGN.ITEMREF = ITEMS.LOGICALREF INNER JOIN
       LG_'+@FirmNr+'_CLCARD AS CLCARD ON SUPPASGN.CLIENTREF = CLCARD.LOGICALREF'

EXECUTE sp_executesql @SQLString