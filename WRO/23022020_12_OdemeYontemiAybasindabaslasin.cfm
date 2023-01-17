<!-- Description : Ödeme Yöntemine vade ay başında başlasın seçeneği
Developer: Tolga Sütlü
Company : Devonomy
Destination: Main-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PAYMETHOD' AND COLUMN_NAME = 'IS_DUE_BEGINOFMONTH')
        BEGIN
                ALTER TABLE SETUP_PAYMETHOD ADD 
                IS_DUE_BEGINOFMONTH  bit NULL
        END;
</querytag>