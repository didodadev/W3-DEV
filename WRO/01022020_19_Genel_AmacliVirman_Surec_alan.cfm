<!--Description : Genel Amaçlı Virmana Süreç Alanı
Developer: Tolga Sütlü
Company : Devonomy
Destination: Period-->
<querytag>
	    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'GENEL_VIRMAN' AND COLUMN_NAME = 'PROCESS_STAGE')
        BEGIN
                ALTER TABLE GENEL_VIRMAN ADD 
                PROCESS_STAGE  int NULL
        END;
</querytag>


		


