/* Sipariş Aktarım
settings.form_add_order_import
 */

DECLARE @SQLString NVARCHAR(max)
DECLARE @YERELPARA nvarchar(3)
set @YERELPARA=(SELECT top 1 CURCODE FROM L_CURRENCYLIST WHERE  CURTYPE=(SELECT LOCALCTYP FROM L_CAPIFIRM A WHERE A.NR=@FirmNr) )
 
SET @SQLString = N'select 
	  ORFLINE.LINENO_ as SatırNo,
	  ITEMS.CODE as StokKodu, 
	  '''' as SpektKodu, 
	  CASE WHEN ORFLINE.CLOSED=1 THEN -4  WHEN ORFLINE.DORESERVE=0 THEN -3 ELSE -1 END AS RezerveTipi,
	  ORFLINE.AMOUNT as Miktar,
	  (SELECT NAME FROM   LG_'+@FirmNr+'_UNITSETL A WHERE A.LOGICALREF=ORFLINE.UOMREF) as Birim,
	  ORFLINE.PRICE as BirimFiyat,
	   ISNULL( (SELECT top 1 CURCODE FROM L_CURRENCYLIST WHERE  CURTYPE = ORFLINE.TRCURR),'''+@YERELPARA+''') as ParaBirimi,
	 ORFLINE.VAT as KDVOrani,
	 (SELECT DISCPER from
		(SELECT ROW_NUMBER() OVER(ORDER BY LOGICALREF) AS sira,DISCPER FROM LG_'+@FirmNr+'_'+@DonemNr+'_ORFLINE A
		 WHERE A.LINETYPE=2 AND A.ORDFICHEREF=ORFLINE.ORDFICHEREF AND A.PARENTLNREF=ORFLINE.LOGICALREF) AS t WHERE sira=1) as ISK1,
	 (SELECT DISCPER from
		(SELECT ROW_NUMBER() OVER(ORDER BY LOGICALREF) AS sira,DISCPER FROM LG_'+@FirmNr+'_'+@DonemNr+'_ORFLINE A
		 WHERE A.LINETYPE=2 AND A.ORDFICHEREF=ORFLINE.ORDFICHEREF AND A.PARENTLNREF=ORFLINE.LOGICALREF) AS t WHERE sira=2) as ISK2,
	 (SELECT DISCPER from
		(SELECT ROW_NUMBER() OVER(ORDER BY LOGICALREF) AS sira,DISCPER FROM LG_'+@FirmNr+'_'+@DonemNr+'_ORFLINE A
		 WHERE A.LINETYPE=2 AND A.ORDFICHEREF=ORFLINE.ORDFICHEREF AND A.PARENTLNREF=ORFLINE.LOGICALREF) AS t WHERE sira=3) as ISK3,
	 (SELECT DISCPER from
		(SELECT ROW_NUMBER() OVER(ORDER BY LOGICALREF) AS sira,DISCPER FROM LG_'+@FirmNr+'_'+@DonemNr+'_ORFLINE A
		 WHERE A.LINETYPE=2 AND A.ORDFICHEREF=ORFLINE.ORDFICHEREF AND A.PARENTLNREF=ORFLINE.LOGICALREF) AS t WHERE sira=4) as ISK4,
	 (SELECT DISCPER from
		(SELECT ROW_NUMBER() OVER(ORDER BY LOGICALREF) AS sira,DISCPER FROM LG_'+@FirmNr+'_'+@DonemNr+'_ORFLINE A
		 WHERE A.LINETYPE=2 AND A.ORDFICHEREF=ORFLINE.ORDFICHEREF AND A.PARENTLNREF=ORFLINE.LOGICALREF) AS t WHERE sira=5) as ISK5,
	 (SELECT DISCPER from
		(SELECT ROW_NUMBER() OVER(ORDER BY LOGICALREF) AS sira,DISCPER FROM LG_'+@FirmNr+'_'+@DonemNr+'_ORFLINE A
		 WHERE A.LINETYPE=2 AND A.ORDFICHEREF=ORFLINE.ORDFICHEREF AND A.PARENTLNREF=ORFLINE.LOGICALREF) AS t WHERE sira=6) as ISK6,

	  '''' as SatırAsamasi,
	  ORFLINE.LINEEXP as Acıklama,
	  '''' as Acıklama2,
	  ORFLINE.SOURCEINDEX as DepoId,
	  0 as TeslimLokasyon,
	  0 as FiyatListesiID,
	  ORFLINE.TRRATE as SatirDovizKuru,
	  '''' as TeslimAdresiIlcesi ,
	  '''' as Birim2 ,
	  '''' as Miktar2,
	  BRANCH as SubeID,
	  '''' as ReferansNo,
	  '''' as SiparisNo
from LG_'+@FirmNr+'_'+@DonemNr+'_ORFLINE ORFLINE INNER JOIN LG_'+@FirmNr+'_ITEMS ITEMS
ON ORFLINE.STOCKREF=ITEMS.LOGICALREF AND ORFLINE.LINETYPE=0
order BY ORFLINE.ORDFICHEREF,ORFLINE.LINENO_'

 EXECUTE sp_executesql @SQLString
 
 