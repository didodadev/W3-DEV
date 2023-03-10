<!-- Description : Holistic.22 period wro
Developer: Fatih Kara
Company : Workcube
Destination: Period -->
<querytag>  
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='SHIP_ROW' AND COLUMN_NAME='WEIGHT')
    BEGIN
        ALTER TABLE SHIP_ROW ADD WEIGHT float NULL;
    END;
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='SHIP_ROW' AND COLUMN_NAME='SPECIFIC_WEIGHT')
    BEGIN
        ALTER TABLE SHIP_ROW ADD SPECIFIC_WEIGHT float NULL;
    END;
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='SHIP_ROW' AND COLUMN_NAME='VOLUME')
    BEGIN
        ALTER TABLE SHIP_ROW ADD VOLUME float NULL;
    END;
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='INVOICE_ROW' AND COLUMN_NAME='WEIGHT')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD WEIGHT float NULL;
    END;
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='INVOICE_ROW' AND COLUMN_NAME='SPECIFIC_WEIGHT')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD SPECIFIC_WEIGHT float NULL;
    END;
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='INVOICE_ROW' AND COLUMN_NAME='VOLUME')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD VOLUME float NULL;
    END;
</querytag>