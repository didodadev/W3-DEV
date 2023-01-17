
/*
Bordro Databaselerinden bilgi alır
Bütçe Kalemi Aktarım
settings.form_add_budget_items_import
*/
  
DECLARE @SQLString NVARCHAR(max)

set @SQLString= N'select 
		ANBUDGET.LOGICALREF as KategoriID, 
		ANBUDGET.DEFINITION_ as Bütçekalemiadi, 
		ANBUDGET.CODE as Bütcekalemikodu, 
		EMUHACC.CODE as MuhasebeKodu, 
		CASE WHEN ANBUDGETLN.DEBIT>0 then 1 else 0 end as Gelir, 
		CASE WHEN ANBUDGETLN.CREDIT>0 then 1 else 0 end as Gider, 
		ANBUDGETLN.LINEEXP as Açıklama 
 from LG_'+@FirmNr+'_ANBUDGET ANBUDGET LEFT OUTER JOIN LG_'+@FirmNr+'_ANBUDGETLN ANBUDGETLN
 ON ANBUDGET.LOGICALREF=ANBUDGETLN.BDGTREF LEFT OUTER JOIN LG_'+@FirmNr+'_EMUHACC EMUHACC
 ON ANBUDGETLN.ACCREF=EMUHACC.LOGICALREF
'

EXECUTE sp_executesql @SQLString

 
