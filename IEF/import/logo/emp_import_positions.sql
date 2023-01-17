/*
Bordro Databaselerinden bilgi alır
Pozisyon Aktarım
ehesap.import_positions
*/
  
DECLARE @SQLString NVARCHAR(max)

SET @SQLString = N'SELECT 

				PERIDINF.IDTCNO as TCKimlikNo,
				STAFFENT.CODE as PozisyonAdlari,
				STAFFENT.MNGTYPE as PozisyonTipiID,
				PREFIX as UnvanID,
				'''' as FonksiyonId,
				'''' as KademeId,
				'''' as YakaTipi,
				'''' as YakaTipi,
				'''' as Master,
				1 as OrgSemadaGoster,
				'''' as GerekceID,
				PERSON.DEPTNR as DepartmanID

FROM            LH_'+@FirmNr+'_PERSON AS PERSON INNER JOIN
                         LH_'+@FirmNr+'_PERIDINF AS PERIDINF ON PERSON.LREF = PERIDINF.LREF LEFT OUTER JOIN
                         LH_'+@FirmNr+'_STAFFENT STAFFENT ON PERSON.LREF = STAFFENT.LREF'

EXECUTE sp_executesql @SQLString