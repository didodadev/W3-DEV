<!-- Description : Alış irsaliyesine işlem tarihi alanı eklendi
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' and TABLE_NAME='SHIP' AND COLUMN_NAME='ACTION_DATE' )
    BEGIN   
        ALTER TABLE SHIP ADD ACTION_DATE datetime NULL 
    END;
</querytag>