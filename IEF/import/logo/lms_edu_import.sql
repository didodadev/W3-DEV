--BORDRO PLUS-TIGERIK LMS Eğitim Aktarımı settings.form_add_edu_import
DECLARE @SQLString NVARCHAR(max)
 
SET @SQLString = N'select 

		EGITIM.ACIKLAMA as EgitiminAdı,
		(select KATEGORI from TBLEGTTANIM A  where a.KOD=EGITIM.EGTKOD) as KategoriID,
		''as BolumID,
		''as EgitimSekliID,
		DATEDIFF(DAY,EGITIM.TARIH,EGITIM.BITTAR) as ToplamGun,
		DATEDIFF(HOUR,EGITIM.BASSAAT,EGITIM.BITSAAT) as ToplamSaat,
		EGTMEKAN.ACIKLAMA as EgitimYeri,
		(SELECT TOP 1 EGITMENID  FROM TBLEGTGERCEKEGITMEN A WHERE A.EGTGERCEKID=EGITIM.EGTGERCEKID)  as EgitimciÇalısanID,
		0 as EgitimciKurumsaluyeCalisanID,
		0 as EgitimciBireyseluyeCalisanID,
		''   as EgitimYeriSorumlusu,
		EGTMEKAN.ADRES as EgitimYeriAdresi,
		'' as EgitimYeriTel,
		0 as ProjeID,
		 CONVERT(VARCHAR, EGITIM.TARIH, 104)as EgitimBaslangıçTarihi,
		  CONVERT(VARCHAR(5), EGITIM.BASSAAT, 8)as EgitimBaslangıçSaati,
		CONVERT(VARCHAR, EGITIM.BITTAR , 104)as EgitimBitisTarihi,
		  CONVERT(VARCHAR(5), EGITIM.BITSAAT, 8)as EgitimBitisSaati,
		1 as EgitimiGorecekler

FROM  TBLEGTGERCEKMEKAN MEKAN INNER JOIN
      TBLEGTMEKAN EGTMEKAN ON MEKAN .MEKAN_KODU = EGTMEKAN.KOD RIGHT OUTER JOIN
      TBLEGTGERCEK EGITIM ON MEKAN .EGTGERCEKID = EGITIM.EGTGERCEKID'

EXECUTE sp_executesql @SQLString