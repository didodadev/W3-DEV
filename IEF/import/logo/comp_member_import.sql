/*
LogoGo3/LogoTiger3 Databaselerinden bilgi alır
Kurumsal Üye Aktarım
settings.form_member_import
*/
USE Tiger3

DECLARE @SQLString NVARCHAR(MAX)

SET @SQLString = N'SELECT 
	DEFINITION_ as KısaFirmaAdi,
	DEFINITION2 as FirmaAdi,
	ADDR1+'' ''+ADDR2 as FirmaAdres,
	TOWNCODE as Firmaİlçeid,
	CITYCODE as FirmaŞehirid,
	DISTRICT as FirmaSemt,
	0 as FirmaMahalleid,
	COUNTRYCODE as FirmaÜlkeid,
	TELCODES1 as FirmaTelAlanKodu,
	TELNRS1 FirmaTel,
	TELNRS2 as FirmaTel2,
	'''' as FirmaTel3,
	FAXCODE as FirmaFax,
	EMAILADDR as FirmaEmail,
	WEBADDR as FirmaİnternetAdresi,
	'''' as FirmaCepTelAlanKodu,
	'''' as FirmaCepTel,
	0 as SatışBölgesiId,
	0 as MikroBölgeKoduId,
	0 as İliskiSekliId,
	0 as Asamaid,
	'''' as KategoriID,
	PARENTCLREF as GrupSirketiID,
	TAXOFFICE as VergiDairesiIsmi,
	TAXOFFCODE as VergiNo,
	'''' as SektorId,
	'''' as Cinsiyet,
	SUBSTRING(INCHARGE,0,CHARINDEX ('' '',INCHARGE,0)) as YetkiliAd,
	REPLACE(INCHARGE,SUBSTRING(INCHARGE,0,CHARINDEX ('' '',INCHARGE,0)),'''') as YetkiliSoyad,
	'''' as Ünvan,
	'''' as Departman,
	EMAILADDR as KişiselEmail,
	'''' as TelAlanKodu,
	'''' as TelefonNo,
	'''' as YetkiliDahiliNo,
	'''' as CepTelAlanKodu,
	'''' as CepTel,
	'''' as EvAdresi,
	'''' as EvAlanKodu,
	'''' as EvPostaKodu,
	'''' as EvTelefonu,
	'''' as EvSemt,
	'''' as Evİlçeid,
	'''' as EvSehirid,
	'''' as EvÜlkeid,
	'''' as MüşteriDeğeriid,
	'''' as TCKimlikNo,
	'''' as NotBaşligi,
	'''' as Not_,
	'''' as NotBasliği2,
	'''' as Not2,
	'''' as UyelikBaslamaTarihi,
	'''' as UyeNo,
	'''' as TemsilciId,
	SPECODE as OzelKod,
	SPECODE2 as OzelKod2,
	SPECODE3 as OzelKod3,
	'''' as KEPAdresi
from LG_'+@FirmNr+'_Clcard'

 

EXECUTE sp_executesql @SQLString