<!--Description : Wodiba banka hareketleri tablosuna DOCUMENT_ID alanı eklendi
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main-->
<querytag>
	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WODIBA_BANK_ACTIONS' AND COLUMN_NAME = 'DOCUMENT_ID')
	BEGIN
		ALTER TABLE WODIBA_BANK_ACTIONS ADD [DOCUMENT_ID] [int] NULL
	END;
</querytag>