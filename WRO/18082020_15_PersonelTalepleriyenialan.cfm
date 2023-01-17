<!--Description : Personel Talepleri sayfasına talep edilen pozisyon alanı eklendi.
Developer: Gulbahar Inan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PERSONEL_REQUIREMENT_FORM' AND COLUMN_NAME = 'DEMAND_POSITION_ID')
    BEGIN
        ALTER TABLE PERSONEL_REQUIREMENT_FORM ADD DEMAND_POSITION_ID int
    END
</querytag>