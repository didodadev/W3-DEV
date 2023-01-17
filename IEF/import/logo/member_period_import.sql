/*
LogoGo3/LogoTiger3 Databaselerinden bilgi alır
Üye Muhasebe Kodu İmport
settings.form_member_period_import
*/
DECLARE @SQLString NVARCHAR(MAX)

SET @SQLString = N'SELECT 

	''K'' as UyeTipi,
	1 as Oncelik,
	CODE as CariKodu,
	 (SELECT EMUHACC.CODE
	   FROM LG_'+@FirmNr+'_CRDACREF AS CRDACREF INNER JOIN
			LG_'+@FirmNr+'_EMUHACC AS EMUHACC ON CRDACREF.ACCOUNTREF = EMUHACC.LOGICALREF
	   WHERE CRDACREF.TRCODE=5 AND CRDACREF.TYP = 1 AND CRDACREF.CARDREF =CLCARD.LOGICALREF)  MuhasebeHesabi,
	'''' as KonsinyeMalHesabi,
	CASE WHEN CARDTYPE in(1,3) THEN 1 ELSE 0 END as Alici,
	CASE WHEN CARDTYPE in (2,3) THEN 1 ELSE 0 END as Satici,
	'''' as AvansHesabi,
	'''' as SatisHesabi,
	'''' as AlisHesabi,
	'''' as AlinanTeminatHesabi,
	'''' as VerilenTeminatHesabi,
	'''' as AlinanAvansHesabi,
	'''' as IhracKayitliSatisHesabi,
	'''' as IhracKayitliAlisHesabi

from LG_'+@FirmNr+'_CLCARD CLCARD'


EXECUTE sp_executesql @SQLString
 