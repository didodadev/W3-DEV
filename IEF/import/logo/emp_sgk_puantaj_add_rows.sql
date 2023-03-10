/*
Bordro Databaselerinden bilgi alır
Çalışan SGK Devir Aktarım
ehesap.import_sgk_puantaj_add_rows
*/

DECLARE @SQLString NVARCHAR(max)

set @SQLString= N'SELECT 
	KIMLIK.MERNISNO as TcKimlikNo,
	OZLUK.ADI+'' ''+OZLUK.IKINCIADI as CalianAdi,
	OZLUK.SOYADI as CalianSoyadi,
	0 as Tutar,
	YEAR(PNTCARD.PERDBEG) as Yıl,
	MONTH(PNTCARD.PERDBEG) as Ay

from TBLOZLUK OZLUK INNER JOIN TBLKIMLIK KIMLIK ON
OZLUK.OZLUKID=KIMLIK.OZLUKID INNER JOIN LH_'+@FirmNr+'_PNTCARD PNTCARD
ON KIMLIK.OZLUKID=PNTCARD.PERREF
ORDER BY PNTCARD.PERREF,YEAR(PNTCARD.PERDBEG),MONTH(PNTCARD.PERDBEG)'

EXECUTE sp_executesql @SQLString