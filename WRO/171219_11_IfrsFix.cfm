<!-- Description : Ifrs Tablosunda Card_row_id alanına null özelliği eklendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'ACCOUNT_ROWS_IFRS' AND COLUMN_NAME = 'CARD_ROW_ID')
        BEGIN
                ALTER TABLE ACCOUNT_ROWS_IFRS 
                ALTER COLUMN CARD_ROW_ID INT NULL
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'ACCOUNT_CARD' AND COLUMN_NAME = 'RECORD_TYPE')
        BEGIN
                ALTER TABLE ACCOUNT_CARD
                ADD RECORD_TYPE INT NULL
        END;
</querytag>