/*
LogoGo3/LogoTiger3 Databaselerinden bilgi alır
Müşteri kartı bazında 3 adet ilgili tanımlanıyor
Kurumsal Çalışan Aktarımı
settings.form_add_company_partner_import
*/

DECLARE @SQLString NVARCHAR(max)

SET @SQLString = N'SELECT  
CLCARD.LOGICALREF as KurumsalUyeID,
CASE WHEN CHARINDEX('' '',CLCARD.INCHARGE)>0 THEN
   REVERSE(SUBSTRING(REVERSE(INCHARGE),CHARINDEX('' '',REVERSE(INCHARGE)),len(INCHARGE))) ELSE CLCARD.INCHARGE END as Adi,
CASE WHEN CHARINDEX('' '',CLCARD.INCHARGE)>0 THEN
   RIGHT(CLCARD.INCHARGE, CHARINDEX('' '', REVERSE(CLCARD.INCHARGE)) - 1) ELSE '''' END AS Soyadi ,
'''' as DogumTarihi,
'''' as TCKimlikNo,
'''' as Unvan,
0 as GorevPozisyonID,
0 as SubeID,
0 as DepartmanID,
'''' as Cinsiyet,
'''' as Dahili,
CLCARD.EMAILADDR as EMail,
'''' as Adres,
0 as UlkeID,
0 as SehirID,
0 as IlceID,
'''' as Semt,
'''' as PostaKodu,
0 as DilID
from LG_'+@FirmNr+'_CLCARD CLCARD
		UNION
select 
CLCARD.LOGICALREF as KurumsalUyeID,
CASE WHEN CHARINDEX('' '',CLCARD.INCHARGE2)>0 THEN
   REVERSE(SUBSTRING(REVERSE(INCHARGE2),CHARINDEX('' '',REVERSE(INCHARGE2)),len(INCHARGE2))) ELSE CLCARD.INCHARGE2 END as Adi,
CASE WHEN CHARINDEX('' '',CLCARD.INCHARGE2)>0 THEN
   RIGHT(CLCARD.INCHARGE2, CHARINDEX('' '', REVERSE(CLCARD.INCHARGE2)) - 1) ELSE '''' END AS Soyadi ,
'''' as DogumTarihi,
'''' as TCKimlikNo,
'''' as Unvan,
0 as GorevPozisyonID,
0 as SubeID,
0 as DepartmanID,
'''' as Cinsiyet,
'''' as Dahili,
CLCARD.EMAILADDR2 as EMail,
'''' as Adres,
0 as UlkeID,
0 as SehirID,
0 as IlceID,
'''' as Semt,
'''' as PostaKodu,
0 as DilID
from LG_'+@FirmNr+'_CLCARD CLCARD
			UNION
select 
CLCARD.LOGICALREF as KurumsalUyeID,
CASE WHEN CHARINDEX('' '',CLCARD.INCHARGE3)>0 THEN
   REVERSE(SUBSTRING(REVERSE(INCHARGE3),CHARINDEX('' '',REVERSE(INCHARGE3)),len(INCHARGE3))) ELSE CLCARD.INCHARGE3 END as Adi,
CASE WHEN CHARINDEX('' '',CLCARD.INCHARGE3)>0 THEN
   RIGHT(CLCARD.INCHARGE3, CHARINDEX('' '', REVERSE(CLCARD.INCHARGE3)) - 1) ELSE '''' END AS Soyadi ,
'''' as DogumTarihi,
'''' as TCKimlikNo,
'''' as Unvan,
0 as GorevPozisyonID,
0 as SubeID,
0 as DepartmanID,
'''' as Cinsiyet,
'''' as Dahili,
CLCARD.EMAILADDR3 as EMail,
'''' as Adres,
0 as UlkeID,
0 as SehirID,
0 as IlceID,
'''' as Semt,
'''' as PostaKodu,
0 as DilID
from LG_'+@FirmNr+'_CLCARD CLCARD'

EXECUTE sp_executesql @SQLString