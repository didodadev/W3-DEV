<!--Description : Faturalara intaç tarihi eklendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Period-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'INVOICE' AND COLUMN_NAME = 'REALIZATION_DATE')
        BEGIN
        ALTER TABLE INVOICE ADD 
        REALIZATION_DATE DATETIME
        END;
</querytag>