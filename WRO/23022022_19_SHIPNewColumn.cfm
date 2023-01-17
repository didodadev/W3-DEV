<!-- Description : SHIP WRO
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Period -->

<querytag>   
IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' and TABLE_NAME='SHIP' AND COLUMN_NAME='COUNTRY_ID' )
    BEGIN   
        ALTER TABLE SHIP ADD COUNTRY_ID int NULL
    END;
</querytag> 