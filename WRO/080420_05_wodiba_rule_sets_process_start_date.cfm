<!-- Description : Wodiba kural seti tablosuna kayıt başlangıç tarihi alanı eklendi.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WODIBA_RULE_SETS' AND COLUMN_NAME = 'PROCESS_START_DATE')
    BEGIN
        ALTER TABLE WODIBA_RULE_SETS ADD PROCESS_START_DATE datetime NULL
    END;
</querytag>