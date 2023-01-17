<!-- Description : SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS, SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION TABLOLARINA YENİ ALANLAR EKLENDI
Developer: Botan Kaygan
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'SETUP_COMPLAINT_ID')
    BEGIN
        ALTER TABLE SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS ADD
        SETUP_COMPLAINT_ID int NULL;
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'DRUG_ID')
    BEGIN
        ALTER TABLE SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION ADD
        DRUG_ID int NULL;
    END;
</querytag>