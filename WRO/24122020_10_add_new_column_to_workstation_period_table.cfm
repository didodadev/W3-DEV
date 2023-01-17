<!-- Description : WORKSTATION_PERIOD tablosuna yeni kolon eklendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: COMPANY -->

<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WORKSTATION_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='STATION_ID')
    BEGIN
        ALTER TABLE WORKSTATION_PERIOD ADD STATION_ID [int] NOT NULL
    END;
</querytag>