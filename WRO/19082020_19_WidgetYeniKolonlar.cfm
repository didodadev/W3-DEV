<!-- Description : Widget Tablosuna yeni alanlar eklendi.
Developer: Emine Yilmaz
Company : Workcube
Destination: Main-->
<querytag>   
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_WIDGET' AND COLUMN_NAME='IS_PUBLIC')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD IS_PUBLIC bit;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_WIDGET' AND COLUMN_NAME='IS_EMPLOYEE')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD IS_EMPLOYEE bit;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_WIDGET' AND COLUMN_NAME='IS_COMPANY')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD IS_COMPANY bit;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_WIDGET' AND COLUMN_NAME='IS_CONSUMER')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD IS_CONSUMER bit;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_WIDGET' AND COLUMN_NAME='IS_EMPLOYEE_APP')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD IS_EMPLOYEE_APP bit;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_WIDGET' AND COLUMN_NAME='IS_MACHINES')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD IS_MACHINES bit;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_WIDGET' AND COLUMN_NAME='IS_LIVESTOCK')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD IS_LIVESTOCK bit;
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_WIDGET' AND COLUMN_NAME='IS_TEMPLATE_WIDGET')
    BEGIN
        ALTER TABLE WRK_WIDGET ADD IS_TEMPLATE_WIDGET bit;
    END;

  
</querytag>