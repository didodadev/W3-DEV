/*
Logo CRM Databaselerinden bilgi alır
Kurumsal Çalışan Aktarımı
settings.form_add_company_partner_import
*/ 
DECLARE @SQLString NVARCHAR(max)

SET @SQLString = N'SELECT 
	Contact.RelatedFirm as KurumsalUyeID,
	Contact.FirstName+'' ''+ Contact.MiddleName as Adi,
	Contact.LastName as Soyadi,
	CONVERT(VARCHAR, Contact.Birthday, 104) as DogumTarihi,
	'''' as TCKimlikNo,
	(select JobTitleName from CT_Job_Titles where Oid=Contact.JobTitle) as Unvan,
	0 as GorevPozisyonID,
	0 as SubeID,
	0 as DepartmanID,
	0 as Cinsiyet,
	Phone.Extension as Dahili,
	Contact.EmailAddress1 as EMail,
	Contact.Addresses as Adres,
	0 as UlkeID,
	0 as SehirID,
	0 as IlceID,
	'''' as Semt,
	'''' as PostaKodu,
	0 as DilID

from MT_Contact Contact  INNER JOIN  PO_Phone_Number Phone on Contact.Oid=Phone.RelatedContact'

EXECUTE sp_executesql @SQLString

 
 