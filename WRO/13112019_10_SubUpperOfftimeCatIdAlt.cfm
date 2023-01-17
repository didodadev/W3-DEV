<!-- Description : İzin kategorileri için Alt Kategori ve Üst Kategori kolonları eklendi.
Developer: Esma R. Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OFFTIME' AND COLUMN_NAME = 'SUB_OFFTIMECAT_ID')
    BEGIN
        ALTER TABLE OFFTIME ADD 
        SUB_OFFTIMECAT_ID int NULL;
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'UPPER_OFFTIMECAT_ID')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD 
        UPPER_OFFTIMECAT_ID int NULL;
    END;
</querytag>