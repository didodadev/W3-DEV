<!--Description : Ürün maliyet tablosune yeni kolonlar eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Product -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_COST' AND COLUMN_NAME = 'STATION_REFLECTION_COST')
        BEGIN
            ALTER TABLE PRODUCT_COST ADD STATION_REFLECTION_COST float;
            ALTER TABLE PRODUCT_COST ADD LABOR_COST float;
            ALTER TABLE PRODUCT_COST ADD STATION_REFLECTION_COST_SYSTEM_2 float;
            ALTER TABLE PRODUCT_COST ADD STATION_REFLECTION_COST_SYSTEM float;
            ALTER TABLE PRODUCT_COST ADD LABOR_COST_SYSTEM float;
            ALTER TABLE PRODUCT_COST ADD STATION_REFLECTION_COST_LOCATION float;
            ALTER TABLE PRODUCT_COST ADD LABOR_COST_LOCATION float;
            ALTER TABLE PRODUCT_COST ADD STATION_REFLECTION_COST_SYSTEM_2_LOCATION float;
            ALTER TABLE PRODUCT_COST ADD LABOR_COST_SYSTEM_2_LOCATION float;
            ALTER TABLE PRODUCT_COST ADD STATION_REFLECTION_COST_SYSTEM_LOCATION float;
            ALTER TABLE PRODUCT_COST ADD LABOR_COST_SYSTEM_LOCATION float;
            ALTER TABLE PRODUCT_COST ADD STATION_REFLECTION_COST_SYSTEM_DEPARTMENT float;
            ALTER TABLE PRODUCT_COST ADD LABOR_COST_SYSTEM_DEPARTMENT float;
            ALTER TABLE PRODUCT_COST ADD STATION_REFLECTION_COST_DEPARTMENT float;
            ALTER TABLE PRODUCT_COST ADD STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT float;
            ALTER TABLE PRODUCT_COST ADD LABOR_COST_DEPARTMENT float;
            ALTER TABLE PRODUCT_COST ADD LABOR_COST_SYSTEM_2_DEPARTMENT float;
        END
</querytag>