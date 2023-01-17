<!-- Description : Content Banners Users tablosuna Carrier Id alanı eklendi.
Developer: Dilek Özdemir
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONTENT_BANNERS_USERS' AND COLUMN_NAME = 'CARRIER_ID'
    )
	BEGIN
        ALTER TABLE CONTENT_BANNERS_USERS ADD
        CARRIER_ID integer NULL
    END;
</querytag>
