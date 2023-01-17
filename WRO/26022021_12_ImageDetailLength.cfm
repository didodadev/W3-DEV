<!-- Description : Image tablolarında detay kolonunun varchar uzunluğu değiştirildi.  
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'CONTENT_IMAGE' AND COLUMN_NAME = 'DETAIL')
    BEGIN
        ALTER TABLE CONTENT_IMAGE
        ALTER COLUMN DETAIL
        varchar(1000);
    END
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCT_BRANDS_IMAGES' AND COLUMN_NAME = 'DETAIL')
    BEGIN
        ALTER TABLE PRODUCT_BRANDS_IMAGES
        ALTER COLUMN DETAIL
        varchar(1000);
    END
    IF  EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCT_IMAGES' AND COLUMN_NAME = 'DETAIL')
    BEGIN
        ALTER TABLE PRODUCT_IMAGES
        ALTER COLUMN DETAIL
        varchar(1000);
    END
    
</querytag>