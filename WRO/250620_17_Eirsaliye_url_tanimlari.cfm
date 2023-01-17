<!-- Description : Eirsaliye live ve test url leri dinamik ayarlardan okunması için tabloya alanlar eklendi
Developer: Halit Yurttas<halityurttas@gmail.com>
Company : Workcube
Destination: Main-->
<querytag>
   
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ESHIPMENT_INTEGRATION_INFO' AND COLUMN_NAME = 'ESHIPMENT_LIVE_URL')
        BEGIN
                ALTER TABLE ESHIPMENT_INTEGRATION_INFO ADD
                ESHIPMENT_LIVE_URL nvarchar(500) NULL,
                ESHIPMENT_TEST_URL nvarchar(500) NULL
        END
</querytag>