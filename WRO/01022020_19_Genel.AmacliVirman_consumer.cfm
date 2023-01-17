<!--Description : Genel Amaçlı Virmana Consumer ID alanı eklendi
Developer: Tolga Sütlü
Company : Devonomy
Destination: Period-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'VIRMAN_ROWS' AND COLUMN_NAME = 'CONSUMER_ID')
        BEGIN
                ALTER TABLE VIRMAN_ROWS ADD 
                CONSUMER_ID  int NULL
        END;
</querytag>


		


