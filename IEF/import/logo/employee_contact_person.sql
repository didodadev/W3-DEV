/*
Bordro Databaselerinden bilgi alır
Bağlantı Kurulacak Kişi Aktarım
ehesap.import_employee_contact_person
*/
DECLARE @SQLString NVARCHAR(max)

SET @SQLString =N'select
		OZLUK.ADI+'' ''+OZLUK.IKINCIADI+'' ''+OZLUK.SOYADI as CalisanAdSoyad,
		KIMLIK.MERNISNO as  TCKimlikNo,
		YAKIN.ADI+'' ''+YAKIN.SADI as BaglantiKurulacakKisi,
		'''' as Yakinlik,
		'' '' TelKod,
		YAKIN.CEPTEL as Tel,
		YAKIN.EMAIL as Eposta
	FROM TBLES_COCUK YAKIN INNER JOIN TBLOZLUK OZLUK
	ON YAKIN.OZLUKID=OZLUK.OZLUKID INNER JOIN TBLKIMLIK KIMLIK
	ON OZLUK.OZLUKID=KIMLIK.OZLUKID
WHERE TUR=14'

EXECUTE sp_executesql @SQLString