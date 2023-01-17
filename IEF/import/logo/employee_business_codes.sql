/*
Bordro Databaselerinden bilgi alır
Çalışan Meslek Kodu Aktarım
ehesap.import_employee_business_codes
*/
DECLARE @SQLString NVARCHAR(500)

SET @SQLString = N'SELECT 
	KIMLIK.MERNISNO TCKIMLIKNO,
	REPLACE(OZLUK.MESLEGI,'' '',''.'') MeslekKodu
FROM TBLOZLUK OZLUK INNER JOIN TBLKIMLIK KIMLIK
ON OZLUK.OZLUKID=KIMLIK.OZLUKID'

EXECUTE sp_executesql @SQLString