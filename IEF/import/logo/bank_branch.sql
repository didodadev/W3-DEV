/* Banka Şube Aktarımı
 settings.form_bank_branch_import */

DECLARE @SQLString NVARCHAR(500);

SET @SQLString = N'SELECT 
	CODE as BankaKodu,
	BRANCH as SubeAdi,
	BRANCHNO SubeKodu,
	CITY AS	Sehir,
	INCHARGE as Yetkili,
	TELNRS1+''/''+TELNRS2 as Telefon,
	(ADDR1+  ADDR2+  DISTRICT+  TOWN) AS	Adres,
	POSTCODE as PostaKodu,
	COUNTRY as Ulke
FROM 
  LG_'+@FirmNr+'_BNCARD AS BNCARD';

EXECUTE sp_executesql @SQLString