/*
Tiger3-Go3 Databaselerinden bilgi alır
Bütçe Kategorileri Aktarım
settings.form_add_budget_categories_import
*/
  
DECLARE @SQLString NVARCHAR(max)

set @SQLString= N'select 
	ANBUDGET2.CODE as UstKategoriKodu,
	ANBUDGET.DEFINITION_ as Kategoriadi,
	'' '' as Acıklama,
	ANBUDGET.CODE as KategoriKodu
from LG_'+@FirmNr+'_ANBUDGET ANBUDGET LEFT OUTER JOIN LG_'+@FirmNr+'_ANBUDGET ANBUDGET2
ON ANBUDGET.PARBDGTREF=ANBUDGET2.LOGICALREF'

EXECUTE sp_executesql @SQLString