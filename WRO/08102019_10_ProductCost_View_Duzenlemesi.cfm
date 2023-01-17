<!-- Description : PRODUCT_COST view_düzenlemesi yapıldı.
Developer: Esma Uysal
Company : Workcube
Destination: Company -->
<querytag>
    ALTER VIEW [PRODUCT_COST] AS
        SELECT      
            @_dsn_product_@.PRODUCT_COST.PRODUCT_COST_ID,
            @_dsn_product_@.PRODUCT_COST.PROCESS_STAGE,
            @_dsn_product_@.PRODUCT_COST.PRODUCT_ID,
            @_dsn_product_@.PRODUCT_COST.UNIT_ID,
            @_dsn_product_@.PRODUCT_COST.IS_SPEC,
            @_dsn_product_@.PRODUCT_COST.SPECT_MAIN_ID,
            @_dsn_product_@.PRODUCT_COST.PRODUCT_COST_STATUS,
            @_dsn_product_@.PRODUCT_COST.INVENTORY_CALC_TYPE,
            @_dsn_product_@.PRODUCT_COST.START_DATE,
            @_dsn_product_@.PRODUCT_COST.COST_TYPE_ID,
            @_dsn_product_@.PRODUCT_COST.PRODUCT_COST,
            @_dsn_product_@.PRODUCT_COST.MONEY,
            @_dsn_product_@.PRODUCT_COST.STANDARD_COST,
            @_dsn_product_@.PRODUCT_COST.STANDARD_COST_MONEY,
            @_dsn_product_@.PRODUCT_COST.STANDARD_COST_RATE,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_MONEY,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_EXTRA_COST,
            @_dsn_product_@.PRODUCT_COST.PRICE_PROTECTION,
            @_dsn_product_@.PRODUCT_COST.PRICE_PROTECTION_MONEY,
            @_dsn_product_@.PRODUCT_COST.PRICE_PROTECTION_TYPE,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM,
            @_dsn_product_@.PRODUCT_COST.PRODUCT_COST_SYSTEM,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_2,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_2,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2,
            @_dsn_product_@.PRODUCT_COST.AVAILABLE_STOCK,
            @_dsn_product_@.PRODUCT_COST.PARTNER_STOCK,
            @_dsn_product_@.PRODUCT_COST.ACTIVE_STOCK,
            @_dsn_product_@.PRODUCT_COST.IS_STANDARD_COST,
            @_dsn_product_@.PRODUCT_COST.IS_ACTIVE_STOCK,
            @_dsn_product_@.PRODUCT_COST.IS_PARTNER_STOCK,
            @_dsn_product_@.PRODUCT_COST.COST_DESCRIPTION,
            @_dsn_product_@.PRODUCT_COST.ACTION_PROCESS_TYPE,
            @_dsn_product_@.PRODUCT_COST.ACTION_PROCESS_CAT_ID,
            @_dsn_product_@.PRODUCT_COST.ACTION_ID,
            @_dsn_product_@.PRODUCT_COST.ACTION_ROW_ID,
            @_dsn_product_@.PRODUCT_COST.ACTION_ROW_PRICE,
            @_dsn_product_@.PRODUCT_COST.ACTION_TYPE,
            @_dsn_product_@.PRODUCT_COST.ACTION_PERIOD_ID,
            @_dsn_product_@.PRODUCT_COST.ACTION_AMOUNT,
            @_dsn_product_@.PRODUCT_COST.ACTION_DATE,
            @_dsn_product_@.PRODUCT_COST.ACTION_DUE_DATE,
            @_dsn_product_@.PRODUCT_COST.DEPARTMENT_ID,
            @_dsn_product_@.PRODUCT_COST.LOCATION_ID,
            @_dsn_product_@.PRODUCT_COST.PRODUCT_COST_LOCATION,
            @_dsn_product_@.PRODUCT_COST.MONEY_LOCATION,
            @_dsn_product_@.PRODUCT_COST.STANDARD_COST_LOCATION,
            @_dsn_product_@.PRODUCT_COST.STANDARD_COST_MONEY_LOCATION,
            @_dsn_product_@.PRODUCT_COST.STANDARD_COST_RATE_LOCATION,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_LOCATION,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_EXTRA_COST_LOCATION,
            @_dsn_product_@.PRODUCT_COST.PRICE_PROTECTION_LOCATION,
            @_dsn_product_@.PRODUCT_COST.PRICE_PROTECTION_MONEY_LOCATION,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_LOCATION,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_2_LOCATION,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,
            @_dsn_product_@.PRODUCT_COST.AVAILABLE_STOCK_LOCATION,
            @_dsn_product_@.PRODUCT_COST.PARTNER_STOCK_LOCATION,
            @_dsn_product_@.PRODUCT_COST.ACTIVE_STOCK_LOCATION,
            @_dsn_product_@.PRODUCT_COST.IS_SEVK,
            @_dsn_product_@.PRODUCT_COST.RECORD_DATE,
            @_dsn_product_@.PRODUCT_COST.RECORD_EMP,
            @_dsn_product_@.PRODUCT_COST.RECORD_IP,
            @_dsn_product_@.PRODUCT_COST.UPDATE_DATE,
            @_dsn_product_@.PRODUCT_COST.UPDATE_EMP,
            @_dsn_product_@.PRODUCT_COST.UPDATE_IP,
            @_dsn_product_@.PRODUCT_COST.IS_SUGGEST,
            @_dsn_product_@.PRODUCT_COST.PRICE_PROTECTION_TOTAL,
            @_dsn_product_@.PRODUCT_COST.PRICE_PROTECTION_AMOUNT,
            @_dsn_product_@.PRODUCT_COST.DUE_DATE,
            @_dsn_product_@.PRODUCT_COST.DUE_DATE_LOCATION,
            @_dsn_product_@.PRODUCT_COST.PHYSICAL_DATE,
            @_dsn_product_@.PRODUCT_COST.PHYSICAL_DATE_LOCATION,
            @_dsn_product_@.PRODUCT_COST.ACTION_EXTRA_COST,
            @_dsn_product_@.PRODUCT_COST.STOCK_ID,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_ALL,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_ALL,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_2_ALL,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_LOCATION_ALL,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION_ALL,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_2_LOCATION_ALL,
            @_dsn_product_@.PRODUCT_COST.AVAILABLE_STOCK_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PARTNER_STOCK_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.ACTIVE_STOCK_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PRODUCT_COST_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.MONEY_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.STANDARD_COST_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.STANDARD_COST_MONEY_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.STANDARD_COST_RATE_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_MONEY_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_EXTRA_COST_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PRICE_PROTECTION_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PRICE_PROTECTION_MONEY_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_2_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_2_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.DUE_DATE_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PHYSICAL_DATE_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_DEPARTMENT_ALL,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_DEPARTMENT_ALL,
            @_dsn_product_@.PRODUCT_COST.PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL,
            @_dsn_product_@.PRODUCT_COST.STATION_REFLECTION_COST,
            @_dsn_product_@.PRODUCT_COST.LABOR_COST,
            @_dsn_product_@.PRODUCT_COST.STATION_REFLECTION_COST_SYSTEM_2,
            @_dsn_product_@.PRODUCT_COST.LABOR_COST_SYSTEM_2,
            @_dsn_product_@.PRODUCT_COST.STATION_REFLECTION_COST_SYSTEM,
            @_dsn_product_@.PRODUCT_COST.LABOR_COST_SYSTEM ,
            @_dsn_product_@.PRODUCT_COST.STATION_REFLECTION_COST_LOCATION,
            @_dsn_product_@.PRODUCT_COST.LABOR_COST_LOCATION,
            @_dsn_product_@.PRODUCT_COST.STATION_REFLECTION_COST_SYSTEM_2_LOCATION, 
            @_dsn_product_@.PRODUCT_COST.LABOR_COST_SYSTEM_2_LOCATION,
            @_dsn_product_@.PRODUCT_COST.STATION_REFLECTION_COST_SYSTEM_LOCATION ,
            @_dsn_product_@.PRODUCT_COST.LABOR_COST_SYSTEM_LOCATION,
            @_dsn_product_@.PRODUCT_COST.STATION_REFLECTION_COST_SYSTEM_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.LABOR_COST_SYSTEM_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.STATION_REFLECTION_COST_DEPARTMENT,			
            @_dsn_product_@.PRODUCT_COST.STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT ,
            @_dsn_product_@.PRODUCT_COST.LABOR_COST_DEPARTMENT,
            @_dsn_product_@.PRODUCT_COST.LABOR_COST_SYSTEM_2_DEPARTMENT
        FROM   
                @_dsn_product_@.PRODUCT,
                @_dsn_product_@.PRODUCT_COST,
                @_dsn_product_@.PRODUCT_OUR_COMPANY,
                @_dsn_main_@.SETUP_PERIOD
        WHERE   
            (@_dsn_main_@.SETUP_PERIOD.OUR_COMPANY_ID = @_companyid_@) AND
            @_dsn_main_@.SETUP_PERIOD.PERIOD_ID = @_dsn_product_@.PRODUCT_COST.ACTION_PERIOD_ID AND  
            (@_dsn_product_@.PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = @_companyid_@) AND
            @_dsn_product_@.PRODUCT.PRODUCT_ID = @_dsn_product_@.PRODUCT_OUR_COMPANY.PRODUCT_ID AND
            @_dsn_product_@.PRODUCT_COST.PRODUCT_ID = @_dsn_product_@.PRODUCT.PRODUCT_ID
</querytag>