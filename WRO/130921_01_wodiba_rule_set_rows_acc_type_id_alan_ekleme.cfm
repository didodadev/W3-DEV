<!-- Description : Wodiba kural seti tablosuna acc_type_id alanı eklendi.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: main -->

<querytag>
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WODIBA_RULE_SET_ROWS' AND COLUMN_NAME = 'ACC_TYPE_ID' AND TABLE_SCHEMA = '@_dsn_main_@')
    BEGIN
        ALTER TABLE WODIBA_RULE_SET_ROWS ADD ACC_TYPE_ID INT
    END;
</querytag>