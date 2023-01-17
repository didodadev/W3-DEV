<!-- Description : Ülkelere tablosuna tc ve vkn karakter sayısı eklendi.
Developer: Fatih Kara
Company : Workcube
Destination: Main-->
<querytag>
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_COUNTRY' AND COLUMN_NAME = 'TC_CHARNUMBER')
BEGIN
        ALTER TABLE SETUP_COUNTRY ADD 
        TC_CHARNUMBER int NULL
END;
IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_COUNTRY' AND COLUMN_NAME = 'VKN_CHARNUMBER')
BEGIN
        ALTER TABLE SETUP_COUNTRY ADD 
        VKN_CHARNUMBER int NULL
END;
</querytag>


		


