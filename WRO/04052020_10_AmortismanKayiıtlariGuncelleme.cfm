<!-- Description : Amortisman eski kayıtlarının muhasebe tercihleri tek düzen olarak güncelleme
Developer: Pınar Yıldız
Company : Workcube
Destination: Company -->
<querytag>
	IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'INVENTORY_AMORTIZATION_MAIN' AND COLUMN_NAME = 'ACCOUNTING_TYPE')
    BEGIN
		UPDATE INVENTORY_AMORTIZATION_MAIN SET ACCOUNTING_TYPE = 0 WHERE ACCOUNTING_TYPE IS NULL
	END
</querytag>