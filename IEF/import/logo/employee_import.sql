/* Çalışan Aktarım
ehesap.import_employee */

SELECT  Personel.CODE ,
		Personel.NAME, 
		Personel.SURNAME, 
		'' AS KullanicilAdi,
		'' as Eposta,
		(SELECT EXP1 FROM LH_001_CONTACT
		where CARDREF=Personel.LREF and LNNR=1 and typ=6)
		 AS emailKisisel, 
		CONVERT(VARCHAR, Personel.GROUPINDATE, 104) as GurumGirisTarihi,
		'' AS KidemTarihi,
		'' AS IzinTarihi,
		PerKimlik.IDTCNO, 
		Personel.SSKNO,
		(case when PerKimlik.STATUS=1 then 1 else 0 end ) as MedeniDurum ,
		case when sex=2 then 0 else sex end Cinsiyet,
		PerKimlik.RELIGION, 
		PerKimlik.SERIALNO,
		PerKimlik.NO_, 
		PerKimlik.DADDY, 
		PerKimlik.MUMMY,
		CONVERT(VARCHAR, Personel.BIRTHDATE, 104) as DogumTarihi,
		PerKimlik.BIRTHPLACE,
		PerKimlik.EXSURNAME,
		PerKimlik.CITY, 
		PerKimlik.TOWN, 
		PerKimlik.VILLAGE AS Mahalle,
		PerKimlik.VILLAGE AS Koy,
		PerKimlik.BOOK,
		PerKimlik.PAGE, 
		PerKimlik.ROW_,
		PerKimlik.GIVENPLACE, 
		PerKimlik.GIVENREASON,
		PerKimlik.REGNO,
		PerKimlik.GIVENDATE, 
		(SELECT EXP1 FROM LH_001_CONTACT
		where CARDREF=Personel.LREF and LNNR=1 and typ=1) as Adres,
		(SELECT EXP1 AS PostaKodu FROM LH_001_CONTACT
		where CARDREF=Personel.LREF and LNNR=7 and typ=-1)as PostaKodu,
		(SELECT UPPER(EXP1) FROM LH_001_CONTACT
		where CARDREF=Personel.LREF and LNNR=8 and typ=-1) as Ilce,
		(SELECT UPPER(EXP1) FROM LH_001_CONTACT
		where CARDREF=Personel.LREF and LNNR=9 and typ=-1) as Sehir,
		'' as Ulke,
		'' EvTelAlanKodu,
		(SELECT EXP1 FROM LH_001_CONTACT
		where CARDREF=personel.LREF and LNNR=1 and typ=2) as Telefon,
		(SELECT EXP1 AS Dahili FROM LH_001_CONTACT
		where CARDREF=Personel.LREF and LNNR=1 and TYP=-2) as Dahili,
		'' MobilAlanKodu,
		(SELECT EXP1 AS Mobile FROM LH_001_CONTACT
		where CARDREF=Personel.LREF and LNNR=1 and typ=3) MobilTel,
		'' MobilAlanKoduKisisel,
		(SELECT EXP1 AS Mobile FROM LH_001_CONTACT
		where CARDREF=Personel.LREF and LNNR=2 and typ=3) MobilTelKisisel,
		PerKimlik.BLOODGROUP - 1 AS KanGrubu,
		(case when MILTSTATUS=2 then 1 when MILTSTATUS=3 then 2 when MILTSTATUS=1 then 4 else 0 end) as Askerlik,
		0 as OgreninDurumu,
		Personel.SPECIALCODE
FROM    LH_001_PERSON AS Personel LEFT OUTER JOIN
        LH_001_PERIDINF AS PerKimlik ON Personel.LREF = PerKimlik.LREF