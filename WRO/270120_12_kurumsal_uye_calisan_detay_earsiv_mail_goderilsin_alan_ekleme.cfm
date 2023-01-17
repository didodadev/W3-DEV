<!-- Description : Kurum üye çalışan detayına earşiv mailleri gönderilsin seçeneği eklendi
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'COMPANY_PARTNER' AND COLUMN_NAME = 'IS_SEND_EARCHIVE_MAIL')
    BEGIN
        ALTER TABLE COMPANY_PARTNER ADD IS_SEND_EARCHIVE_MAIL bit NULL
    END;
</querytag>