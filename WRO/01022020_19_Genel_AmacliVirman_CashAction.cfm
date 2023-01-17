<!--Description : Genel Amaçlı Virmana İçin cash action a GENEL_VIRMAN_ID alanı
Developer: Tolga Sütlü
Company : Devonomy
Destination: Period-->
<querytag>
	    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'CASH_ACTIONS' AND COLUMN_NAME = 'GENEL_VIRMAN_ID')
        BEGIN
                ALTER TABLE CASH_ACTIONS ADD 
                GENEL_VIRMAN_ID  int NULL
        END;
</querytag>


		


