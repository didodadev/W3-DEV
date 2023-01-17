/* Ürün Ağacı Import
settings.form_product_tree_import */
DECLARE @SQLString NVARCHAR(max)
SET @SQLString = N'select 

	BOMLINE.NEXTLEVELBOMREF as Kirilim,
	OPERTION.CODE as OperasyonKodu,
	ITEMS.CODE as StokKodu,
	BOMREVSN.CODE as Spekt,
	BOMLINE.AMOUNT as Miktar,
	BOMLINE.Amount*BOMLINE.SCRAPFACT/100 as FireMiktari,
	BOMLINE.SCRAPFACT as FireOrani,
	BOMLINE.LINENO_ as SiraNo,
	0 as AlternatifSorusu,
	BOMLINE.ENGINEERING as KonfigureEdilebilir,
	0 as SevkteBirlestir,
	0 as Fantom,
	BOMLINE.BOMLINEEXP as Aciklama

FROM   LG_'+@FirmNr+'_ITEMS AS ITEMS INNER JOIN
       LG_'+@FirmNr+'_BOMLINE AS BOMLINE ON ITEMS.LOGICALREF = BOMLINE.ITEMREF INNER JOIN
       LG_'+@FirmNr+'_BOMREVSN AS BOMREVSN ON BOMLINE.BOMREVREF = BOMREVSN.LOGICALREF LEFT OUTER JOIN
       LG_'+@FirmNr+'_OPERTION OPERTION ON BOMLINE.OPERATIONREF=OPERTION.LOGICALREF'
 
  EXECUTE sp_executesql @SQLString

 