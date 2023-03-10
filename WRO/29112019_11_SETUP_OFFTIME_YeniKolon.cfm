<!-- Description : SETUP_OFFTIME tablosuna IS_DOCUMENT_REQUIRED  IS_EXPLAIN_REQUIRED ve IS_REPEATABLE_APP bilgilerini tutan kolonlar eklendi
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'IS_DOCUMENT_REQUIRED')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD
        IS_DOCUMENT_REQUIRED [bit] NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'IS_EXPLAIN_REQUIRED')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD
        IS_EXPLAIN_REQUIRED bit NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'IS_REPEATABLE_APP')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD
        IS_REPEATABLE_APP bit NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'WEEKING_WORKING_DAY')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD
        WEEKING_WORKING_DAY int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'MAX_PERMISSION_TIME')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD
        MAX_PERMISSION_TIME int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'IS_PERMISSION_TYPE')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD
        IS_PERMISSION_TYPE int NULL
    END;
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Açıklama Alanı Zorunlu', ITEM_TR='Açıklama Alanı Zorunlu', ITEM_ENG='Explanation field imperative' WHERE DICTIONARY_ID = 59512
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Periyodik İzin Girilebilir', ITEM_TR='Periyodik İzin Girilebilir', ITEM_ENG='Periodical leave penetrable' WHERE DICTIONARY_ID = 41046
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Süresi', ITEM_TR='Süresi', ITEM_ENG='expires in' WHERE DICTIONARY_ID = 41119
</querytag>