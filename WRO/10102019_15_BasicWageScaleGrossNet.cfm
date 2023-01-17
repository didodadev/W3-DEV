<!-- Description : Temel Ücret Skalası Tablosuna Brüt / Net alanını tutan kolon eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='POSITION_WAGE_SCALE' AND COLUMN_NAME='GROSS_NET')
        BEGIN
            ALTER TABLE POSITION_WAGE_SCALE ADD  GROSS_NET bit NULL
        END;
</querytag>