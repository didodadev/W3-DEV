<!-- Description :  New Column for Married, Disabled and Corporation Employee in EMPLOYEES_RELATIVES table. Add Child help column in 
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'SHOW_ENTITLEMENTS')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD
        SHOW_ENTITLEMENTS int NULL
    END
    UPDATE SETUP_LANGUAGE_TR SET ITEM='İzin ekranında hak edişi göster', ITEM_TR='İzin ekranında hak edişi göster', ITEM_ENG='Show entitlements on leave screen' WHERE DICTIONARY_ID = 33623
</querytag>