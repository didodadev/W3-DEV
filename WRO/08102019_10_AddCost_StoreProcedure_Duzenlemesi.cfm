<!-- Description : ADD_COST Store Procedure düzenlemesi yapıldı.
Developer: Esma Uysal
Company : Workcube
Destination: Product -->
<querytag>
    ALTER PROCEDURE [ADD_COST]
        @PRODUCT_ID INT,
        @INVENTORY_CALC_TYPE INT ,
        @PRODUCT_COST FLOAT ,
        @MONEY NVARCHAR(43),
        @STANDARD_COST FLOAT,
        @STANDARD_COST_MONEY NVARCHAR(43) ,
        @PURCHASE_NET FLOAT,
        @AVAILABLE_STOCK FLOAT,
        @STANDARD_COST_RATE FLOAT,
        @COST_DESCRIPTION NVARCHAR(300) ,
        @IS_STANDARD_COST bit,
        @IS_ACTIVE_STOCK bit,
        @IS_PARTNER_STOCK bit,
        @PURCHASE_NET_MONEY nvarchar(43),
        @PURCHASE_EXTRA_COST float,
        @PRICE_PROTECTION float ,
        @PRICE_PROTECTION_MONEY nvarchar(43),
        @COST_TYPE_ID int,
        @PRICE_PROTECTION_TYPE int,
        @PRICE_PROTECTION_TOTAL float,
        @PRICE_PROTECTION_AMOUNT float,
        @PARTNER_STOCK float,
        @ACTIVE_STOCK float ,
        @RECORD_DATE datetime,
        @START_DATE datetime,
        @RECORD_EMP int ,
        @RECORD_IP nvarchar(50),
        @UNIT_ID int,
        @PRODUCT_COST_STATUS bit,
        @ACTION_ID int,
        @ACTION_TYPE int,
        @ACTION_PERIOD_ID int,
        @ACTION_AMOUNT float,
        @ACTION_ROW_ID int,
        @ACTION_PROCESS_TYPE int,
        @ACTION_PROCESS_CAT_ID int,
        @ACTION_ROW_PRICE float,
        @ACTION_EXTRA_COST float,
        @PURCHASE_NET_SYSTEM float,
        @PURCHASE_EXTRA_COST_SYSTEM float ,
        @PURCHASE_NET_SYSTEM_MONEY nvarchar(43),
        @IS_SPEC bit,
        @SPECT_MAIN_ID int,
        @STOCK_ID int ,
        @PURCHASE_NET_SYSTEM_2 float,
        @PURCHASE_EXTRA_COST_SYSTEM_2 float,
        @PURCHASE_NET_SYSTEM_MONEY_2 nvarchar(43),									
        @DEPARTMENT_ID int ,
        @LOCATION_ID int,
        @AVAILABLE_STOCK_LOCATION float,
        @PARTNER_STOCK_LOCATION float ,
        @ACTIVE_STOCK_LOCATION float,
        @PRODUCT_COST_LOCATION float,
        @MONEY_LOCATION nvarchar(43),
        @STANDARD_COST_LOCATION float,
        @STANDARD_COST_MONEY_LOCATION nvarchar(43),
        @STANDARD_COST_RATE_LOCATION float,
        @PURCHASE_NET_LOCATION float,
        @PURCHASE_NET_MONEY_LOCATION nvarchar(43),
        @PURCHASE_EXTRA_COST_LOCATION float,
        @PRICE_PROTECTION_LOCATION float,
        @PRICE_PROTECTION_MONEY_LOCATION nvarchar(43),		
        @PURCHASE_NET_SYSTEM_LOCATION float,
        @PURCHASE_NET_SYSTEM_MONEY_LOCATION nvarchar(43),
        @PURCHASE_EXTRA_COST_SYSTEM_LOCATION float,
        @PURCHASE_NET_SYSTEM_2_LOCATION float,
        @PURCHASE_NET_SYSTEM_MONEY_2_LOCATION nvarchar(43),
        @PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION float,			
        @AVAILABLE_STOCK_DEPARTMENT float,
        @PARTNER_STOCK_DEPARTMENT float ,
        @ACTIVE_STOCK_DEPARTMENT float,
        @PRODUCT_COST_DEPARTMENT float,
        @MONEY_DEPARTMENT nvarchar(43),
        @STANDARD_COST_DEPARTMENT float,
        @STANDARD_COST_MONEY_DEPARTMENT nvarchar(43),
        @STANDARD_COST_RATE_DEPARTMENT float,
        @PURCHASE_NET_DEPARTMENT float,
        @PURCHASE_NET_MONEY_DEPARTMENT nvarchar(43),
        @PURCHASE_EXTRA_COST_DEPARTMENT float,
        @PRICE_PROTECTION_DEPARTMENT float,
        @PRICE_PROTECTION_MONEY_DEPARTMENT nvarchar(43),		
        @PURCHASE_NET_SYSTEM_DEPARTMENT float,
        @PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT nvarchar(43),
        @PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT float,
        @PURCHASE_NET_SYSTEM_2_DEPARTMENT float,
        @PURCHASE_NET_SYSTEM_MONEY_2_DEPARTMENT nvarchar(43),
        @PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT float,									
        @DUE_DATE datetime,
        @DUE_DATE_LOCATION datetime,
        @DUE_DATE_DEPARTMENT datetime,
        @PHYSICAL_DATE datetime,
        @PHYSICAL_DATE_LOCATION datetime,
        @PHYSICAL_DATE_DEPARTMENT datetime,
        @ACTION_DATE datetime,
        @ACTION_DUE_DATE int ,
        @UPDATE_DATE datetime,
        @UPDATE_EMP int,
        @UPDATE_IP nvarchar(50),
        @STATION_REFLECTION_COST_SYSTEM FLOAT,
        @LABOR_COST_SYSTEM FLOAT,
        @STATION_REFLECTION_COST_SYSTEM_DEPARTMENT FLOAT,
        @LABOR_COST_SYSTEM_DEPARTMENT FLOAT,
        @STATION_REFLECTION_COST_SYSTEM_LOCATION FLOAT,
        @LABOR_COST_SYSTEM_LOCATION FLOAT,
        @STATION_REFLECTION_COST FLOAT,
        @STATION_REFLECTION_COST_SYSTEM_2 FLOAT,
        @STATION_REFLECTION_COST_LOCATION FLOAT,
        @STATION_REFLECTION_COST_SYSTEM_2_LOCATION FLOAT,
        @STATION_REFLECTION_COST_DEPARTMENT FLOAT,
        @STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT FLOAT,
        @LABOR_COST FLOAT,
        @LABOR_COST_SYSTEM_2 FLOAT,
        @LABOR_COST_LOCATION FLOAT,
        @LABOR_COST_SYSTEM_2_LOCATION FLOAT,
        @LABOR_COST_DEPARTMENT FLOAT,
        @LABOR_COST_SYSTEM_2_DEPARTMENT FLOAT
    AS
    BEGIN
        SET NOCOUNT ON;

    INSERT INTO
        PRODUCT_COST
        (
            PRODUCT_ID,
            INVENTORY_CALC_TYPE,
            PRODUCT_COST,
            MONEY,
            STANDARD_COST,
            STANDARD_COST_MONEY,
            PURCHASE_NET,
            AVAILABLE_STOCK,
            STANDARD_COST_RATE,
            COST_DESCRIPTION,
            IS_STANDARD_COST,
            IS_ACTIVE_STOCK,
            IS_PARTNER_STOCK,
            PURCHASE_NET_MONEY,
            PURCHASE_EXTRA_COST,
            PRICE_PROTECTION,
            PRICE_PROTECTION_MONEY,
            COST_TYPE_ID,
            PRICE_PROTECTION_TYPE,
            PRICE_PROTECTION_TOTAL,
            PRICE_PROTECTION_AMOUNT,
            PARTNER_STOCK,
            ACTIVE_STOCK,
            RECORD_DATE,
            START_DATE,
            RECORD_EMP,
            RECORD_IP,
            UNIT_ID,
            PRODUCT_COST_STATUS,
            ACTION_ID,
            ACTION_TYPE,
            ACTION_PERIOD_ID,
            ACTION_AMOUNT,
            ACTION_ROW_ID,
            ACTION_PROCESS_TYPE,
            ACTION_PROCESS_CAT_ID,
            ACTION_ROW_PRICE,
            ACTION_EXTRA_COST,
            PURCHASE_NET_SYSTEM,
            PURCHASE_EXTRA_COST_SYSTEM,
            PURCHASE_NET_SYSTEM_MONEY,
            IS_SPEC,
            SPECT_MAIN_ID,
            STOCK_ID,
            PURCHASE_NET_SYSTEM_2,
            PURCHASE_EXTRA_COST_SYSTEM_2,
            PURCHASE_NET_SYSTEM_MONEY_2,									
            DEPARTMENT_ID,
            LOCATION_ID,
            AVAILABLE_STOCK_LOCATION,
            PARTNER_STOCK_LOCATION,
            ACTIVE_STOCK_LOCATION,
            PRODUCT_COST_LOCATION,
            MONEY_LOCATION,
            STANDARD_COST_LOCATION,
            STANDARD_COST_MONEY_LOCATION,
            STANDARD_COST_RATE_LOCATION,
            PURCHASE_NET_LOCATION,
            PURCHASE_NET_MONEY_LOCATION,
            PURCHASE_EXTRA_COST_LOCATION,
            PRICE_PROTECTION_LOCATION,
            PRICE_PROTECTION_MONEY_LOCATION,		
            PURCHASE_NET_SYSTEM_LOCATION,
            PURCHASE_NET_SYSTEM_MONEY_LOCATION,
            PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
            PURCHASE_NET_SYSTEM_2_LOCATION,
            PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,
            PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,		
            AVAILABLE_STOCK_DEPARTMENT,
            PARTNER_STOCK_DEPARTMENT,
            ACTIVE_STOCK_DEPARTMENT,
            PRODUCT_COST_DEPARTMENT,
            MONEY_DEPARTMENT,
            STANDARD_COST_DEPARTMENT,
            STANDARD_COST_MONEY_DEPARTMENT,
            STANDARD_COST_RATE_DEPARTMENT,
            PURCHASE_NET_DEPARTMENT,
            PURCHASE_NET_MONEY_DEPARTMENT,
            PURCHASE_EXTRA_COST_DEPARTMENT,
            PRICE_PROTECTION_DEPARTMENT,
            PRICE_PROTECTION_MONEY_DEPARTMENT,		
            PURCHASE_NET_SYSTEM_DEPARTMENT,
            PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,
            PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,
            PURCHASE_NET_SYSTEM_2_DEPARTMENT,
            PURCHASE_NET_SYSTEM_MONEY_2_DEPARTMENT,
            PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,								
            DUE_DATE,
            DUE_DATE_LOCATION,
            DUE_DATE_DEPARTMENT,
            PHYSICAL_DATE,
            PHYSICAL_DATE_LOCATION,
            PHYSICAL_DATE_DEPARTMENT,
            ACTION_DATE,
            ACTION_DUE_DATE,
            UPDATE_DATE,
            UPDATE_EMP,
            UPDATE_IP,
            STATION_REFLECTION_COST_SYSTEM,
            LABOR_COST_SYSTEM,
            STATION_REFLECTION_COST_SYSTEM_DEPARTMENT,
            LABOR_COST_SYSTEM_DEPARTMENT,
            STATION_REFLECTION_COST_SYSTEM_LOCATION,
            LABOR_COST_SYSTEM_LOCATION,
            STATION_REFLECTION_COST,
            STATION_REFLECTION_COST_SYSTEM_2,
            STATION_REFLECTION_COST_LOCATION,
            STATION_REFLECTION_COST_SYSTEM_2_LOCATION,
            STATION_REFLECTION_COST_DEPARTMENT,
            STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT,
            LABOR_COST,
            LABOR_COST_SYSTEM_2,
            LABOR_COST_LOCATION,
            LABOR_COST_SYSTEM_2_LOCATION,
            LABOR_COST_DEPARTMENT,
            LABOR_COST_SYSTEM_2_DEPARTMENT
    )
    values
        (
            @PRODUCT_ID,
            @INVENTORY_CALC_TYPE,
            @PRODUCT_COST,
            @MONEY,
            @STANDARD_COST,
            @STANDARD_COST_MONEY,
            @PURCHASE_NET,
            @AVAILABLE_STOCK,
            @STANDARD_COST_RATE,
            @COST_DESCRIPTION,
            @IS_STANDARD_COST,
            @IS_ACTIVE_STOCK,
            @IS_PARTNER_STOCK,
            @PURCHASE_NET_MONEY,
            @PURCHASE_EXTRA_COST,
            @PRICE_PROTECTION,
            @PRICE_PROTECTION_MONEY,
            @COST_TYPE_ID,
            @PRICE_PROTECTION_TYPE,
            @PRICE_PROTECTION_TOTAL,
            @PRICE_PROTECTION_AMOUNT,
            @PARTNER_STOCK,
            @ACTIVE_STOCK,
            @RECORD_DATE,
            @START_DATE,
            @RECORD_EMP,
            @RECORD_IP,
            @UNIT_ID,
            @PRODUCT_COST_STATUS,
            @ACTION_ID,
            @ACTION_TYPE,
            @ACTION_PERIOD_ID,
            @ACTION_AMOUNT,
            @ACTION_ROW_ID,
            @ACTION_PROCESS_TYPE,
            @ACTION_PROCESS_CAT_ID,
            @ACTION_ROW_PRICE,
            @ACTION_EXTRA_COST,
            @PURCHASE_NET_SYSTEM,
            @PURCHASE_EXTRA_COST_SYSTEM,
            @PURCHASE_NET_SYSTEM_MONEY,
            @IS_SPEC,
            @SPECT_MAIN_ID,
            @STOCK_ID,
            @PURCHASE_NET_SYSTEM_2,
            @PURCHASE_EXTRA_COST_SYSTEM_2,
            @PURCHASE_NET_SYSTEM_MONEY_2,									
            @DEPARTMENT_ID,
            @LOCATION_ID,
            @AVAILABLE_STOCK_LOCATION,
            @PARTNER_STOCK_LOCATION,
            @ACTIVE_STOCK_LOCATION,
            @PRODUCT_COST_LOCATION,
            @MONEY_LOCATION,
            @STANDARD_COST_LOCATION,
            @STANDARD_COST_MONEY_LOCATION,
            @STANDARD_COST_RATE_LOCATION,
            @PURCHASE_NET_LOCATION,
            @PURCHASE_NET_MONEY_LOCATION,
            @PURCHASE_EXTRA_COST_LOCATION,
            @PRICE_PROTECTION_LOCATION,
            @PRICE_PROTECTION_MONEY_LOCATION,		
            @PURCHASE_NET_SYSTEM_LOCATION,
            @PURCHASE_NET_SYSTEM_MONEY_LOCATION,
            @PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
            @PURCHASE_NET_SYSTEM_2_LOCATION,
            @PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,
            @PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,			
            @AVAILABLE_STOCK_DEPARTMENT,
            @PARTNER_STOCK_DEPARTMENT,
            @ACTIVE_STOCK_DEPARTMENT,
            @PRODUCT_COST_DEPARTMENT,
            @MONEY_DEPARTMENT,
            @STANDARD_COST_DEPARTMENT,
            @STANDARD_COST_MONEY_DEPARTMENT,
            @STANDARD_COST_RATE_DEPARTMENT,
            @PURCHASE_NET_DEPARTMENT,
            @PURCHASE_NET_MONEY_DEPARTMENT,
            @PURCHASE_EXTRA_COST_DEPARTMENT,
            @PRICE_PROTECTION_DEPARTMENT,
            @PRICE_PROTECTION_MONEY_DEPARTMENT,		
            @PURCHASE_NET_SYSTEM_DEPARTMENT,
            @PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,
            @PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,
            @PURCHASE_NET_SYSTEM_2_DEPARTMENT,
            @PURCHASE_NET_SYSTEM_MONEY_2_DEPARTMENT,
            @PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,								
            @DUE_DATE,
            @DUE_DATE_LOCATION,
            @DUE_DATE_DEPARTMENT,
            @PHYSICAL_DATE,
            @PHYSICAL_DATE_LOCATION,
            @PHYSICAL_DATE_DEPARTMENT,
            @ACTION_DATE,
            @ACTION_DUE_DATE,
            @UPDATE_DATE,
            @UPDATE_EMP,
            @UPDATE_IP,
            @STATION_REFLECTION_COST_SYSTEM,
            @LABOR_COST_SYSTEM,
            @STATION_REFLECTION_COST_SYSTEM_DEPARTMENT,
            @LABOR_COST_SYSTEM_DEPARTMENT,
            @STATION_REFLECTION_COST_SYSTEM_LOCATION,
            @LABOR_COST_SYSTEM_LOCATION,
            @STATION_REFLECTION_COST,
            @STATION_REFLECTION_COST_SYSTEM_2,
            @STATION_REFLECTION_COST_LOCATION,
            @STATION_REFLECTION_COST_SYSTEM_2_LOCATION,
            @STATION_REFLECTION_COST_DEPARTMENT,
            @STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT,
            @LABOR_COST,
            @LABOR_COST_SYSTEM_2,
            @LABOR_COST_LOCATION,
            @LABOR_COST_SYSTEM_2_LOCATION,
            @LABOR_COST_DEPARTMENT,
            @LABOR_COST_SYSTEM_2_DEPARTMENT
        )
    END;
</querytag>