/*
Bordro Databaselerinden bilgi alır
Görev Değişikliği Aktarım
ehesap.import_employee_position_history
*/
DECLARE @SQLString NVARCHAR(max)

SET @SQLString = N'SELECT 
		PERIDINF.IDTCNO as TcKimlikNo,
		ASSIGN.DEPTNR as DepartmanID,
		ASSIGN.TITLE as PozisyonAdi,
		0 as PozisyonTipiID,
		CONVERT(VARCHAR, ASSIGN.BEGDATE , 104)  Baslamatarihi, 
		CONVERT(VARCHAR, ASSIGN.ENDDATE , 104)  Bitistarihi, 
		0 as FonksiyonId,
		(SELECT A.LREF  FROM LH_'+@FirmNr+'_QUALFDEF A WHERE A.CODE=ASSIGN.PERTITLE) as Unvanİd,
		0 as GerekceID,
		0 as Kademeİd,
		0 as YakaTipiID
FROM    LH_'+@FirmNr+'_PERIDINF AS PERIDINF RIGHT OUTER JOIN
        LH_'+@FirmNr+'_PERSON AS PERSON ON PERIDINF.LREF = PERSON.LREF LEFT OUTER JOIN
        LH_'+@FirmNr+'_ASSIGN AS ASSIGN ON PERSON.LREF = ASSIGN.PERREF
WHERE ASSIGN.EXP IN (''İşe Giriş'',''Pozisyon Değişikliği'')
order by PERSON.LREF,ASSIGN.BEGDATE'

EXECUTE sp_executesql @SQLString

 