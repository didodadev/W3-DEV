/* Çalışan Eğitim Bilgileri Aktarım
ehesap.import_employee_edu_info */
DECLARE @SQLString NVARCHAR(max)

SET @SQLString = N'SELECT 
		 KIMLIK.MERNISNO TCKimlikNo,
		 6 OkulTürü, 
		 TAHSIL.ILKOKULISMI OkulAdi,
		 '''' OkulID , 
		 '''' BölümAdi,  
		 '''' BölümID,  
		 '''' GirisYili,
		 TAHSIL.ILKBITISYILI MezuniyetYili,
		 0 NotOrt,
		 '''' EgitimDili,
		 ''''  EgitimSuresi
		from TBLTAHSIL TAHSIL INNER JOIN TBLKIMLIK KIMLIK
		ON TAHSIL.OZLUKID=KIMLIK.OZLUKID
		WHERE LEN(LTRIM(TAHSIL.ILKOKULISMI))>0
			UNION
		select
		 KIMLIK.MERNISNO TCKimlikNo,
		 1 OkulTürü, 
		 TAHSIL.LISEOKULISMI OkulAdi,
		 0 OkulID , 
		 (SELECT BOLUM_ISIM FROM TBLLISEBOLUMU WHERE LISEBOLUMU=TAHSIL.LISEBOLUMU) BölümAdi,  
		 TAHSIL.LISEBOLUMU BölümID,  
		 '''' GirisYili,
		 TAHSIL.LISEBITISYILI MezuniyetYili,
		 TAHSIL.LISEDERECE NotOrt,
		 '''' EgitimDili,
		 ''''  EgitimSuresi
		from TBLTAHSIL TAHSIL INNER JOIN TBLKIMLIK KIMLIK
		ON TAHSIL.OZLUKID=KIMLIK.OZLUKID
		WHERE LEN(LTRIM(TAHSIL.LISEOKULISMI))>0
					UNION
		select
		 KIMLIK.MERNISNO TCKimlikNo,
		 3 OkulTürü,
		 (SELECT UNIVERSITE_ISIM from TBLUNIVERSITE where UNIVERSITEID=TAHSIL.LISANS1UNIVERSITE)  OkulAdi,
		 TAHSIL.LISANS1UNIVERSITE OkulID , 
		 (SELECT BOLUM_ISIM from TBLUNVBOLUM where STR(BOLUMID)=TAHSIL.LISANS1BOLUM)   BölümAdi,  
		 TAHSIL.LISANS1BOLUM BölümID,  
		 TAHSIL.LISANS1BASYIL GirisYili,
		 TAHSIL.LISANS1BITYIL MezuniyetYili,
		 TAHSIL.LISEDERECE NotOrt,
		 '''' EgitimDili,
		 '''' EgitimSuresi
		from TBLTAHSIL TAHSIL INNER JOIN TBLKIMLIK KIMLIK
		ON TAHSIL.OZLUKID=KIMLIK.OZLUKID
					UNION
		select
		 KIMLIK.MERNISNO TCKimlikNo,
		 3 OkulTürü,
		 (SELECT UNIVERSITE_ISIM from TBLUNIVERSITE where UNIVERSITEID=TAHSIL.LISANS2UNIVERSITE)  OkulAdi,
		 TAHSIL.LISANS2UNIVERSITE OkulID , 
		 (SELECT BOLUM_ISIM from TBLUNVBOLUM where STR(BOLUMID)=TAHSIL.LISANS2BOLUM)   BölümAdi,  
		 TAHSIL.LISANS2BOLUM BölümID,  
		 TAHSIL.LISANS2BASYIL GirisYili,
		 TAHSIL.LISANS2BITYIL MezuniyetYili,
		 TAHSIL.LISEDERECE NotOrt,
		 '''' EgitimDili,
		 '''' EgitimSuresi
		from TBLTAHSIL TAHSIL INNER JOIN TBLKIMLIK KIMLIK
		ON TAHSIL.OZLUKID=KIMLIK.OZLUKID
					UNION
		select
		 KIMLIK.MERNISNO TCKimlikNo,
		 3 OkulTürü, 
		 (SELECT UNIVERSITE_ISIM from TBLUNIVERSITE where UNIVERSITEID=TAHSIL.LISANS3UNIVERSITE)  OkulAdi,
		 TAHSIL.LISANS3UNIVERSITE OkulID , 
		 (SELECT BOLUM_ISIM from TBLUNVBOLUM where STR(BOLUMID)=TAHSIL.LISANS3BOLUM)   BölümAdi,  
		 TAHSIL.LISANS3BOLUM BölümID,  
		 TAHSIL.LISANS3BASYIL GirisYili,
		 TAHSIL.LISANS3BITYIL MezuniyetYili,
		 TAHSIL.LISEDERECE NotOrt,
		 '''' EgitimDili,
		 '''' EgitimSuresi
		from TBLTAHSIL TAHSIL INNER JOIN TBLKIMLIK KIMLIK
		ON TAHSIL.OZLUKID=KIMLIK.OZLUKID
					UNION
		select
		 KIMLIK.MERNISNO TCKimlikNo,
		 4 OkulTürü, 
		 (SELECT UNIVERSITE_ISIM from TBLUNIVERSITE where UNIVERSITEID=TAHSIL.YUKSEKUNIVERSITE)  OkulAdi,
		 TAHSIL.YUKSEKUNIVERSITE OkulID , 
		 (SELECT BOLUM_ISIM from TBLUNVBOLUM where STR(BOLUMID)=TAHSIL.YUKSEKBOLUM)   BölümAdi,  
		 TAHSIL.YUKSEKBOLUM BölümID,  
		 TAHSIL.YUKSEKBASYIL GirisYili,
		 TAHSIL.YUKSEKBITYIL MezuniyetYili,
		 TAHSIL.YUKSEKDERECE NotOrt,
		 '''' EgitimDili,
		 '''' EgitimSuresi
		from TBLTAHSIL TAHSIL INNER JOIN TBLKIMLIK KIMLIK
		ON TAHSIL.OZLUKID=KIMLIK.OZLUKID
			UNION
		select
		 KIMLIK.MERNISNO TCKimlikNo,
		 5 OkulTürü, -- (  DOKTORA=5   )
		 (SELECT UNIVERSITE_ISIM from TBLUNIVERSITE where UNIVERSITEID=TAHSIL.DOKTORAUNIVERSITE)  OkulAdi,
		 TAHSIL.DOKTORAUNIVERSITE OkulID , 
		 (SELECT BOLUM_ISIM from TBLUNVBOLUM where STR(BOLUMID)=TAHSIL.DOKTORABOLUM)   BölümAdi,  
		 TAHSIL.DOKTORABOLUM BölümID,  
		 '''' GirisYili,
		 TAHSIL.DOKTORABITYIL MezuniyetYili,
		 0 NotOrt,
		 '''' EgitimDili,
		 '''' EgitimSuresi
	FROM TBLTAHSIL TAHSIL INNER JOIN TBLKIMLIK KIMLIK
	ON TAHSIL.OZLUKID=KIMLIK.OZLUKID'

EXECUTE sp_executesql @SQLString		 