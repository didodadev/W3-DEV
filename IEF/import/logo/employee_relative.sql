/*
Bordro Databaselerinden bilgi alır
Çalışan Yakını Aktarım
ehesap.import_employee_relative
*/

DECLARE @SQLString NVARCHAR(max)

SET @SQLString = N'SELECT 
	OZLUK.OZLUKKODU CalisanNo,
	OZLUK.ADI+'' ''+OZLUK.IKINCIADI CalisanAdi,
	OZLUK.ILKSOYADI+'' ''+OZLUK.SOYADI  CalisanSoyadi,
	YAKIN.MERNISNO CalisanYakiniTCKimlikNo,
	YAKIN.ADI   CalisanYakinAdi,
	YAKIN.SADI   CalisanYakinSoyadi,
	CASE WHEN YAKIN.TUR=1 THEN 3 WHEN YAKIN.TUR=15 THEN 6
		 WHEN YAKIN.TUR=2 THEN 2 WHEN YAKIN.TUR=3 THEN 1 
		 WHEN YAKIN.TUR IN (4,5,6,7,8,9,10,11,12,13) AND YAKIN.CINSIYET=''E'' THEN 4 
		 WHEN YAKIN.TUR IN (4,5,6,7,8,9,10,11,12,13) AND YAKIN.CINSIYET=''K'' THEN 5  
	END	 CalisanYakinlikDerecesi,
	CONVERT(VARCHAR, YAKIN.EVLILIKTAR , 104)  EvlilikTarihi, 
	YAKIN.MERNISNO CalisanYakiniTCKimlikNo,
	CASE WHEN YAKIN.CINSIYET=''E'' THEN 1 ELSE 0 END  CalisanYakinCinsiyeti, 
	CONVERT(VARCHAR, YAKIN.DTAR , 104)  CalisanYakınDoğumTarihi,  
	YAKIN.DYER CalisanYakinDoğumYeri,
	FAMILY.MINWGDISCSTAT CalisanYakinVergiDurumu, 
	 ''''  GeçerlilikTarihi, 
	CASE WHEN FAMILY.EDUCSTAT=1 THEN 1 ELSE 0 END OkuyorOkumuyor, 
	 '''' CocukYardimi,  
	 '''' Malül,  
	 '''' Evli, 
	 '''' KurumCalisani, 
	 '''' Emekli, 
	CASE WHEN YAKIN.CALISMADURUM=''E'' THEN 1 ELSE 0 END   Calisiyor, 
	 '''' EgitimDurumu, 
	 '''' KresYardimi, 
	 '''' Taahhütname, 
	 '''' Police 
FROM   TBLES_COCUK YAKIN INNER JOIN
       TBLOZLUK OZLUK ON  YAKIN.OZLUKID = OZLUK.OZLUKID INNER JOIN 
	   LH_'+@FirmNr+'_FAMILY FAMILY ON FAMILY.LREF=YAKIN.FAMILY_ID
	   WHERE YAKIN.TUR <=13'


EXECUTE sp_executesql @SQLString
