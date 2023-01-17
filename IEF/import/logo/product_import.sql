/*
 Go3/ Tiger3 
 Ürün Aktarım
 settings.form_product_import
*/
 
SET @SQLString = N'SELECT 

	1 as KayitTipi,
	(SELECT A.BARCODE
		FROM LG_'+@FirmNr+'_UNITBARCODE AS A INNER JOIN
			 LG_'+@FirmNr+'_ITMUNITA AS B ON A.ITMUNITAREF = B.LOGICALREF INNER JOIN
			 LG_'+@FirmNr+'_UNITSETL AS C ON B.UNITLINEREF = C.LOGICALREF
		WHERE  A.ITEMREF=ITEMS.LOGICALREF AND (C.LINENR = 1)) as Barcode,
	(SELECT A.BARCODE
		FROM LG_'+@FirmNr+'_UNITBARCODE AS A INNER JOIN
			 LG_'+@FirmNr+'_ITMUNITA AS B ON A.ITMUNITAREF = B.LOGICALREF INNER JOIN
			 LG_'+@FirmNr+'_UNITSETL AS C ON B.UNITLINEREF = C.LOGICALREF
		WHERE   A.ITEMREF=ITEMS.LOGICALREF AND (C.LINENR = 2)) as Barcode2,
	ITEMS.NAME as UrUnAdi, 
	'' as CesitAdi,
	(SELECT B.NAME
	FROM LG_'+@FirmNr+'_ITMUNITA AS A INNER JOIN
		 LG_'+@FirmNr+'_UNITSETL AS B ON A.UNITLINEREF = B.LOGICALREF AND B.LINENR = 1 AND A.ITEMREF=ITEMS.LOGICALREF) as Birim,
	ITEMS.VAT as AlisKDV,
	ITEMS.SELLVAT as SatisKDV,
	(SELECT TOP 1 PRICE FROM LG_'+@FirmNr+'_PRCLIST A WHERE A.PTYPE=1 AND  A.INCVAT=1 AND A.CARDREF=ITEMS.LOGICALREF) as Alisfiyatkdvli,
	(SELECT TOP 1 PRICE FROM LG_'+@FirmNr+'_PRCLIST A WHERE  A.PTYPE=1 AND A.INCVAT=0 AND A.CARDREF=ITEMS.LOGICALREF)  as Alisfiyatkdvsiz,
	(SELECT TOP 1 CURCODE FROM LG_'+@FirmNr+'_PRCLIST A INNER JOIN L_CURRENCYLIST B ON A.CURRENCY=B.CURTYPE WHERE B.FIRMNR='+@FirmNr+' AND A.CARDREF=ITEMS.LOGICALREF) as AlisParaBirimi,
	(SELECT TOP 1 PRICE FROM LG_'+@FirmNr+'_PRCLIST A WHERE A.PTYPE=1 AND  A.INCVAT=1 AND A.CARDREF=ITEMS.LOGICALREF) as Satisfiyatikdvlifiyat,
	(SELECT TOP 1 PRICE FROM LG_'+@FirmNr+'_PRCLIST A WHERE A.PTYPE=2 AND  A.INCVAT=1 AND A.CARDREF=ITEMS.LOGICALREF) as Satisfiyatikdvsizfiyat,
	(SELECT TOP 1 PRICE FROM LG_'+@FirmNr+'_PRCLIST A WHERE A.PTYPE=2 AND  A.INCVAT=0 AND A.CARDREF=ITEMS.LOGICALREF) as SatisParaBirimi,
	'' as Kategori,
	(SELECT TOP 1 B.CODE FROM  LG_'+@FirmNr+'_SUPPASGN A INNER JOIN LG_'+@FirmNr+'_CLCARD B ON A.CLIENTREF=B.LOGICALREF  WHERE CLCARDTYPE=1 AND A.ITEMREF=ITEMS.LOGICALREF) as Tedarikci,
	ITEMS.PRODUCERCODE as UreticiUrunkodu,
	'' as FiyatYetkisi,
	'' as Asama,
	ITEMS.SPECODE as OzelKod,
	(SELECT LOGICALREF FROM LG_'+@FirmNr+'_MARK A WHERE A.LOGICALREF=ITEMS.MARKREF) as MarkaID,
	0 as ModelId,
	ITEMS.NAME2 as Aciklama,
	'' as Aciklama2,
	MTRLBRWS as Envanter,
	1 as Uretim,
	ITEMS.SALESBRWS as Satis,
	ITEMS.PURCHBRWS as Tedarik,
	1 as Internet,
	1 as Extranet,
	0 as SifirStokileCalis,
	0 as StoklarlaSinirli,
	0 as Kalite,
	INVDEF.MINLEVEL as MinimumMarj,
	INVDEF.MAXLEVEL as MaximumMarj,
	'' as MuhasebekodgrubuId,
	ITEMS.SHELFLIFE as Rafomru,
	'' as BoyutBirim,
	''  as HacimBirim,
	'' as AgirlikBirim,
	'' as HedefPazar,
	'' as BSMV,
	'' as OIV

FROM LG_'+@FirmNr+'_ITEMS ITEMS LEFT OUTER JOIN LG_'+@FirmNr+'_INVDEF INVDEF ON ITEMS.LOGICALREF=INVDEF.ITEMREF AND INVDEF.INVENNO=0'

EXECUTE sp_executesql @SQLString