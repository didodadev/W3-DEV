<!-- Description : Ödeme Yöntemine Sonraki Gün özelliği eklendi
Developer: Tolga Sütlü
Company : Devonomy
Destination: Main-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PAYMETHOD' AND COLUMN_NAME = 'NEXT_DAY')
        BEGIN
                ALTER TABLE SETUP_PAYMETHOD ADD 
                NEXT_DAY  int NULL
        END;
</querytag>


		


