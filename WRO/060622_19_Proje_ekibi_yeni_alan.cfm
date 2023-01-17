<!-- Description : WORKGROUP_EMP_PAR Tablosuna Yeni Alan Eklendi.

Developer: Dilek Özdemir

Company : Workcube

Destination: Main -->

<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@'  AND TABLE_NAME = 'WORKGROUP_EMP_PAR'  AND COLUMN_NAME = 'WEEK_AMOUNT')

        BEGIN

            ALTER TABLE WORKGROUP_EMP_PAR ADD

            WEEK_AMOUNT int NULL

        END

</querytag>