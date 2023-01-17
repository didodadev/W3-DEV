/* TİGER3-GO3
Planlama ve Tahakkuk Fişi Aktarım
settings.budget_plan_import */

DECLARE @SQLString NVARCHAR(max)
SET @SQLString = N'select 
		ANBDGTREVLN.DATE_ as Tarih,
		ANBDGTREVLN.LINEEXP as Açıklama,
		'''' as MasrafGelirMerkeziID,
		ANBDGTREVLN.LOGICALREF as ButceKalemiID,
		(SELECT CODE FROM LG_001_EMUHACC A WHERE A.LOGICALREF=ANBDGTREVLN.ACCREF) as MuhasebeKodu,
		'''' as AktiviteTipiID,
		'''' as IsGrubuID,
		(SELECT SPECODE FROM LG_'+@FirmNr+'_'+@DonemNr+'_ANBDGTREVFC A WHERE A.LOGICALREF=ANBDGTREVLN.BDREVFCREF) as KurumsalUyeKodu, 
		'''' as BireyselUyeKodu, 
		ANBDGTREVPRD.DEBIT as Gelir,
		ANBDGTREVPRD.CREDIT as Gider

from LG_'+@FirmNr+'_'+@DonemNr+'_ANBDGTREVLN ANBDGTREVLN LEFT OUTER JOIN LG_'+@FirmNr+'_'+@DonemNr+'_ANBDGTREVPRD ANBDGTREVPRD
ON ANBDGTREVLN.LOGICALREF=ANBDGTREVPRD.BDREVLNREF'
 
 
EXECUTE sp_executesql @SQLString