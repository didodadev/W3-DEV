<!-- Description :  Masraf ekranlarına Harcama Tarihi için yeni alan açıldı
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EXPENSE_ITEMS_ROWS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME='RECEIPT_DATE')
    BEGIN
        ALTER TABLE EXPENSE_ITEMS_ROWS ADD 
        RECEIPT_DATE datetime NULL
    END;
</querytag>