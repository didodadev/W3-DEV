<!--Description : Ürün maliyet tablosune yeni kolonlar eklendi.
Developer: Pınar Yıldız
Company : Workcube
Destination: Product -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_COST' AND COLUMN_NAME = 'LABOR_COST_SYSTEM_2')
        BEGIN
            ALTER TABLE PRODUCT_COST ADD LABOR_COST_SYSTEM_2 float;
        END
</querytag>