/*
Bordro Databaselerinden bilgi alır
İşe Giriş Aktarım
ehesap.import_employee_position_in
*/
DECLARE @SQLString NVARCHAR(max)

SET @SQLString = N'SELECT 
	PERSON.TTFNO as TCKimlikNo,
	PERSON.DEPTNR as DepartmanID,
	0 as UcretTipi,
	(case when PERFIN.WAGE_CLCTYPE=2 then 0 else 1 end)  as BrutNet,
	(case when PERFIN.WAGE_OPTYPE=3 then 0 when PERFIN.WAGE_OPTYPE=2 then 1 when PERFIN.WAGE_OPTYPE=1 then 2 end )  as UcretYonetimi,
	(case when PERFIN.SSKSTATUS in (2,9) then 2 else 1 end)  as SGKStatusu,
	0  as Puantaj,
	(case when PERSON.WORKTYPE=1 then 1 else 2 end) as GorevTipi,
	(case when PERFIN.SSKSTATUS in (0,8,9) then 0 else 1 end)  as SGK,
	PERSON.SSKNO  as SGKNo,
	''''  as TahsisNo,
	(SELECT UNNO FROM LH_'+@FirmNr+'_PERUNION WHERE PERREF=PERSON.LREF )  as SendikaNo,
	''''  as PDKSBaglilikTipi,
	''''  as PDKSNo,
	''''  as PdksTipi,
	''''  as Vardiya,
	''''  as KurumsalUye,
	(SELECT MESLEGI from TBLOZLUK where OZLUKID=PERSON.LREF)  as MeslekKodu,
	CONVERT(VARCHAR, PERSON.LOCINDATE , 104)  IseGirisTarihi, 
	CONVERT(VARCHAR, PERSON.OUTDATE , 104)  IstenCikisTarihi, 
	(SELECT OUTREASON FROM LH_'+@FirmNr+'_LAWCHG A WHERE A.PERREF=PERSON.LREF AND TYP=2) as IstenCikisGerekceId

FROM     LH_'+@FirmNr+'_PERSON AS PERSON LEFT OUTER JOIN
         LH_'+@FirmNr+'_PERFIN AS PERFIN ON PERSON.LREF = PERFIN.PERREF'

EXECUTE sp_executesql @SQLString


 
 

