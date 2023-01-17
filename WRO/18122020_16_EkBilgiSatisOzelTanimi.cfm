<!-- Description : Ek bilgi tanım sayfasına satış teklifleri için özel tanım seçeneği eklendi.
Developer: Yücel Aydın
Company : Mifa Bilgi Sistemleri
Destination: Company -->
<querytag>
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_PRO_INFO_PLUS_NAMES' AND COLUMN_NAME = 'SALES_ADD_OPTION')
    BEGIN
        ALTER TABLE SETUP_PRO_INFO_PLUS_NAMES ADD SALES_ADD_OPTION nvarchar(150)
    END;
</querytag>