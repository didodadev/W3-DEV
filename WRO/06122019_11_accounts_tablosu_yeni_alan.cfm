<!-- Description : ACCOUNTS tablosuna IS_CIVIL alanı eklendi
Developer: Canan Ebret
Company : Workcube
Destination: Company-->
<querytag>
   
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'ACCOUNTS' AND COLUMN_NAME = 'IS_CIVIL')
        BEGIN
        ALTER TABLE ACCOUNTS ADD 
        IS_CIVIL bit NULL
        END

</querytag>