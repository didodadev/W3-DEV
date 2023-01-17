<!-- Description : Ship_row tablosuna gtip number eklendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>  
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='SHIP_ROW' AND COLUMN_NAME='GTIP_NUMBER')
    BEGIN
        ALTER TABLE SHIP_ROW ADD GTIP_NUMBER nvarchar(100);
    END;
</querytag>