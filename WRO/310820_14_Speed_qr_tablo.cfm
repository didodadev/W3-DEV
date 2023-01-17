<!-- Description : Basket hızlı ürün ekleme QR kod özelliği için ürün kategori dönüşüm tablosu eklendi.
Developer: Emre Kaplan
Company : Gramoni
Destination: Main-->

<querytag>
    IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA ='@_dsn_main_@' and TABLE_NAME ='BARKOD_CATEGORY_CONVERSION')
    BEGIN
        CREATE TABLE [BARKOD_CATEGORY_CONVERSION](
            [CATEGORY] [nvarchar](50) NULL,
            [DATE_PARAMETER] [int] NULL
        ) ON [PRIMARY]
    END;
</querytag>