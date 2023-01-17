<!-- Description :Ürünler icin PRODUCT tablolarina yeni alanlar eklenmistir.
Developer: Ahmet Yolcu
Company : Workcube
Destination: product -->

<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'OIV')
        BEGIN
        ALTER TABLE PRODUCT ADD 
        OIV [float] NULL
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'BSMV')
        BEGIN
        ALTER TABLE PRODUCT ADD 
        BSMV [float] NULL
        END
</querytag>