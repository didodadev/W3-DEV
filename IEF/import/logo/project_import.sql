
/*
LogoGo3/LogoTiger3 Databaselerinden bilgi alır
Proje Aktarım
settings.form_add_project_import
*/
 
DECLARE @SQLString NVARCHAR(MAX)
SET @SQLString = N'SELECT 
		PROJECT.NAME as ProjeAdi,
		'''' as Kategori,
		0 as oncelik,
		0 as İsGrubu,
		PROJECT.CODE as ProjeNo,
		'''' as SozlesmeNo,
		0 as SirketKurumsal,
		0 as SirketBireysel,
		'''' as Aciklama,
		'''' as Hedef,
		0 as TahminiBütce,
		0 as TahminiBütceParaID,
		0 as TahminiMaliyet,
		0 as TahminiMaliyetParaID,
		0 as MasrafGelirMerkezi,
		0 as IliskiliProje,
		PROJECT.BEGDATE as BaslangicTarihi,
		''00:00:00'' as BaslangicSaati,
		PROJECT.ENDDATE as BitisTarihi,
		''23:59:00'' as BitisSaati,
		PROJECT.PRJRESPON as Gorevli,
		0 as Asama

		from LG_'+@FirmNr+'_PROJECT PROJECT'

EXECUTE sp_executesql @SQLString

 