<!-- Description : Release Product Schema Compare
Developer: Uğur Hamurpet
Company : Workcube
Destination: Product -->

<querytag>      
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' and TABLE_NAME='PRODUCT_PROPERTY' AND COLUMN_NAME='PROPERTY_LEN' )
    BEGIN   
        ALTER TABLE PRODUCT_PROPERTY ADD PROPERTY_LEN int NULL 
    END;
</querytag>