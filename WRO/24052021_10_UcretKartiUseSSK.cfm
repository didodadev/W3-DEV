<!-- Description : Çalışan ücret kartı USE_SSK Alanı int e çevirildi.
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_IN_OUT' AND COLUMN_NAME = 'USE_SSK')
    BEGIN
        DECLARE @default_name  VARCHAR(555);
        DECLARE @Command  VARCHAR(555);


        SET @default_name = (SELECT name FROM sys.objects 
        WHERE 
        type_desc LIKE '%CONSTRAINT' 
        and type = 'D' 
        and name LIKE 'DF__EMPLOYEES__USE_S__%'
        and SCHEMA_NAME(schema_id) = '@_dsn_main_@'
        and OBJECT_NAME(parent_object_id) = 'EMPLOYEES_IN_OUT')

        select @Command = 'ALTER TABLE EMPLOYEES_IN_OUT DROP CONSTRAINT '+@default_name
        IF EXISTS (SELECT @default_name)
        BEGIN
            execute(@Command);
            ALTER TABLE @_dsn_main_@.EMPLOYEES_IN_OUT
            ALTER COLUMN USE_SSK INT
        END;
    END;
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_IN_OUT_HISTORY' AND COLUMN_NAME = 'USE_SSK')
    BEGIN
        DECLARE @default_name_2  VARCHAR(555);
        DECLARE @Command_2  VARCHAR(555);


        SET @default_name_2 = (SELECT name FROM sys.objects 
        WHERE 
        type_desc LIKE '%CONSTRAINT' 
        and type = 'D' 
        and name LIKE 'DF__EMPLOYEES__USE_S__%'
        and SCHEMA_NAME(schema_id) = '@_dsn_main_@'
        and OBJECT_NAME(parent_object_id) = 'EMPLOYEES_IN_OUT_HISTORY')

        select @Command_2 = 'ALTER TABLE @_dsn_main_@.EMPLOYEES_IN_OUT_HISTORY DROP CONSTRAINT '+@default_name_2
        IF EXISTS (SELECT @default_name_2)
        BEGIN
            execute(@Command_2);
            ALTER TABLE @_dsn_main_@.EMPLOYEES_IN_OUT_HISTORY
            ALTER COLUMN USE_SSK INT
        END;
    END;
</querytag>