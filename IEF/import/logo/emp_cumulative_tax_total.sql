/*
Bordro Databaselerinden bilgi alır
Kümülatif Vergi Matrahı Aktarım
ehesap.import_cumulative_tax_total
*/

DECLARE @SQLString NVARCHAR(max)

SET @SQLString = N'SELECT 

				ROW_NUMBER() OVER(ORDER BY PERSON.LREF) AS SiraNo,
				PERIDINF.IDTCNO as TCKimlikNo,
				PERSON.NAME+'' ''+ PERSON.MIDNAME as CalisanAdi,
				PERSON.SURNAME as CalisanSoyadi,
				PERFIN.TAXTOTAL as KumuleVergiMatrahi,
				0 as KumuleVergiTutari,
				0 as Bordro

FROM            LH_'+@FirmNr+'_PERFIN AS PERFIN INNER JOIN
                         LH_'+@FirmNr+'_PERSON AS PERSON ON PERFIN.PERREF = PERSON.LREF INNER JOIN
                         LH_'+@FirmNr+'_PERIDINF AS PERIDINF ON PERSON.LREF = PERIDINF.LREF'


EXECUTE sp_executesql @SQLString