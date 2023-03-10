<!-- Description : Holistic.22 product objects
Developer: Uğur Hamurpet
Company : Workcube
Destination: Product -->
<querytag> 
IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME='HSCODE')
BEGIN
    CREATE TABLE [HSCODE](	  [HSCODE_ID] int NOT NULL IDENTITY(1,1)	, [HSCODE_] int NULL	, [HSCHAPTER_NO] int NULL	, [HSCODE_DETAIL] nvarchar(150) NULL	, [HSCODE_UNIT] int NULL	, [HSCODE_TAX_LIMIT] int NULL	, CONSTRAINT [PK__HSCODE__3426A3A4B15122ED] PRIMARY KEY ([HSCODE_ID] ASC));
END;
IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME='HSCODE_CHAPTER')
BEGIN
    CREATE TABLE [HSCODE_CHAPTER](	  [HSHAPTER_ID] int NOT NULL IDENTITY(1,1)	, [HSCHAPTER_NO] nvarchar(150) NULL	, [HSCHAPTER_DETAIL] nvarchar(150) NULL	, CONSTRAINT [PK__HSCODE_C__04524C119CDEA487] PRIMARY KEY ([HSHAPTER_ID] ASC));
END;
IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRODUCT_PROPERTY' AND COLUMN_NAME = 'DETAIL')
BEGIN
    
    IF EXISTS(SELECT 'Y' FROM sys.indexes WHERE name='NCL_PRODUCT_PROPERTY_1' AND object_id = OBJECT_ID('@_dsn_product_@.PRODUCT_PROPERTY'))
    BEGIN
        DROP INDEX [NCL_PRODUCT_PROPERTY_1] ON [PRODUCT_PROPERTY];
    END;
    IF EXISTS(SELECT 'Y' FROM sys.indexes WHERE name='NCL_PRODUCT_PROPERTY_2' AND object_id = OBJECT_ID('@_dsn_product_@.PRODUCT_PROPERTY'))
    BEGIN
        DROP INDEX [NCL_PRODUCT_PROPERTY_2] ON [PRODUCT_PROPERTY];
    END;
    ALTER TABLE PRODUCT_PROPERTY ALTER COLUMN DETAIL nvarchar(500) NULL;
    CREATE NONCLUSTERED INDEX [NCL_PRODUCT_PROPERTY_1] ON [PRODUCT_PROPERTY] ([PROPERTY_CODE] ASC) 
    CREATE NONCLUSTERED INDEX [NCL_PRODUCT_PROPERTY_2] ON [PRODUCT_PROPERTY] ([PROPERTY] ASC)
END;
</querytag>