/*
Bordro Databaselerinden bilgi alır
Çalışan Geçmiş Dönem İzin Aktarımı
ehesap.import_employee_offdays
*/
DECLARE @SQLString NVARCHAR(max)

SET @SQLString = N'SELECT 
		ROW_NUMBER() OVER(ORDER BY OZLUK.OZLUKID) AS SiraNo,
		KIMLIK.MERNISNO as TCKimlikNo,
		OZLUK.ADI+'' ''+OZLUK.IKINCIADI as CalısanAdi,
		OZLUK.SOYADI as CalisanSoyadi,
		(SELECT ISNULL(SUM(TALEPGUN),0)FROM TBLDEVAMSIZLIK WHERE (GERCEKLESME = ''K'') AND (UCRETLIMI = ''E'') AND TBLDEVAMSIZLIK.OZLUKID=OZLUK.OZLUKID) as Gun
	FROM TBLOZLUK OZLUK INNER JOIN TBLKIMLIK KIMLIK ON 
	OZLUK.OZLUKID=KIMLIK.OZLUKID' 

EXECUTE sp_executesql @SQLString
