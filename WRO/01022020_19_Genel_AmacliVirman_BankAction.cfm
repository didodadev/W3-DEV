<!--Description : Genel Amaçlı Virmana İçin bank action alanı
Developer: Tolga Sütlü
Company : Devonomy
Destination: Period-->
<querytag>
	    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'BANK_ACTIONS' AND COLUMN_NAME = 'GENEL_VIRMAN_ID')
        BEGIN
                ALTER TABLE BANK_ACTIONS ADD 
                GENEL_VIRMAN_ID  int NULL
        END;
</querytag>


		


