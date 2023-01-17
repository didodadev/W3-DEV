/*
bORDRO Databaselerinden bilgi alır
Çalışan Amir Aktarım
ehesap.import_standby
*/
DECLARE @SQLString NVARCHAR(max)

SET @SQLString = N'Select 
		(Name+'' ''+MIDNAME+'' ''+Surname) CalisanAdSoyad,
		(select IDTCNO from LH_'+@FirmNr+'_PERIDINF WHERE LREF=person.LREF) CalışanTCKimlikNo,
		(select Name+'' ''+Surname from LH_'+@FirmNr+'_PERSON WHERE LREF=person.SUPREF)  Amir_1,
		(select IDTCNO from LH_'+@FirmNr+'_PERIDINF WHERE LREF=person.SUPREF) AmirTCKimlikNo_1,
		'''' Amir_2,
		'''' AmirTCKimlikNo_2,
		'''' GörüsBildiren,
		'''' GörüsBildirenTCKimlikNo,
		'''' AmirYedek_1,
		'''' AmirYedekTCKimlikNo_1,
		'''' AmirYedek_2,
		'''' AmirYedekTCKimlikNo_2,
		'''' GörüsBildirenYedek,
		'''' GörüsBildirenYedekTCKimlikNo
	FROM lh_'+@FirmNr+'_person  person'

EXECUTE sp_executesql @SQLString

 