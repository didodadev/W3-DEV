<!--- 
Tüm şirketlerdeki viewler drop edilip, yeniden create ediliyor. OZDEN20060519
 --->
<cfform name="create_view" action="#request.self#?fuseaction=settings.create_company_views" method="post">
	<table width="98%" align="center">
		<tr>
			<td height="35"><font color="red"><cf_get_lang no='2955.Sistemde Şirket Databaseinde Bulunan Tüm View ler Silinip Tekrar Oluşturulacaktır'><br/></font></td>
		</tr>
		<tr>
			<td>
				<input type="submit" value="<cf_get_lang_main no='1554.Oluştur'>">
				<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
			</td>
		</tr>
	</table>
</cfform>
<cfif isDefined("attributes.is_form_submitted")>
	<cfquery name="get_our_comps" datasource="#dsn#">
		SELECT COMP_ID AS OUR_COMPANY_ID FROM OUR_COMPANY <!--- <cfif http.host contains "ep.workcube">WHERE COMP_ID = 1</cfif> ORDER BY COMP_ID --->
	</cfquery>
	<cfset new_prod_db='#dsn#_product'>
	<cfset new_dsn = '#dsn#'>
	<cfloop query="get_our_comps">
		<cfset new_dsn3 = '#dsn#_#get_our_comps.OUR_COMPANY_ID#'>
		<cfoutput>new_dsn3:#new_dsn3# new_prod_db:#new_prod_db# new_dsn:#new_dsn#<br/></cfoutput>
		
       	 <cftry>
            <cfquery name="drop_view" datasource="#new_dsn3#">
            
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_PRODUCTION_RESERVED]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_PRODUCTION_RESERVED
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ALL_SHIP_ROW]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_ALL_SHIP_ROW
            end
            
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ALL_STOCK_FIS_ROW]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_ALL_STOCK_FIS_ROW
            end
            
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ALL_INVOICE_ROW]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_ALL_INVOICE_ROW
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_PRODUCTION_RESERVED_LOCATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_PRODUCTION_RESERVED_LOCATION
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_PRODUCTION_RESERVED_SPECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_PRODUCTION_RESERVED_SPECT
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_PRODUCTION_RESERVED_SPECT_LOCATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_PRODUCTION_RESERVED_SPECT_LOCATION
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_PRODUCTION_RESERVED_LOT_NO]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_PRODUCTION_RESERVED_LOT_NO
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_PRODUCTION_RESERVED_LOCATION_LOT_NO]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_PRODUCTION_RESERVED_LOCATION_LOT_NO
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_PRODUCTION_STOCKS]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_PRODUCTION_STOCKS
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_BARCODES]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_STOCK_BARCODES
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_BARCODES_GENIUS]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_STOCK_BARCODES_GENIUS
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ORDER_ROW_RESERVED]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_ORDER_ROW_RESERVED
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ORDER_ROWS_RESERVED]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_ORDER_ROWS_RESERVED
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ORDER_ROW_RESERVED_ALL]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_ORDER_ROW_RESERVED_ALL
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ORDER_ROW_RESERVED_LOCATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_ORDER_ROW_RESERVED_LOCATION
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_RESERVED]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_STOCK_RESERVED
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_RESERVED_LAST]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_STOCK_RESERVED_LAST
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_RESERVED_SPECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_STOCK_RESERVED_SPECT
            end
            
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_RESERVED_SPECT_LOCATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_STOCK_RESERVED_SPECT_LOCATION
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_RESERVED_ROW]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_STOCK_RESERVED_ROW
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_RESERVED_ROW_LOCATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_STOCK_RESERVED_ROW_LOCATION
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_RESERVED_LAST_SPECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_STOCK_RESERVED_LAST_SPECT
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[PRICE_STANDART]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW PRICE_STANDART
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[PRODUCT]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW PRODUCT
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[PRODUCT_BRANDS]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW PRODUCT_BRANDS
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[PRODUCT_CAT]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW PRODUCT_CAT
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[PRODUCT_COST]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW PRODUCT_COST
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[PRODUCT_IMAGES]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW PRODUCT_IMAGES
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[PRODUCT_UNIT]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW PRODUCT_UNIT
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[PRODUCT_UNIT_PROFIT]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW PRODUCT_UNIT_PROFIT
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[STOCKS]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW STOCKS
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[STOCKS_BARCODES]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW STOCKS_BARCODES
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[STOCKS_PROPERTY]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW STOCKS_PROPERTY
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_INVENTORIES]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW DAILY_INVENTORIES
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_TOTAL_INVENTORIES]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW DAILY_TOTAL_INVENTORIES
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[PRICE_STANDART_DISCOUNT]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW PRICE_STANDART_DISCOUNT
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[INTERNALDEMAND_RELATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW INTERNALDEMAND_RELATION
            end
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_RESERVED_TRIGGER]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_STOCK_RESERVED_TRIGGER
            end				
            if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ALL_ORDER_ROW]') and OBJECTPROPERTY(id, N'IsView') = 1)
            begin
                DROP VIEW GET_ALL_ORDER_ROW
            end
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[add_price]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [add_price]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ADD_PRODUCTION_OPERATION]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [ADD_PRODUCTION_OPERATION]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ADD_PRODUCTION_ORDER]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [ADD_PRODUCTION_ORDER]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ADD_PRODUCTION_ORDER_CASH]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [ADD_PRODUCTION_ORDER_CASH]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ADD_PRODUCTION_ORDER_RESULT]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [ADD_PRODUCTION_ORDER_RESULT]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ADD_PRODUCTION_ORDER_RESULTS_ROW]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [ADD_PRODUCTION_ORDER_RESULTS_ROW]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ADD_PRODUCTION_ORDER_RESULTS_ROW_O]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [ADD_PRODUCTION_ORDER_RESULTS_ROW_O]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ADD_PRODUCTION_ORDER_RESULTS_ROW_S]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [ADD_PRODUCTION_ORDER_RESULTS_ROW_S]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ADD_PRODUCTION_ORDERS_ROW]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [ADD_PRODUCTION_ORDERS_ROW]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ADD_PRODUCTION_ORDERS_STOCKS]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [ADD_PRODUCTION_ORDERS_STOCKS]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DEL_ORDER_ROW_RESERVED]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [DEL_ORDER_ROW_RESERVED]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_PRODUCTION_ORDER_MAX]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [GET_PRODUCTION_ORDER_MAX]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_PRODUCTION_ORDER_RESULT_MAX_ID]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [GET_PRODUCTION_ORDER_RESULT_MAX_ID]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_SUB_PRODUCT_FIRE]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [GET_SUB_PRODUCT_FIRE]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_WORKSTATIONS_PRODUCTS]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [GET_WORKSTATIONS_PRODUCTS]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UPD_GENERAL_PAPERS]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [UPD_GENERAL_PAPERS]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UPD_GENERAL_PAPERS_LOT_NUMBER]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [UPD_GENERAL_PAPERS_LOT_NUMBER]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UPD_GENERAL_PAPERS_PROD_ORDER_NUMBER]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [UPD_GENERAL_PAPERS_PROD_ORDER_NUMBER]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UPD_PRO_ORDER_LOT_NUMBER]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [UPD_PRO_ORDER_LOT_NUMBER]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UPD_PROD_ORDER_ROW_SPECT]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [UPD_PROD_ORDER_ROW_SPECT]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UPD_PROD_ORDER_SPECT]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [UPD_PROD_ORDER_SPECT]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UPD_PRODUCTION_ORDERS_REF_NO]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [UPD_PRODUCTION_ORDERS_REF_NO]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_GET_STOCK_RESERVED_SPECT]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [SP_GET_STOCK_RESERVED_SPECT]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_GET_STOCK_RESERVED]') AND type in (N'P', N'PC'))
            DROP PROCEDURE [SP_GET_STOCK_RESERVED]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_NETBOOK]') AND type in (N'P', N'PC'))
           	DROP PROCEDURE [GET_NETBOOK]
            </cfquery>
			<cfcatch>
			</cfcatch>
		</cftry>
<cfquery name="get_period" datasource="#dsn#">
		SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #get_our_comps.OUR_COMPANY_ID#
	</cfquery>
    <cfif get_period.recordcount and fusebox.use_period>
		<cfquery name="cr_view" datasource="#new_dsn3#">
            CREATE VIEW [GET_ALL_SHIP_ROW] AS
                <cfoutput query="get_period">
                    SELECT
                        SHIP_ID,
                        WRK_ROW_RELATION_ID,
						WRK_ROW_ID,
                        AMOUNT
                    FROM
                        #dsn#_#get_period.period_year#_#get_our_comps.OUR_COMPANY_ID#.SHIP_ROW
                    WHERE
                        SHIP_ID IN(SELECT S.SHIP_ID FROM #dsn#_#get_period.period_year#_#get_our_comps.OUR_COMPANY_ID#.SHIP S WHERE ISNULL(S.IS_SHIP_IPTAL,0) = 0)						
                <cfif get_period.currentrow neq get_period.recordcount>UNION ALL</cfif>
                </cfoutput>					
        </cfquery>
        
        <cfquery name="cr_view" datasource="#new_dsn3#">
                CREATE VIEW [GET_ALL_STOCK_FIS_ROW] AS
                <cfoutput query="get_period">
				SELECT
					FIS_ID,
					WRK_ROW_RELATION_ID,
					AMOUNT
				FROM
					#dsn#_#get_period.period_year#_#get_our_comps.OUR_COMPANY_ID#.STOCK_FIS_ROW
                <cfif get_period.currentrow neq get_period.recordcount>UNION ALL</cfif>
                </cfoutput>
        </cfquery>	

        <cfquery name="cr_view" datasource="#new_dsn3#">
            CREATE VIEW [GET_ALL_INVOICE_ROW] AS
                <cfoutput query="get_period">
                    SELECT
                        INVOICE_ID,
						SHIP_ID,
                        WRK_ROW_RELATION_ID,
                        AMOUNT,
						WRK_ROW_ID
                    FROM
                        #dsn#_#get_period.period_year#_#get_our_comps.OUR_COMPANY_ID#.INVOICE_ROW
                    WHERE
                        INVOICE_ID IN(SELECT S.INVOICE_ID FROM #dsn#_#get_period.period_year#_#get_our_comps.OUR_COMPANY_ID#.INVOICE S WHERE ISNULL(S.IS_IPTAL,0) = 0)						
                <cfif get_period.currentrow neq get_period.recordcount>UNION ALL</cfif>
                </cfoutput>					
        </cfquery>
    </cfif>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [STOCKS] AS			 
            SELECT
                STOCKS.STOCK_ID,
                STOCKS.STOCK_CODE,
                STOCKS.STOCK_CODE_2,
                STOCKS.PRODUCT_ID,
                STOCKS.PROPERTY,
                STOCKS.BARCOD,
                STOCKS.PRODUCT_UNIT_ID,
                STOCKS.MANUFACT_CODE,
                STOCKS.STOCK_STATUS,
                STOCKS.RECORD_EMP,
                STOCKS.RECORD_IP,
                STOCKS.RECORD_DATE,
                STOCKS.UPDATE_EMP,
                STOCKS.UPDATE_IP,
                STOCKS.UPDATE_DATE,
                STOCKS.SERIAL_BARCOD,
                PRODUCT.PRODUCT_STATUS,
                PRODUCT.PRODUCT_NAME,
                PRODUCT.PRODUCT_CODE,
                PRODUCT.PRODUCT_CODE_2,
                PRODUCT.BARCOD AS PRODUCT_BARCOD,
                ISNULL((SELECT PT.TAX FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = #new_dsn#_product.PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID = #OUR_COMPANY_ID#),#new_dsn#_product.PRODUCT.TAX) TAX,
                ISNULL((SELECT PT.OTV FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = #new_dsn#_product.PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID = #OUR_COMPANY_ID#),#new_dsn#_product.PRODUCT.OTV) OTV,
                ISNULL((SELECT PT.TAX_PURCHASE FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = #new_dsn#_product.PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID = #OUR_COMPANY_ID#),#new_dsn#_product.PRODUCT.TAX_PURCHASE) TAX_PURCHASE,
                PRODUCT.COMPANY_ID,
                PRODUCT.BRAND_ID,
                PRODUCT.PRODUCT_MANAGER,
                PRODUCT.PRODUCT_CATID,
                PRODUCT.IS_INVENTORY,
                PRODUCT.IS_PRODUCTION,
                PRODUCT.IS_SALES,
                PRODUCT.IS_PURCHASE,
                PRODUCT.IS_TERAZI,
                PRODUCT.IS_SERIAL_NO,
                PRODUCT.IS_KARMA,
                PRODUCT.PRODUCT_DETAIL,
                PRODUCT.IS_PROTOTYPE,
                PRODUCT.IS_INTERNET,
                PRODUCT.IS_COST,
                PRODUCT.IS_QUALITY,
                PRODUCT.IS_ZERO_STOCK,
                PRODUCT.IS_LIMITED_STOCK,
                PRODUCT.PRODUCT_DETAIL2,
                PRODUCT.SHORT_CODE_ID,
                PRODUCT.IS_COMMISSION,
                PRODUCT.USER_FRIENDLY_URL,
                PRODUCT.SEGMENT_ID,
                PRODUCT.MIN_MARGIN,
                PRODUCT.MAX_MARGIN,
                PRODUCT.SHELF_LIFE,
                PRODUCT.PACKAGE_CONTROL_TYPE,
                PRODUCT.IS_EXTRANET,
                PRODUCT.IS_LOT_NO
            FROM   
                #new_dsn#_product.PRODUCT,
                #new_dsn#_product.STOCKS,
                #new_dsn#_product.PRODUCT_OUR_COMPANY
            WHERE     
                 (#new_dsn#_product.PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = #OUR_COMPANY_ID#) AND
                 #new_dsn#_product.PRODUCT.PRODUCT_ID = #new_dsn#_product.PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                 #new_dsn#_product.STOCKS.PRODUCT_ID = #new_dsn#_product.PRODUCT.PRODUCT_ID

</cfquery>
<cfquery name="create_company_db_views" datasource="#new_dsn3#">
    CREATE VIEW [STOCKS_BARCODES] AS
        SELECT     
            #new_dsn#_product. STOCKS_BARCODES.STOCK_ID,
            #new_dsn#_product.STOCKS_BARCODES.BARCODE,
            #new_dsn#_product.STOCKS_BARCODES.UNIT_ID
        FROM   
            #new_dsn#_product.PRODUCT,
            #new_dsn#_product.STOCKS_BARCODES,
            #new_dsn#_product.STOCKS,
            #new_dsn#_product.PRODUCT_OUR_COMPANY
        WHERE     
            (#new_dsn#_product.PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = #OUR_COMPANY_ID#) AND
            #new_dsn#_product.PRODUCT.PRODUCT_ID = #new_dsn#_product.PRODUCT_OUR_COMPANY.PRODUCT_ID AND
            #new_dsn#_product.STOCKS.PRODUCT_ID = #new_dsn#_product.PRODUCT.PRODUCT_ID AND
            #new_dsn#_product.STOCKS_BARCODES.STOCK_ID = #new_dsn#_product.STOCKS.STOCK_ID AND
            LEN(#new_dsn#_product.STOCKS_BARCODES.BARCODE) >5
</cfquery>
    
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_ORDER_ROW_RESERVED] AS
            SELECT 
                   STOCK_ID,
                   PRODUCT_ID,
                   SPECT_VAR_ID,
                   ORDER_ID,
                   STOCK_STRATEGY_ID,
                   SUM(RESERVE_STOCK_IN)      RESERVE_STOCK_IN,
                   SUM(RESERVE_STOCK_OUT)     RESERVE_STOCK_OUT,
                   SUM(STOCK_IN)              STOCK_IN,
                   SUM(STOCK_OUT)             STOCK_OUT
            FROM   ORDER_ROW_RESERVED
                   LEFT JOIN (
                            SELECT ORDER_WRK_ROW_ID,
                                   COUNT(ROW_RESERVED_ID) AS SAYAC
                            FROM   ORDER_ROW_RESERVED
                            GROUP BY
                                   ORDER_WRK_ROW_ID
                            HAVING COUNT(ROW_RESERVED_ID) > 1
                        )                  AS XXX
                        ON  XXX.ORDER_WRK_ROW_ID = ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID
            WHERE  ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NULL
                   OR  (INVOICE_ID IS NULL AND SHIP_ID IS NULL)
                   OR  (
                           (INVOICE_ID IS NOT NULL OR SHIP_ID IS NOT NULL)
                           AND ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NOT NULL
                           AND XXX.ORDER_WRK_ROW_ID IS NOT NULL
                       )
            GROUP BY
                   STOCK_ID,
                   PRODUCT_ID,
                   SPECT_VAR_ID,
                   ORDER_ID,
                   STOCK_STRATEGY_ID

</cfquery>
<cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_ORDER_ROWS_RESERVED] AS
            SELECT STOCK_ID,
               PRODUCT_ID,
			   SPECT_VAR_ID,
               ORDER_ID,
               STOCK_STRATEGY_ID,
			   ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID,
               SUM(RESERVE_STOCK_IN)      RESERVE_STOCK_IN,
               SUM(RESERVE_STOCK_OUT)     RESERVE_STOCK_OUT,
               SUM(STOCK_IN)              STOCK_IN,
               SUM(STOCK_OUT)             STOCK_OUT
            FROM   ORDER_ROW_RESERVED
               LEFT JOIN (
                        SELECT ORDER_WRK_ROW_ID,
                               COUNT(ROW_RESERVED_ID) AS SAYAC
                        FROM   ORDER_ROW_RESERVED
                        GROUP BY
                               ORDER_WRK_ROW_ID
                        HAVING COUNT(ROW_RESERVED_ID) > 1
                    )                  AS XXX
                    ON  XXX.ORDER_WRK_ROW_ID = ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID
            WHERE  ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NULL
               OR  (INVOICE_ID IS NULL AND SHIP_ID IS NULL)
               OR  (
                       (INVOICE_ID IS NOT NULL OR SHIP_ID IS NOT NULL)
                       AND ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NOT NULL
                       AND XXX.ORDER_WRK_ROW_ID IS NOT NULL
                   )
            GROUP BY
               STOCK_ID,
               PRODUCT_ID,
			   SPECT_VAR_ID,
               ORDER_ID,
			   ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID,
               STOCK_STRATEGY_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [PRODUCT_UNIT] AS
            SELECT     
                #new_dsn#_product.PRODUCT_UNIT.PRODUCT_UNIT_ID,
                #new_dsn#_product.PRODUCT_UNIT.PRODUCT_UNIT_STATUS,
                #new_dsn#_product.PRODUCT_UNIT.PRODUCT_ID,
                #new_dsn#_product.PRODUCT_UNIT.MAIN_UNIT_ID,
                #new_dsn#_product.PRODUCT_UNIT.MAIN_UNIT,
                #new_dsn#_product.PRODUCT_UNIT.UNIT_ID,
                #new_dsn#_product.PRODUCT_UNIT.ADD_UNIT,
                #new_dsn#_product.PRODUCT_UNIT.MULTIPLIER,
                #new_dsn#_product.PRODUCT_UNIT.DIMENTION,
                #new_dsn#_product.PRODUCT_UNIT.DESI_VALUE,
                #new_dsn#_product.PRODUCT_UNIT.WEIGHT,
                #new_dsn#_product.PRODUCT_UNIT.IS_MAIN,
                #new_dsn#_product.PRODUCT_UNIT.IS_SHIP_UNIT,
                #new_dsn#_product.PRODUCT_UNIT.UNIT_MULTIPLIER,
                #new_dsn#_product.PRODUCT_UNIT.UNIT_MULTIPLIER_STATIC,
                #new_dsn#_product.PRODUCT_UNIT.VOLUME,
                #new_dsn#_product.PRODUCT_UNIT.RECORD_DATE,
                #new_dsn#_product.PRODUCT_UNIT.RECORD_EMP,
                #new_dsn#_product.PRODUCT_UNIT.UPDATE_DATE,
                #new_dsn#_product.PRODUCT_UNIT.UPDATE_EMP,
                #new_dsn#_product.PRODUCT_UNIT.IS_ADD_UNIT,
                #new_dsn#_product.PRODUCT_UNIT.QUANTITY
            FROM
                #new_dsn#_product.PRODUCT,
                #new_dsn#_product.PRODUCT_UNIT,
                #new_dsn#_product.PRODUCT_OUR_COMPANY
            WHERE
                #new_dsn#_product.PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = #OUR_COMPANY_ID# AND 
                #new_dsn#_product.PRODUCT.PRODUCT_ID = #new_dsn#_product.PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                #new_dsn#_product.PRODUCT.PRODUCT_ID = #new_dsn#_product.PRODUCT_UNIT.PRODUCT_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_STOCK_RESERVED_SPECT] AS		
            SELECT
                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                S.PRODUCT_ID, 
                S.STOCK_ID,
                S.STOCK_CODE, 
                S.PROPERTY, 
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                SP.SPECT_MAIN_ID
            FROM
                STOCKS S,
                GET_ORDER_ROW_RESERVED ORR,
                ORDERS ORDS,
                PRODUCT_UNIT PU,
                SPECTS SP
            WHERE
                ORR.STOCK_ID = S.STOCK_ID AND 
                ORDS.RESERVED = 1 AND 
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                SP.SPECT_VAR_ID=ORR.SPECT_VAR_ID AND
                ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
            GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD,
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                SP.SPECT_MAIN_ID
        	UNION
            SELECT
                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                S.PRODUCT_ID, 
                S.STOCK_ID,
                S.STOCK_CODE, 
                S.PROPERTY, 
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                NULL
            FROM
                STOCKS S,
                GET_ORDER_ROW_RESERVED ORR,
                ORDERS ORDS,
                PRODUCT_UNIT PU
            WHERE
                ORR.STOCK_ID = S.STOCK_ID AND 
                ORDS.RESERVED = 1 AND 
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                ORR.SPECT_VAR_ID IS NULL AND
                ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
            GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD,
                PU.MAIN_UNIT,
                ORDS.ORDER_ID
        	UNION 
            SELECT
                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_AZALT,
                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) *SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_ARTIR,
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                NULL
             FROM
                STOCKS S,
                GET_ORDER_ROW_RESERVED ORR, 
                ORDERS ORDS,
                SPECTS_ROW SR,
                PRODUCT_UNIT PU
             WHERE
                SR.STOCK_ID = S.STOCK_ID AND 
                ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                SR.IS_SEVK=1 AND
                ORDS.RESERVED = 1 AND
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
             GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_ORDER_ROW_RESERVED_LOCATION] AS
            SELECT STOCK_ID,
                   PRODUCT_ID,
                   SPECT_VAR_ID,
                   ORDER_ID,
                   STOCK_STRATEGY_ID,
                   LOCATION_ID,
                   DEPARTMENT_ID,
                   SUM(RESERVE_STOCK_IN)      RESERVE_STOCK_IN,
                   SUM(RESERVE_STOCK_OUT)     RESERVE_STOCK_OUT,
                   SUM(STOCK_IN)              STOCK_IN,
                   SUM(STOCK_OUT)             STOCK_OUT
            FROM   ORDER_ROW_RESERVED
                   LEFT JOIN (
                            SELECT ORDER_WRK_ROW_ID,
                                   COUNT(ROW_RESERVED_ID) AS SAYAC
                            FROM   ORDER_ROW_RESERVED
                            GROUP BY
                                   ORDER_WRK_ROW_ID
                            HAVING COUNT(ROW_RESERVED_ID) > 1
                        )                  AS XXX
                        ON  XXX.ORDER_WRK_ROW_ID = ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID
            WHERE  ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NULL
                   OR  (INVOICE_ID IS NULL AND SHIP_ID IS NULL)
                   OR  (
                           (INVOICE_ID IS NOT NULL OR SHIP_ID IS NOT NULL)
                           AND ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NOT NULL
                           AND XXX.ORDER_WRK_ROW_ID IS NOT NULL
                       )
            GROUP BY
                   STOCK_ID,
                   PRODUCT_ID,
                   SPECT_VAR_ID,
                   ORDER_ID,
                   STOCK_STRATEGY_ID,
                   LOCATION_ID,
                   DEPARTMENT_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_STOCK_RESERVED_SPECT_LOCATION] AS		
            SELECT
                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                S.PRODUCT_ID, 
                S.STOCK_ID,
                S.STOCK_CODE, 
                S.PROPERTY, 
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                SP.SPECT_MAIN_ID,
                ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
            FROM
                STOCKS S,
                GET_ORDER_ROW_RESERVED_LOCATION ORR,
                ORDERS ORDS,
                PRODUCT_UNIT PU,
                SPECTS SP
            WHERE
                ORR.STOCK_ID = S.STOCK_ID AND 
                ORDS.RESERVED = 1 AND 
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                SP.SPECT_VAR_ID=ORR.SPECT_VAR_ID AND
                ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
            GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD,
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                SP.SPECT_MAIN_ID,
                ORDS.DELIVER_DEPT_ID,
                ORDS.LOCATION_ID,
                ORR.DEPARTMENT_ID,
                ORR.LOCATION_ID
       		UNION
            SELECT
                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                S.PRODUCT_ID, 
                S.STOCK_ID,
                S.STOCK_CODE, 
                S.PROPERTY, 
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                NULL,
                ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
            FROM
                STOCKS S,
                GET_ORDER_ROW_RESERVED_LOCATION ORR,
                ORDERS ORDS,
                PRODUCT_UNIT PU
            WHERE
                ORR.STOCK_ID = S.STOCK_ID AND 
                ORDS.RESERVED = 1 AND 
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                ORR.SPECT_VAR_ID IS NULL AND
                ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
            GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD,
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ORDS.DELIVER_DEPT_ID,
                ORDS.LOCATION_ID,
                ORR.DEPARTMENT_ID,
                ORR.LOCATION_ID
            UNION 
            SELECT
                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_AZALT,
                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) *SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_ARTIR,
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                NULL,
                ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
             FROM
                STOCKS S,
                GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                ORDERS ORDS,
                SPECTS_ROW SR,
                PRODUCT_UNIT PU
             WHERE
                SR.STOCK_ID = S.STOCK_ID AND 
                ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                SR.IS_SEVK=1 AND
                ORDS.RESERVED = 1 AND
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
             GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ORDS.DELIVER_DEPT_ID,
                ORDS.LOCATION_ID,
                ORR.DEPARTMENT_ID,
                ORR.LOCATION_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [PRODUCT] AS
            SELECT      
                PRODUCT.PRODUCT_ID,
                PRODUCT_STATUS,
                PRODUCT_CODE,
                COMPANY_ID,
                PRODUCT_CATID,
                BARCOD,
                PRODUCT_NAME,
                PRODUCT_DETAIL,
                PRODUCT_DETAIL2,
                ISNULL((SELECT PT.TAX FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = #new_dsn#_product.PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID=#OUR_COMPANY_ID#),#new_dsn#_product.PRODUCT.TAX) TAX,
                ISNULL((SELECT PT.TAX_PURCHASE FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = #new_dsn#_product.PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID=#OUR_COMPANY_ID#),#new_dsn#_product.PRODUCT.TAX_PURCHASE) TAX_PURCHASE,
                IS_INVENTORY,
                IS_PRODUCTION,
                SHELF_LIFE,
                IS_SALES,
                IS_PURCHASE,
                MANUFACT_CODE,
                IS_PROTOTYPE,
                PRODUCT_TREE_AMOUNT,
                PRODUCT_MANAGER,
                SEGMENT_ID,
                IS_INTERNET,
                PROD_COMPETITIVE,
                PRODUCT_STAGE,
                IS_TERAZI,
                BRAND_ID,
                IS_SERIAL_NO,
                IS_ZERO_STOCK,
                MIN_MARGIN,
                MAX_MARGIN,
                ISNULL((SELECT PT.OTV FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = #new_dsn#_product.PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID = #OUR_COMPANY_ID#),#new_dsn#_product.PRODUCT.OTV) OTV,
                IS_KARMA,
                PRODUCT_CODE_2,
                SHORT_CODE,
                IS_COST,
                IS_QUALITY,
                WORK_STOCK_ID,
                WORK_STOCK_AMOUNT,
                IS_EXTRANET,
                IS_KARMA_SEVK,
                RECORD_BRANCH_ID,
                RECORD_MEMBER,
                RECORD_DATE,
                MEMBER_TYPE,
                UPDATE_DATE,
                UPDATE_EMP,
                UPDATE_PAR,
                UPDATE_IP,
                USER_FRIENDLY_URL,
                PACKAGE_CONTROL_TYPE,
                IS_LIMITED_STOCK,
                SHORT_CODE_ID,
                IS_COMMISSION,
                CUSTOMS_RECIPE_CODE,
                IS_ADD_XML,
                IS_GIFT_CARD,
                GIFT_VALID_DAY,
                REF_PRODUCT_CODE,
                QUALITY_START_DATE,
                IS_LOT_NO,
                OTV_AMOUNT,
                OIV,
                BSMV
            FROM          
                #new_dsn#_product.PRODUCT,
                #new_dsn#_product.PRODUCT_OUR_COMPANY
            WHERE     
                (#new_dsn#_product.PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = #OUR_COMPANY_ID#) AND
                #new_dsn#_product.PRODUCT.PRODUCT_ID = #new_dsn#_product.PRODUCT_OUR_COMPANY.PRODUCT_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_STOCK_BARCODES_GENIUS] AS
        (
            (
            SELECT
                STOCKS.PRODUCT_ID,
                STOCKS.STOCK_CODE,
                STOCKS.PROPERTY,
                STOCKS.STOCK_ID,
                STOCKS.BARCOD AS BARCODE,
                PRODUCT.PRODUCT_NAME,
                PRODUCT_UNIT.MULTIPLIER,
                PRODUCT_UNIT.ADD_UNIT
            FROM
                STOCKS,
                PRODUCT,
                PRODUCT_UNIT
            WHERE
                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
            )
            
            UNION
            
            (
            SELECT
                STOCKS.PRODUCT_ID,
                STOCKS.STOCK_CODE,
                STOCKS.PROPERTY,
                STOCKS_BARCODES.STOCK_ID,
                STOCKS_BARCODES.BARCODE,
                PRODUCT.PRODUCT_NAME,
                PRODUCT_UNIT.MULTIPLIER,
                PRODUCT_UNIT.ADD_UNIT
            FROM
                STOCKS_BARCODES,
                STOCKS,
                PRODUCT,
                PRODUCT_UNIT
            WHERE
                STOCKS.STOCK_ID = STOCKS_BARCODES.STOCK_ID AND
                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
            )
        )

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_STOCK_RESERVED_ROW] AS
               SELECT
                SUM( ((RESERVE_STOCK_OUT) - (STOCK_OUT) ) *   PU.MULTIPLIER ) AS  STOCK_AZALT,
                0 AS STOCK_ARTIR,			
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID
        FROM
                #new_dsn#_product.STOCKS S 
                JOIN  GET_ORDER_ROW_RESERVED ORR ON S.STOCK_ID =  ORR.STOCK_ID
                JOIN ORDERS ORDS ON ORDS.ORDER_ID =ORR.ORDER_ID	
                JOIN #new_dsn#_product.PRODUCT_UNIT PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
               
        WHERE
                ORDS.RESERVED = 1 AND
                ORDS.ORDER_STATUS = 1 AND
                (
                    (ORDS.PURCHASE_SALES=1 AND ORDS.ORDER_ZONE=0 )
                    OR (ORDS.PURCHASE_SALES=0 AND ORDS.ORDER_ZONE=1 )
                )AND
                (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0
        GROUP BY
            S.PRODUCT_ID,
            S.STOCK_ID,
            S.STOCK_CODE,
            S.PROPERTY,
            S.BARCOD, 
            PU.MAIN_UNIT,
            ORDS.ORDER_ID 
        UNION 
            SELECT
                0 AS STOCK_AZALT,		
                SUM(  ((RESERVE_STOCK_IN) - (STOCK_IN) ) *   PU.MULTIPLIER  ) AS STOCK_ARTIR,
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID
            FROM
                #new_dsn#_product.STOCKS S 
                JOIN  GET_ORDER_ROW_RESERVED ORR ON S.STOCK_ID =  ORR.STOCK_ID
                JOIN ORDERS ORDS ON ORDS.ORDER_ID =ORR.ORDER_ID	
                JOIN #new_dsn#_product.PRODUCT_UNIT PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                JOIN #new_dsn#.STOCKS_LOCATION SL ON  ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND ORDS.LOCATION_ID=SL.LOCATION_ID 
            WHERE
                ORR.STOCK_ID = S.STOCK_ID AND 
                ORDS.RESERVED = 1 AND
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND		
                ORDS.PURCHASE_SALES=0 AND
                ORDS.ORDER_ZONE=0 AND
                ORDS.DELIVER_DEPT_ID IS NOT NULL AND 
                SL.NO_SALE = 0 AND
                (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
            GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD,
                PU.MAIN_UNIT,
                ORDS.ORDER_ID
        UNION
            SELECT
                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                0 ORDER_ID
             FROM
                STOCKS S,
                GET_ORDER_ROW_RESERVED ORR, 
                PRODUCT_UNIT PU
             WHERE
                ORR.STOCK_ID=S.STOCK_ID AND
                ORR.ORDER_ID IS NULL AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
             GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_STOCK_RESERVED_ROW_LOCATION] AS
            SELECT
                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                0 AS STOCK_ARTIR,			
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
             FROM
                STOCKS S,
                GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                ORDERS ORDS,		
                PRODUCT_UNIT PU
             WHERE
                ORR.STOCK_ID = S.STOCK_ID AND 
                ORDS.RESERVED = 1 AND
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND
                (
                    (ORDS.PURCHASE_SALES=1 AND ORDS.ORDER_ZONE=0 )
                    OR (ORDS.PURCHASE_SALES=0 AND ORDS.ORDER_ZONE=1 )
                )AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0
             GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD,
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ORDS.DELIVER_DEPT_ID,
                ORDS.LOCATION_ID,
                ORR.DEPARTMENT_ID,
                ORR.LOCATION_ID
        	UNION
            SELECT
                0 AS STOCK_AZALT,
                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,			
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
             FROM
                STOCKS S,
                GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                ORDERS ORDS,
                #new_dsn#.STOCKS_LOCATION SL,	
                PRODUCT_UNIT PU
             WHERE
                ORR.STOCK_ID = S.STOCK_ID AND 
                ORDS.RESERVED = 1 AND
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND		
                ORDS.PURCHASE_SALES=0 AND
                ORDS.ORDER_ZONE=0 AND
                ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND
                ORDS.LOCATION_ID=SL.LOCATION_ID AND
                ORDS.DELIVER_DEPT_ID IS NOT NULL AND 
                SL.NO_SALE = 0 AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
             GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD,
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ORDS.DELIVER_DEPT_ID,
                ORDS.LOCATION_ID,
                ORR.DEPARTMENT_ID,
                ORR.LOCATION_ID
        	UNION 
            SELECT
                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_AZALT,
                0 AS STOCK_ARTIR,
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
             FROM
                STOCKS S,
                GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                ORDERS ORDS,
                SPECTS_ROW SR,		
                PRODUCT_UNIT PU
             WHERE
                SR.STOCK_ID = S.STOCK_ID AND 
                ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                SR.IS_SEVK=1 AND
                ORDS.RESERVED = 1 AND
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND
                (
                    (ORDS.PURCHASE_SALES=1 AND ORDS.ORDER_ZONE=0 )
                    OR (ORDS.PURCHASE_SALES=0 AND ORDS.ORDER_ZONE=1 )
                )AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0
             GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ORDS.DELIVER_DEPT_ID,
                ORDS.LOCATION_ID,
                ORR.DEPARTMENT_ID,
                ORR.LOCATION_ID
        	UNION 	
            SELECT
                0 AS STOCK_AZALT,
                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_ARTIR,
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD,
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
             FROM
                STOCKS S,
                GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                ORDERS ORDS,
                SPECTS_ROW SR,
                #new_dsn#.STOCKS_LOCATION SL,
                PRODUCT_UNIT PU
             WHERE
                SR.STOCK_ID = S.STOCK_ID AND 
                ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                SR.IS_SEVK=1 AND
                ORDS.RESERVED = 1 AND
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND
                ORDS.PURCHASE_SALES=0 AND
                ORDS.ORDER_ZONE=0 AND
                ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND
                ORDS.LOCATION_ID=SL.LOCATION_ID AND
                ORDS.DELIVER_DEPT_ID IS NOT NULL AND 
                SL.NO_SALE = 0  AND		
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
             GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ORDS.DELIVER_DEPT_ID,
                ORDS.LOCATION_ID,
                ORR.DEPARTMENT_ID,
                ORR.LOCATION_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_STOCK_RESERVED] AS
            SELECT 
                SUM(STOCK_AZALT) AS STOCK_AZALT,
                SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                PRODUCT_ID,
                STOCK_ID,
                STOCK_CODE,
                PROPERTY,
                BARCOD,
                MAIN_UNIT
            FROM 
                GET_STOCK_RESERVED_ROW
            GROUP BY 
                PRODUCT_ID,
                STOCK_ID,
                STOCK_CODE,
                PROPERTY,
                BARCOD,
                MAIN_UNIT

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_PRODUCTION_RESERVED] AS
            SELECT
					SUM(STOCK_ARTIR) STOCK_ARTIR,
					SUM(STOCK_AZALT) STOCK_AZALT,
					STOCK_ID,
					PRODUCT_ID
				FROM
					(
					SELECT
                        CASE WHEN SUM(STOCK_ARTIR) > 0 THEN SUM(STOCK_ARTIR) ELSE 0 END AS STOCK_ARTIR,
                        CASE WHEN SUM(STOCK_AZALT) > 0 THEN SUM(STOCK_AZALT) ELSE 0 END AS STOCK_AZALT,
                        S.STOCK_ID,
                        S.PRODUCT_ID,
						P_ORDER_ID
                    FROM
                        (
                            SELECT
                                (QUANTITY) AS STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                STOCK_ID,
								P_ORDER_ID
                            FROM
                                PRODUCTION_ORDERS
                            WHERE
                                IS_STOCK_RESERVED = 1 AND
                                IS_DEMONTAJ=0 AND
                                SPEC_MAIN_ID IS NOT NULL
								AND STATUS=1
							
                        UNION ALL
                            SELECT
                                0 AS STOCK_ARTIR,
                                (QUANTITY) AS STOCK_AZALT,
                                STOCK_ID,
								P_ORDER_ID
                            FROM
                                PRODUCTION_ORDERS
                            WHERE
                                IS_STOCK_RESERVED = 1 AND
                                IS_DEMONTAJ=1 AND
                                SPEC_MAIN_ID IS NOT NULL
								AND STATUS=1
								
                        UNION ALL
                            SELECT
                                0 AS STOCK_ARTIR,
                                CASE WHEN ISNULL((SELECT
											SUM(POR_.AMOUNT)
										FROM
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID = PO.P_ORDER_ID
											AND POR_.STOCK_ID = POS.STOCK_ID
											AND POO.IS_STOCK_FIS = 1
										),0) > (ISNULL(PO.RESULT_AMOUNT,0))
										
						THEN
						 (
											(
													SELECT 
														SUM(AMOUNT) AMOUNT
													FROM
														PRODUCTION_ORDERS_STOCKS
													WHERE
													P_ORDER_ID = PO.P_ORDER_ID AND STOCK_ID = POS.STOCK_ID
											)
											/
											(
											
												SELECT 
													QUANTITY 
												FROM 
													PRODUCTION_ORDERS
												WHERE
													P_ORDER_ID = PO.P_ORDER_ID
											)
										
										)*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0))
						 ELSE 									
                         (((POS.AMOUNT*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0)))/(ISNULL(PO.QUANTITY,0)))) END AS STOCK_AZALT,
                                POS.STOCK_ID,
								PO.P_ORDER_ID
                            FROM
                                PRODUCTION_ORDERS PO,
                                PRODUCTION_ORDERS_STOCKS POS
                            WHERE
                                PO.IS_STOCK_RESERVED = 1 AND
                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                PO.IS_DEMONTAJ=0 AND
                                ISNULL(POS.STOCK_ID,0)>0 AND
                                POS.IS_SEVK <> 1 AND
                                ISNULL(IS_FREE_AMOUNT,0) = 0
								AND PO.STATUS=1
                        UNION ALL
                            SELECT
                                POS.AMOUNT AS STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                POS.STOCK_ID,
								PO.P_ORDER_ID
                            FROM
                                PRODUCTION_ORDERS PO,
                                PRODUCTION_ORDERS_STOCKS POS
                            WHERE
                                PO.IS_STOCK_RESERVED = 1 AND
                                POS.P_ORDER_ID = PO.P_ORDER_ID AND
                                PO.IS_DEMONTAJ=1 AND
                                ISNULL(POS.STOCK_ID,0)>0 AND
                                POS.IS_SEVK <> 1 AND
                                ISNULL(IS_FREE_AMOUNT,0) = 0
								AND PO.STATUS=1
                        UNION ALL
                            SELECT 
                                (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                P_ORD_R_R.STOCK_ID,
								P_ORD_R.P_ORDER_ID
                            FROM
                                PRODUCTION_ORDER_RESULTS P_ORD_R,
                                PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                PRODUCTION_ORDERS P_ORD
                            WHERE
                                P_ORD.IS_STOCK_RESERVED=1 AND
                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                P_ORD_R_R.TYPE=1 AND
                                P_ORD_R.IS_STOCK_FIS=1 AND
                                P_ORD_R_R.IS_SEVKIYAT IS NULL
								AND P_ORD.STATUS=1
       
                    ) T1,
                     #new_prod_db#.STOCKS S
                    WHERE
                        S.STOCK_ID=T1.STOCK_ID					
                    GROUP BY 
                        S.STOCK_ID,
                        S.PRODUCT_ID,
						P_ORDER_ID
					)T2
				GROUP BY
					STOCK_ID,
					PRODUCT_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_STOCK_RESERVED_LAST] AS
            SELECT 
                SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                SUM(STOCK_AZALT) AS STOCK_AZALT,
                SUM(STOCK_ARTIR-STOCK_AZALT) AS FARK,
                PRODUCT_ID,
                STOCK_ID
            FROM
                (	
                SELECT
                    GSR.STOCK_ARTIR AS STOCK_ARTIR,
                    GSR.STOCK_AZALT AS STOCK_AZALT, 
                    GSR.PRODUCT_ID,
                    GSR.STOCK_ID
                FROM
                    GET_STOCK_RESERVED GSR
                
        UNION 
                    
                SELECT
                    GPR.STOCK_ARTIR,
                    GPR.STOCK_AZALT,
                    GPR.PRODUCT_ID,
                    GPR.STOCK_ID
                FROM
                    GET_PRODUCTION_RESERVED GPR
                )  AS TOTAL_RESERVE
            
            GROUP BY
                PRODUCT_ID,
                STOCK_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_PRODUCTION_RESERVED_SPECT] AS
           SELECT
						SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                        SUM(STOCK_AZALT) AS STOCK_AZALT,
                        STOCK_ID,
                        PRODUCT_ID,
                        SPECT_MAIN_ID
					FROM
						(
						SELECT
                            CASE WHEN SUM(STOCK_ARTIR) > 0 THEN SUM(STOCK_ARTIR) ELSE 0 END AS STOCK_ARTIR,
                            CASE WHEN SUM(STOCK_AZALT) > 0 THEN SUM(STOCK_AZALT) ELSE 0 END AS STOCK_AZALT,
                            S.STOCK_ID,
                            S.PRODUCT_ID,
                            T1.SPECT_MAIN_ID,
							T1.P_ORDER_ID
                        FROM
                        (
                            SELECT 	
                                (P_ORD.QUANTITY) AS STOCK_ARTIR,
                                0 AS STOCK_AZALT,	
                                P_ORD.STOCK_ID,
                                P_ORD.SPEC_MAIN_ID SPECT_MAIN_ID,
								P_ORD.P_ORDER_ID
                            FROM
                                PRODUCTION_ORDERS P_ORD
                            WHERE 
                                P_ORD.IS_STOCK_RESERVED = 1 AND 
                                P_ORD.IS_DEMONTAJ=0
								AND P_ORD.STATUS=1
                        UNION ALL
                            SELECT 	
                                0 AS STOCK_ARTIR,
                                (P_ORD.QUANTITY) AS STOCK_AZALT,	
                                P_ORD.STOCK_ID, 
                                POS.SPECT_MAIN_ID SPECT_MAIN_ID,
								P_ORD.P_ORDER_ID
                            FROM
                                PRODUCTION_ORDERS P_ORD,
                                PRODUCTION_ORDERS_STOCKS POS
                            WHERE 
                                P_ORD.IS_STOCK_RESERVED = 1 AND 
                                P_ORD.P_ORDER_ID=POS.P_ORDER_ID AND
                                P_ORD.IS_DEMONTAJ=1 AND
                                ISNULL(IS_FREE_AMOUNT,0) = 0
								AND P_ORD.STATUS=1
                        UNION ALL
                            SELECT
                                0 AS STOCK_ARTIR,	
                                 CASE WHEN ISNULL((SELECT
											SUM(POR_.AMOUNT)
										FROM
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID = PO.P_ORDER_ID
											AND POR_.STOCK_ID = POS.STOCK_ID
											AND POO.IS_STOCK_FIS = 1
										),0) > (ISNULL(PO.RESULT_AMOUNT,0))
										
						THEN
						 (
											(
													SELECT 
														SUM(AMOUNT) AMOUNT
													FROM
														PRODUCTION_ORDERS_STOCKS
													WHERE
													P_ORDER_ID = PO.P_ORDER_ID AND STOCK_ID = POS.STOCK_ID
											)
											/
											(
											
												SELECT 
													QUANTITY 
												FROM 
													PRODUCTION_ORDERS
												WHERE
													P_ORDER_ID = PO.P_ORDER_ID
											)
										
										)*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0))
						 ELSE 									
                         (POS.AMOUNT - ISNULL((SELECT
											SUM(POR_.AMOUNT)
										FROM
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID = PO.P_ORDER_ID
											AND POR_.STOCK_ID = POS.STOCK_ID
											AND POO.IS_STOCK_FIS = 1
										),0)) END AS STOCK_AZALT,
                                POS.STOCK_ID,
                                POS.SPECT_MAIN_ID SPECT_MAIN_ID,
								PO.P_ORDER_ID
                            FROM
                                PRODUCTION_ORDERS PO,
                                PRODUCTION_ORDERS_STOCKS POS
                            WHERE
                                PO.IS_STOCK_RESERVED=1 AND
                                PO.P_ORDER_ID=POS.P_ORDER_ID AND

                                PO.IS_DEMONTAJ=0 AND
                                POS.IS_SEVK <> 1 AND
                                ISNULL(IS_FREE_AMOUNT,0) = 0
								AND PO.STATUS=1
                        UNION ALL
                            SELECT
                                POS.AMOUNT AS STOCK_ARTIR,	
                                0 AS STOCK_AZALT,
                                POS.STOCK_ID,
                                POS.SPECT_MAIN_ID,
								PO.P_ORDER_ID
                            FROM
                                PRODUCTION_ORDERS PO,
                                PRODUCTION_ORDERS_STOCKS POS
                            WHERE
                                PO.IS_STOCK_RESERVED=1 AND
                                PO.P_ORDER_ID=POS.P_ORDER_ID AND
                                PO.IS_DEMONTAJ = 1 AND
                                POS.IS_SEVK <> 1 AND
                                ISNULL(IS_FREE_AMOUNT,0) = 0
								AND PO.STATUS=1
                        UNION ALL
                            SELECT 
                                (P_ORD_R_R.AMOUNT)*-1 AS STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                P_ORD_R_R.STOCK_ID,
                                P_ORD_R_R.SPEC_MAIN_ID SPECT_MAIN_ID,
								P_ORD.P_ORDER_ID
                            FROM
                                PRODUCTION_ORDER_RESULTS P_ORD_R,
                                PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                PRODUCTION_ORDERS P_ORD,
                                SPECT_MAIN SP
                            WHERE
                                P_ORD.IS_STOCK_RESERVED=1 AND
                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                SP.SPECT_MAIN_ID=P_ORD_R_R.SPEC_MAIN_ID AND
                                P_ORD_R_R.TYPE=1 AND
                                P_ORD_R.IS_STOCK_FIS=1 AND
                                ISNULL(P_ORD_R_R.IS_SEVKIYAT,0)<>1
								AND P_ORD.STATUS=1
                        UNION ALL
                            SELECT 
                                0 AS STOCK_ARTIR,
                                (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                                P_ORD_R_R.STOCK_ID,
                                P_ORD_R_R.SPEC_MAIN_ID SPECT_MAIN_ID,
								P_ORD.P_ORDER_ID
                            FROM
                                PRODUCTION_ORDER_RESULTS P_ORD_R,
                                PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                PRODUCTION_ORDERS P_ORD,
                                SPECT_MAIN SP
                            WHERE
                                P_ORD.IS_STOCK_RESERVED=1 AND
                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                SP.SPECT_MAIN_ID=P_ORD_R_R.SPEC_MAIN_ID AND
                                P_ORD_R_R.TYPE IN(2,3) AND
                                P_ORD_R.IS_STOCK_FIS=1 AND
                                ISNULL(P_ORD_R_R.IS_SEVKIYAT,0)<>1
								AND P_ORD.STATUS=1
       
                        ) T1,
                            #new_prod_db#.STOCKS S
                        WHERE
                            S.STOCK_ID=T1.STOCK_ID
                        GROUP BY 
                            S.STOCK_ID,
                            S.PRODUCT_ID,
                            T1.SPECT_MAIN_ID,
							T1.P_ORDER_ID
					)T2
				GROUP BY
					STOCK_ID,
                    PRODUCT_ID,
                    SPECT_MAIN_ID   
</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_STOCK_RESERVED_LAST_SPECT] AS
            SELECT 
                SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                SUM(STOCK_AZALT) AS STOCK_AZALT,
                SUM(STOCK_ARTIR-STOCK_AZALT) AS FARK,
                PRODUCT_ID,
                STOCK_ID,
                SPECT_MAIN_ID
            FROM
            (	 
                SELECT
                    GSR.STOCK_ARTIR AS STOCK_ARTIR,
                    GSR.STOCK_AZALT AS STOCK_AZALT, 
                    GSR.PRODUCT_ID,
                    GSR.STOCK_ID,
                    GSR.SPECT_MAIN_ID
                FROM
                    GET_STOCK_RESERVED_SPECT GSR
                
            UNION 
                    
                SELECT
                    GPR.STOCK_ARTIR,
                    GPR.STOCK_AZALT,
                    GPR.PRODUCT_ID,
                    GPR.STOCK_ID,
                    GPR.SPECT_MAIN_ID
                FROM
                    GET_PRODUCTION_RESERVED_SPECT GPR
                )  AS TOTAL_RESERVE
            
            GROUP BY
                 PRODUCT_ID,
                 STOCK_ID,
                 SPECT_MAIN_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [PRICE_STANDART] AS
            SELECT      
                #new_dsn#_product.PRICE_STANDART.*
            FROM   
                #new_dsn#_product.PRODUCT,
                #new_dsn#_product.PRICE_STANDART,
                #new_dsn#_product.PRODUCT_OUR_COMPANY
            WHERE     
                (#new_dsn#_product.PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = #OUR_COMPANY_ID#) AND
                #new_dsn#_product.PRODUCT.PRODUCT_ID = #new_dsn#_product.PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                #new_dsn#_product.PRICE_STANDART.PRODUCT_ID = #new_dsn#_product.PRODUCT.PRODUCT_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [PRODUCT_COST] AS
            SELECT      
                #new_dsn#_product.PRODUCT_COST.PRODUCT_COST_ID,
                #new_dsn#_product.PRODUCT_COST.PROCESS_STAGE,
                #new_dsn#_product.PRODUCT_COST.PRODUCT_ID,
                #new_dsn#_product.PRODUCT_COST.UNIT_ID,
                #new_dsn#_product.PRODUCT_COST.IS_SPEC,
                #new_dsn#_product.PRODUCT_COST.SPECT_MAIN_ID,
                #new_dsn#_product.PRODUCT_COST.PRODUCT_COST_STATUS,
                #new_dsn#_product.PRODUCT_COST.INVENTORY_CALC_TYPE,
                #new_dsn#_product.PRODUCT_COST.START_DATE,
                #new_dsn#_product.PRODUCT_COST.COST_TYPE_ID,
                #new_dsn#_product.PRODUCT_COST.PRODUCT_COST,
                #new_dsn#_product.PRODUCT_COST.MONEY,
                #new_dsn#_product.PRODUCT_COST.STANDARD_COST,
                #new_dsn#_product.PRODUCT_COST.STANDARD_COST_MONEY,
                #new_dsn#_product.PRODUCT_COST.STANDARD_COST_RATE,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_MONEY,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_EXTRA_COST,
                #new_dsn#_product.PRODUCT_COST.PRICE_PROTECTION,
                #new_dsn#_product.PRODUCT_COST.PRICE_PROTECTION_MONEY,
                #new_dsn#_product.PRODUCT_COST.PRICE_PROTECTION_TYPE,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM,
                #new_dsn#_product.PRODUCT_COST.PRODUCT_COST_SYSTEM,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_2,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_2,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2,
                #new_dsn#_product.PRODUCT_COST.AVAILABLE_STOCK,
                #new_dsn#_product.PRODUCT_COST.PARTNER_STOCK,
                #new_dsn#_product.PRODUCT_COST.ACTIVE_STOCK,
                #new_dsn#_product.PRODUCT_COST.IS_STANDARD_COST,
                #new_dsn#_product.PRODUCT_COST.IS_ACTIVE_STOCK,
                #new_dsn#_product.PRODUCT_COST.IS_PARTNER_STOCK,
                #new_dsn#_product.PRODUCT_COST.COST_DESCRIPTION,
                #new_dsn#_product.PRODUCT_COST.ACTION_PROCESS_TYPE,
                #new_dsn#_product.PRODUCT_COST.ACTION_PROCESS_CAT_ID,
                #new_dsn#_product.PRODUCT_COST.ACTION_ID,
                #new_dsn#_product.PRODUCT_COST.ACTION_ROW_ID,
                #new_dsn#_product.PRODUCT_COST.ACTION_ROW_PRICE,
                #new_dsn#_product.PRODUCT_COST.ACTION_TYPE,
                #new_dsn#_product.PRODUCT_COST.ACTION_PERIOD_ID,
                #new_dsn#_product.PRODUCT_COST.ACTION_AMOUNT,
                #new_dsn#_product.PRODUCT_COST.ACTION_DATE,
                #new_dsn#_product.PRODUCT_COST.ACTION_DUE_DATE,
                #new_dsn#_product.PRODUCT_COST.DEPARTMENT_ID,
                #new_dsn#_product.PRODUCT_COST.LOCATION_ID,
                #new_dsn#_product.PRODUCT_COST.PRODUCT_COST_LOCATION,
                #new_dsn#_product.PRODUCT_COST.MONEY_LOCATION,
                #new_dsn#_product.PRODUCT_COST.STANDARD_COST_LOCATION,
                #new_dsn#_product.PRODUCT_COST.STANDARD_COST_MONEY_LOCATION,
                #new_dsn#_product.PRODUCT_COST.STANDARD_COST_RATE_LOCATION,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_LOCATION,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_EXTRA_COST_LOCATION,
                #new_dsn#_product.PRODUCT_COST.PRICE_PROTECTION_LOCATION,
                #new_dsn#_product.PRODUCT_COST.PRICE_PROTECTION_MONEY_LOCATION,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_LOCATION,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_2_LOCATION,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,
                #new_dsn#_product.PRODUCT_COST.AVAILABLE_STOCK_LOCATION,
                #new_dsn#_product.PRODUCT_COST.PARTNER_STOCK_LOCATION,
                #new_dsn#_product.PRODUCT_COST.ACTIVE_STOCK_LOCATION,
                #new_dsn#_product.PRODUCT_COST.IS_SEVK,
                #new_dsn#_product.PRODUCT_COST.RECORD_DATE,
                #new_dsn#_product.PRODUCT_COST.RECORD_EMP,
                #new_dsn#_product.PRODUCT_COST.RECORD_IP,
                #new_dsn#_product.PRODUCT_COST.UPDATE_DATE,
                #new_dsn#_product.PRODUCT_COST.UPDATE_EMP,
                #new_dsn#_product.PRODUCT_COST.UPDATE_IP,
                #new_dsn#_product.PRODUCT_COST.IS_SUGGEST,
                #new_dsn#_product.PRODUCT_COST.PRICE_PROTECTION_TOTAL,
                #new_dsn#_product.PRODUCT_COST.PRICE_PROTECTION_AMOUNT,
                #new_dsn#_product.PRODUCT_COST.DUE_DATE,
                #new_dsn#_product.PRODUCT_COST.DUE_DATE_LOCATION,
                #new_dsn#_product.PRODUCT_COST.PHYSICAL_DATE,
                #new_dsn#_product.PRODUCT_COST.PHYSICAL_DATE_LOCATION,
                #new_dsn#_product.PRODUCT_COST.ACTION_EXTRA_COST,
                #new_dsn#_product.PRODUCT_COST.STOCK_ID,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_ALL,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_ALL,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_2_ALL,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_LOCATION_ALL,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION_ALL,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_2_LOCATION_ALL,
                #new_dsn#_product.PRODUCT_COST.AVAILABLE_STOCK_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PARTNER_STOCK_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.ACTIVE_STOCK_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PRODUCT_COST_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.MONEY_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.STANDARD_COST_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.STANDARD_COST_MONEY_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.STANDARD_COST_RATE_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_MONEY_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_EXTRA_COST_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PRICE_PROTECTION_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PRICE_PROTECTION_MONEY_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_2_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_2_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.DUE_DATE_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PHYSICAL_DATE_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.PURCHASE_NET_DEPARTMENT_ALL,
				#new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_DEPARTMENT_ALL,
				#new_dsn#_product.PRODUCT_COST.PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL,
                #new_dsn#_product.PRODUCT_COST.STATION_REFLECTION_COST,
                #new_dsn#_product.PRODUCT_COST.LABOR_COST,
                #new_dsn#_product.PRODUCT_COST.STATION_REFLECTION_COST_SYSTEM_2,
                #new_dsn#_product.PRODUCT_COST.LABOR_COST_SYSTEM_2,
                #new_dsn#_product.PRODUCT_COST.STATION_REFLECTION_COST_SYSTEM,
                #new_dsn#_product.PRODUCT_COST.LABOR_COST_SYSTEM ,
                #new_dsn#_product.PRODUCT_COST.STATION_REFLECTION_COST_LOCATION,
                #new_dsn#_product.PRODUCT_COST.LABOR_COST_LOCATION,
                #new_dsn#_product.PRODUCT_COST.STATION_REFLECTION_COST_SYSTEM_2_LOCATION, 
                #new_dsn#_product.PRODUCT_COST.LABOR_COST_SYSTEM_2_LOCATION,
                #new_dsn#_product.PRODUCT_COST.STATION_REFLECTION_COST_SYSTEM_LOCATION ,
                #new_dsn#_product.PRODUCT_COST.LABOR_COST_SYSTEM_LOCATION,
                #new_dsn#_product.PRODUCT_COST.STATION_REFLECTION_COST_SYSTEM_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.LABOR_COST_SYSTEM_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.STATION_REFLECTION_COST_DEPARTMENT,			
                #new_dsn#_product.PRODUCT_COST.STATION_REFLECTION_COST_SYSTEM_2_DEPARTMENT ,
                #new_dsn#_product.PRODUCT_COST.LABOR_COST_DEPARTMENT,
                #new_dsn#_product.PRODUCT_COST.LABOR_COST_SYSTEM_2_DEPARTMENT
            FROM   
                 #new_dsn#_product.PRODUCT,
                 #new_dsn#_product.PRODUCT_COST,
                 #new_dsn#_product.PRODUCT_OUR_COMPANY,
                 #new_dsn#.SETUP_PERIOD
            WHERE     
                #new_dsn#.SETUP_PERIOD.OUR_COMPANY_ID = #OUR_COMPANY_ID# AND
                #new_dsn#.SETUP_PERIOD.PERIOD_ID = #new_dsn#_product.PRODUCT_COST.ACTION_PERIOD_ID AND   
                (#new_dsn#_product.PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = #OUR_COMPANY_ID#) AND
                #new_dsn#_product.PRODUCT.PRODUCT_ID = #new_dsn#_product.PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                #new_dsn#_product.PRODUCT_COST.PRODUCT_ID = #new_dsn#_product.PRODUCT.PRODUCT_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [PRODUCT_UNIT_PROFIT] AS
            SELECT
                SUM(PRICE_STANDART.PRICE - PRODUCT_COST.PRODUCT_COST) AS PROFIT,
                PRODUCT.PRODUCT_NAME, PRODUCT.PRODUCT_ID, 
                PRODUCT_COST.MONEY, PRODUCT_UNIT.ADD_UNIT AS UNIT
            FROM
                PRICE_STANDART, 
                PRODUCT_COST, 
                PRODUCT, 
                PRODUCT_UNIT
            WHERE
                PRICE_STANDART.PRODUCT_ID = PRODUCT_COST.PRODUCT_ID AND 
                PRICE_STANDART.UNIT_ID = PRODUCT_COST.UNIT_ID AND
                PRODUCT_COST.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                PRODUCT_COST.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
                PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                PRICE_STANDART.PURCHASESALES = 1 AND 
                PRODUCT_COST.PRODUCT_COST_STATUS = 1
            GROUP BY
                PRODUCT.PRODUCT_NAME,
                PRODUCT.PRODUCT_ID,
                PRODUCT_COST.MONEY,
                PRODUCT_UNIT.ADD_UNIT

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [DAILY_INVENTORIES] AS 
            SELECT 
                SUM(LAST_INVENTORY_VALUE) LAST_INVENTORY_VALUE,
                SUM(LAST_INVENTORY_VALUE_2) LAST_INVENTORY_VALUE_2,
                ENTRY_DATE
            FROM
                (
                    SELECT
                        SUM(LAST_INVENTORY_VALUE*QUANTITY) LAST_INVENTORY_VALUE,
                        SUM(LAST_INVENTORY_VALUE_2*QUANTITY) LAST_INVENTORY_VALUE_2,
                        ENTRY_DATE
                    FROM
                        INVENTORY
                    GROUP BY ENTRY_DATE
                ) AS INVENTORY_VALUE
            GROUP BY
                ENTRY_DATE

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [DAILY_TOTAL_INVENTORIES] AS
        SELECT 
            D1.ENTRY_DATE,
            SUM(D2.LAST_INVENTORY_VALUE) LAST_INVENTORY_VALUE,
            SUM(D2.LAST_INVENTORY_VALUE_2) LAST_INVENTORY_VALUE_2
        FROM
            DAILY_INVENTORIES D1,
            DAILY_INVENTORIES D2
        WHERE
            D1.ENTRY_DATE >= D2.ENTRY_DATE
        GROUP BY
            D1.ENTRY_DATE

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [PRICE_STANDART_DISCOUNT] AS
            SELECT
                PS.PRODUCT_ID,
                (
                SELECT TOP 1 ((((((((((((PS.PRICE - ISNULL(PC.DISCOUNT_CASH,0)) * (100-ISNULL(PC.DISCOUNT1,0))/100)* (100-ISNULL(PC.DISCOUNT2,0))/100)* (100-ISNULL(PC.DISCOUNT3,0))/100)* (100-ISNULL(PC.DISCOUNT4,0))/100)* (100-ISNULL(PC.DISCOUNT5,0))/100)* (100-ISNULL(PC.DISCOUNT6,0))/100)* (100-ISNULL(PC.DISCOUNT7,0))/100)*(100-ISNULL(PC.DISCOUNT8,0))/100)*(100-ISNULL(PC.DISCOUNT9,0))/100)*(100-ISNULL(PC.DISCOUNT10,0))/100))
                FROM 
                    CONTRACT_PURCHASE_PROD_DISCOUNT PC
                WHERE
                    PC.PRODUCT_ID=PS.PRODUCT_ID AND
                    (PC.FINISH_DATE >= PS.START_DATE OR PC.FINISH_DATE IS NULL)
                ORDER BY PC.START_DATE DESC
                ) NET_PRICE,
                (
                SELECT TOP 1 ((((((((((((PS.PRICE - ISNULL(PC.DISCOUNT_CASH,0)) * (100-ISNULL(PC.DISCOUNT1,0))/100)* (100-ISNULL(PC.DISCOUNT2,0))/100)* (100-ISNULL(PC.DISCOUNT3,0))/100)* (100-ISNULL(PC.DISCOUNT4,0))/100)* (100-ISNULL(PC.DISCOUNT5,0))/100)* (100-ISNULL(PC.DISCOUNT6,0))/100)* (100-ISNULL(PC.DISCOUNT7,0))/100)*(100-ISNULL(PC.DISCOUNT8,0))/100)*(100-ISNULL(PC.DISCOUNT9,0))/100)*(100-ISNULL(PC.DISCOUNT10,0))/100))
                FROM 
                    CONTRACT_PURCHASE_PROD_DISCOUNT PC
                WHERE
                    PC.PRODUCT_ID=PS.PRODUCT_ID AND
                    (PC.FINISH_DATE >= PS.START_DATE OR PC.FINISH_DATE IS NULL)
                ORDER BY PC.START_DATE DESC
                )*(100+P.TAX_PURCHASE)/100 NET_PRICE_KDV,
                PS.PRICE PRICE ,
                PS.PRICE_KDV PRICE_KDV,
                PS.MONEY MONEY,
                PU.ADD_UNIT ADD_UNIT,
                PU.MAIN_UNIT MAIN_UNIT
            FROM
                PRODUCT P,
                PRICE_STANDART PS,
                PRODUCT_UNIT PU
            WHERE
                P.PRODUCT_ID=PS.PRODUCT_ID AND
                PS.PURCHASESALES = 0 AND
                PS.PRICESTANDART_STATUS = 1 AND	
                PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
                PU.IS_MAIN=1

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_STOCK_RESERVED_TRIGGER] AS
            SELECT 
                SUM(STOCK_AZALT) AS STOCK_AZALT,
                SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                PRODUCT_ID,
                STOCK_ID,
                STOCK_CODE,
                PROPERTY,
                BARCOD,
                MAIN_UNIT
            FROM 
            (
                SELECT
                    SUM((ORR.RESERVE_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                    0 AS STOCK_ARTIR,			
            
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PROPERTY,
                    S.BARCOD, 
                    PU.MAIN_UNIT
                 FROM
                    STOCKS S,
                    ORDER_RESERVED_TOTAL ORR, 
                    PRODUCT_UNIT PU
                 WHERE
                    ORR.STOCK_ID = S.STOCK_ID AND			
                    S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                    (ORR.RESERVE_OUT-ORR.STOCK_OUT)>0
                 GROUP BY
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PROPERTY,
                    S.BARCOD,
                    PU.MAIN_UNIT
            	UNION
                SELECT
                    0 AS STOCK_AZALT,
                    SUM((ORR.RESERVE_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,			
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PROPERTY,
                    S.BARCOD, 
                    PU.MAIN_UNIT
                 FROM
                    STOCKS S,
                    ORDER_RESERVED_TOTAL ORR, 
                    ORDERS ORDS,
                    #new_dsn#.STOCKS_LOCATION SL,	
                    PRODUCT_UNIT PU
                 WHERE
                    ORR.STOCK_ID = S.STOCK_ID AND 
                    ORR.DEPARTMENT_ID =SL.DEPARTMENT_ID AND
                    ORR.LOCATION_ID=SL.LOCATION_ID AND
                    ORR.DEPARTMENT_ID IS NOT NULL AND 
                    SL.NO_SALE = 0 AND
                    S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                    (ORR.RESERVE_IN-ORR.STOCK_IN)>0
                 GROUP BY
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PROPERTY,
                    S.BARCOD,
                    PU.MAIN_UNIT
            	UNION 
                SELECT
                    SUM((ORR.RESERVE_OUT-ORR.STOCK_OUT)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_AZALT,
                    0 AS STOCK_ARTIR,
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PROPERTY,
                    S.BARCOD, 
                    PU.MAIN_UNIT
                 FROM
                    STOCKS S,
                    ORDER_RESERVED_TOTAL ORR,
                    SPECTS_ROW SR,		
                    PRODUCT_UNIT PU
                 WHERE
                    SR.STOCK_ID = S.STOCK_ID AND 
                    ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                    SR.IS_SEVK=1 AND
                    S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                    (ORR.RESERVE_OUT-ORR.STOCK_OUT)>0
                 GROUP BY
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PROPERTY,
                    S.BARCOD, 
                    PU.MAIN_UNIT
            	UNION 	
                SELECT
                    0 AS STOCK_AZALT,
                    SUM((ORR.RESERVE_IN-ORR.STOCK_IN)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_ARTIR,
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PROPERTY,
                    S.BARCOD, 
                    PU.MAIN_UNIT
                 FROM
                    STOCKS S,
                    ORDER_RESERVED_TOTAL ORR,
                    SPECTS_ROW SR,
                    #new_dsn#.STOCKS_LOCATION SL,
                    PRODUCT_UNIT PU
                 WHERE
                    SR.STOCK_ID = S.STOCK_ID AND 
                    ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                    SR.IS_SEVK=1 AND
            
                    ORR.DEPARTMENT_ID =SL.DEPARTMENT_ID AND
                    ORR.LOCATION_ID=SL.LOCATION_ID AND
                    ORR.DEPARTMENT_ID IS NOT NULL AND 
                    SL.NO_SALE = 0  AND		
                    S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                    (ORR.RESERVE_IN-ORR.STOCK_IN)>0
                 GROUP BY
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.STOCK_CODE,
                    S.PROPERTY,
                    S.BARCOD, 
                    PU.MAIN_UNIT	
                ) AS GET_STOCK_RESERVED_ROW
            GROUP BY 
                PRODUCT_ID,
                STOCK_ID,
                STOCK_CODE,
                PROPERTY,
                BARCOD,
                MAIN_UNIT

</cfquery>
    
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_ALL_ORDER_ROW] AS
            SELECT
                ORR.WRK_ROW_RELATION_ID,
                ORR.QUANTITY
            FROM 
                ORDERS O,
                ORDER_ROW ORR
            WHERE 
                O.ORDER_ID = ORR.ORDER_ID
                AND O.ORDER_STAGE IN(71)
            UNION ALL
            SELECT
                OFR.WRK_ROW_RELATION_ID,
                ORR.QUANTITY
            FROM 
                ORDERS O,
                ORDER_ROW ORR,
                OFFER_ROW OFR
            WHERE 
                O.OFFER_ID = OFR.OFFER_ID AND
                ORR.WRK_ROW_RELATION_ID = OFR.WRK_ROW_ID AND
                O.ORDER_STAGE IN(71)
            UNION ALL
            SELECT
                IR.WRK_ROW_RELATION_ID,
                ORR.QUANTITY
            FROM 
                INTERNALDEMAND I,
                INTERNALDEMAND_ROW IR,
                OFFER OO,
                OFFER_ROW OFR,
                ORDERS O,
                ORDER_ROW ORR
            WHERE 
                OO.OFFER_ID = OFR.OFFER_ID AND
                I.INTERNAL_ID = IR.I_ID AND
                O.ORDER_ID = ORR.ORDER_ID AND
                IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
                OFR.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
                O.ORDER_STAGE IN(71)
            UNION ALL
            SELECT
                IR.WRK_ROW_RELATION_ID,
                ORR.QUANTITY
            FROM 
                INTERNALDEMAND I,
                INTERNALDEMAND_ROW IR,
                OFFER OO,
                OFFER_ROW OFR,
                OFFER OO2,
                OFFER_ROW OFR2,
                ORDERS O,
                ORDER_ROW ORR
            WHERE 
                OO.OFFER_ID = OFR.OFFER_ID AND
                OO2.OFFER_ID = OFR2.OFFER_ID AND
                I.INTERNAL_ID = IR.I_ID AND
                O.ORDER_ID = ORR.ORDER_ID AND
                IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
                OFR.WRK_ROW_ID = OFR2.WRK_ROW_RELATION_ID AND
                OFR2.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
                O.ORDER_STAGE IN(71)
            UNION ALL
            SELECT
                OFR.WRK_ROW_RELATION_ID,
                ORR.QUANTITY
            FROM 
                OFFER OO,
                OFFER_ROW OFR,
                OFFER OO2,
                OFFER_ROW OFR2,
                ORDERS O,
                ORDER_ROW ORR
            WHERE 
                OO.OFFER_ID = OFR.OFFER_ID AND
                OO2.OFFER_ID = OFR2.OFFER_ID AND
                O.ORDER_ID = ORR.ORDER_ID AND
                OFR.WRK_ROW_ID = OFR2.WRK_ROW_RELATION_ID AND
                OFR2.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
                O.ORDER_STAGE IN(71)

</cfquery>
    
    
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_ORDER_ROW_RESERVED_ALL] AS
            SELECT STOCK_ID,
               PRODUCT_ID,
               ORDER_ID,
               STOCK_STRATEGY_ID,
               SUM(RESERVE_STOCK_IN)      RESERVE_STOCK_IN,
               SUM(RESERVE_STOCK_OUT)     RESERVE_STOCK_OUT,
               SUM(STOCK_IN)              STOCK_IN,
               SUM(STOCK_OUT)             STOCK_OUT
            FROM   ORDER_ROW_RESERVED
               LEFT JOIN (
                        SELECT ORDER_WRK_ROW_ID,
                               COUNT(ROW_RESERVED_ID) AS SAYAC
                        FROM   ORDER_ROW_RESERVED
                        GROUP BY
                               ORDER_WRK_ROW_ID
                        HAVING COUNT(ROW_RESERVED_ID) > 1
                    )                  AS XXX
                    ON  XXX.ORDER_WRK_ROW_ID = ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID
            WHERE  ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NULL
               OR  (INVOICE_ID IS NULL AND SHIP_ID IS NULL)
               OR  (
                       (INVOICE_ID IS NOT NULL OR SHIP_ID IS NOT NULL)
                       AND ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NOT NULL
                       AND XXX.ORDER_WRK_ROW_ID IS NOT NULL
                   )
            GROUP BY
               STOCK_ID,
               PRODUCT_ID,
               ORDER_ID,
               STOCK_STRATEGY_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_PRODUCTION_RESERVED_LOCATION] AS
                   SELECT
					SUM(STOCK_ARTIR) STOCK_ARTIR,
					SUM(STOCK_AZALT) STOCK_AZALT,
					STOCK_ID,
					PRODUCT_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID
				FROM
					(   
				    SELECT
                        CASE WHEN SUM(STOCK_ARTIR) > 0 THEN SUM(STOCK_ARTIR) ELSE 0 END AS STOCK_ARTIR,
                        CASE WHEN SUM(STOCK_AZALT) > 0 THEN SUM(STOCK_AZALT) ELSE 0 END AS STOCK_AZALT,
                        S.STOCK_ID,
                        S.PRODUCT_ID,
						P_ORDER_ID,
                        DEPARTMENT_ID,
                        LOCATION_ID
                    FROM
                        (
                            SELECT
                                (QUANTITY) AS STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                STOCK_ID,
								P_ORDER_ID,
                                PRODUCTION_DEP_ID as DEPARTMENT_ID,
                                PRODUCTION_LOC_ID AS LOCATION_ID
                            FROM
                                PRODUCTION_ORDERS
                            WHERE
                                IS_STOCK_RESERVED = 1 AND
                                IS_DEMONTAJ=0 AND
                                SPEC_MAIN_ID IS NOT NULL
								AND STATUS=1
                        UNION ALL
                            SELECT
                                0 AS STOCK_ARTIR,
                                (QUANTITY) AS STOCK_AZALT,
                                STOCK_ID,
								P_ORDER_ID,
                                PRODUCTION_DEP_ID as DEPARTMENT_ID, 
                                PRODUCTION_LOC_ID AS LOCATION_ID
                            FROM
                                PRODUCTION_ORDERS
                            WHERE
                                IS_STOCK_RESERVED = 1 AND
                                IS_DEMONTAJ=1 AND
                                SPEC_MAIN_ID IS NOT NULL
								AND STATUS=1
                        UNION ALL
                            SELECT
                                0 AS STOCK_ARTIR,
                                --(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0)) AS STOCK_AZALT,
								 CASE WHEN ISNULL((SELECT
											SUM(POR_.AMOUNT)
										FROM
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID = PO.P_ORDER_ID
											AND POR_.STOCK_ID = POS.STOCK_ID
											AND POO.IS_STOCK_FIS = 1
										),0) > (ISNULL(PO.RESULT_AMOUNT,0))
										 
						THEN
						 (
											(
													SELECT 
														SUM(AMOUNT) AMOUNT
													FROM
														PRODUCTION_ORDERS_STOCKS
													WHERE
													P_ORDER_ID = PO.P_ORDER_ID AND STOCK_ID = POS.STOCK_ID
											)
											/
											(
											
												SELECT 
													QUANTITY 
												FROM 
													PRODUCTION_ORDERS
												WHERE
													P_ORDER_ID = PO.P_ORDER_ID
											)
										
										)*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0))
						 ELSE 									
                         (((POS.AMOUNT*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0)))/(ISNULL(PO.QUANTITY,0)))) END AS STOCK_AZALT,
                                POS.STOCK_ID,
								PO.P_ORDER_ID,
                                PO.EXIT_DEP_ID as DEPARTMENT_ID,
                                PO.EXIT_LOC_ID AS LOCATION_ID
                            FROM
                                PRODUCTION_ORDERS PO,
                                PRODUCTION_ORDERS_STOCKS POS
                            WHERE
                                PO.IS_STOCK_RESERVED = 1 AND
                                POS.P_ORDER_ID = PO.P_ORDER_ID AND
                                PO.IS_DEMONTAJ=0 AND
                                ISNULL(POS.STOCK_ID,0)>0 AND
                                POS.IS_SEVK <> 1 AND
                                ISNULL(IS_FREE_AMOUNT,0) = 0
								AND PO.STATUS=1
                        UNION ALL
                            SELECT
                                POS.AMOUNT AS STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                POS.STOCK_ID,
								PO.P_ORDER_ID,
                                PO.PRODUCTION_DEP_ID as DEPARTMENT_ID,
                                PO.PRODUCTION_LOC_ID AS LOCATION_ID
                            FROM
                                PRODUCTION_ORDERS PO,
                                PRODUCTION_ORDERS_STOCKS POS
                            WHERE
                                PO.IS_STOCK_RESERVED = 1 AND
                                POS.P_ORDER_ID = PO.P_ORDER_ID AND
                                PO.IS_DEMONTAJ=1 AND
                                ISNULL(POS.STOCK_ID,0)>0 AND
                                POS.IS_SEVK <> 1 AND
                                ISNULL(IS_FREE_AMOUNT,0) = 0
								AND PO.STATUS=1
                        UNION ALL
                            SELECT 
                                (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                P_ORD_R_R.STOCK_ID,
								P_ORD_R.P_ORDER_ID,
                                P_ORD_R.PRODUCTION_DEP_ID AS DEPARTMENT_ID,
                                P_ORD_R.PRODUCTION_LOC_ID AS LOCATION_ID
                            FROM
                                PRODUCTION_ORDER_RESULTS P_ORD_R,
                                PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                PRODUCTION_ORDERS P_ORD
                            WHERE
                                P_ORD.IS_STOCK_RESERVED=1 AND
                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                P_ORD_R_R.TYPE=1 AND
                                P_ORD_R.IS_STOCK_FIS=1 AND
                                P_ORD_R_R.IS_SEVKIYAT IS NULL
								AND P_ORD.STATUS=1
						
                    ) T1,
                    #new_prod_db#.STOCKS S
                    WHERE
                        S.STOCK_ID=T1.STOCK_ID
                    GROUP BY 
                        S.STOCK_ID,
                        S.PRODUCT_ID,
						T1.P_ORDER_ID,
                        T1.DEPARTMENT_ID,
                        T1.LOCATION_ID
				)T2
				GROUP BY
					STOCK_ID,
					PRODUCT_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID
</cfquery>
    
    
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_PRODUCTION_RESERVED_SPECT_LOCATION] AS
              SELECT
					SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                    SUM(STOCK_AZALT) AS STOCK_AZALT,
                    STOCK_ID,
                    PRODUCT_ID,
                    SPECT_MAIN_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID
				FROM
					(
				    SELECT
                        CASE WHEN SUM(STOCK_ARTIR) > 0 THEN SUM(STOCK_ARTIR) ELSE 0 END AS STOCK_ARTIR,
                        CASE WHEN SUM(STOCK_AZALT) > 0 THEN SUM(STOCK_AZALT) ELSE 0 END AS STOCK_AZALT,
                        S.STOCK_ID,
                        S.PRODUCT_ID,
                        T1.SPECT_MAIN_ID,
                        T1.DEPARTMENT_ID,
                        T1.LOCATION_ID,
						T1.P_ORDER_ID
                    FROM
                    (
                        SELECT 	
                            (P_ORD.QUANTITY) AS STOCK_ARTIR,
                            0 AS STOCK_AZALT,	
                            P_ORD.STOCK_ID,
                            P_ORD.SPEC_MAIN_ID SPECT_MAIN_ID,
                            P_ORD.PRODUCTION_DEP_ID as DEPARTMENT_ID,
                            P_ORD.PRODUCTION_LOC_ID AS LOCATION_ID,
							P_ORD.P_ORDER_ID
                        FROM
                            PRODUCTION_ORDERS P_ORD
                        WHERE 
                            P_ORD.IS_STOCK_RESERVED = 1 AND 
                            P_ORD.IS_DEMONTAJ=0
							AND P_ORD.STATUS=1
                    UNION ALL
                        SELECT 	
                            0 AS STOCK_ARTIR,
                            (P_ORD.QUANTITY) AS STOCK_AZALT,	
                            P_ORD.STOCK_ID, 
                            P_ORD.SPEC_MAIN_ID SPECT_MAIN_ID,
                            P_ORD.PRODUCTION_DEP_ID as DEPARTMENT_ID,
                            P_ORD.PRODUCTION_LOC_ID AS LOCATION_ID,
							P_ORD.P_ORDER_ID
                        FROM
                            PRODUCTION_ORDERS P_ORD
                        WHERE 
                            P_ORD.IS_STOCK_RESERVED = 1 AND 
                            P_ORD.IS_DEMONTAJ=1
							AND P_ORD.STATUS=1
                    UNION ALL
                        SELECT
                            0 AS STOCK_ARTIR,	
                             CASE WHEN ISNULL((SELECT
											SUM(POR_.AMOUNT)
										FROM
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID = PO.P_ORDER_ID
											AND POR_.STOCK_ID = POS.STOCK_ID
											AND POO.IS_STOCK_FIS = 1
										),0) > (ISNULL(PO.RESULT_AMOUNT,0))
										
						THEN
						 (
											(
													SELECT 
														SUM(AMOUNT) AMOUNT
													FROM
														PRODUCTION_ORDERS_STOCKS
													WHERE
													P_ORDER_ID = PO.P_ORDER_ID AND STOCK_ID = POS.STOCK_ID
											)
											/
											(
											
												SELECT 
													QUANTITY 
												FROM 
													PRODUCTION_ORDERS
												WHERE
													P_ORDER_ID = PO.P_ORDER_ID
											)
										
										)*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0))
						 ELSE 									
                         (POS.AMOUNT - ISNULL((SELECT
											SUM(POR_.AMOUNT)
										FROM
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID = PO.P_ORDER_ID
											AND POR_.STOCK_ID = POS.STOCK_ID
											AND POO.IS_STOCK_FIS = 1
										),0)) END AS STOCK_AZALT,
                            POS.STOCK_ID,
                            POS.SPECT_MAIN_ID,
                            PO.PRODUCTION_DEP_ID as DEPARTMENT_ID,
                            PO.PRODUCTION_LOC_ID AS LOCATION_ID,
							PO.P_ORDER_ID
                        FROM
                            PRODUCTION_ORDERS PO,
                            PRODUCTION_ORDERS_STOCKS POS
                        WHERE
                            PO.IS_STOCK_RESERVED=1 AND
                            PO.P_ORDER_ID = POS.P_ORDER_ID AND
                            PO.IS_DEMONTAJ=0 AND
                            POS.IS_SEVK <> 1 AND
                            ISNULL(IS_FREE_AMOUNT,0) = 0
							AND PO.STATUS=1
                    UNION ALL
                        SELECT
                            POS.AMOUNT AS STOCK_ARTIR,	
                            0 AS STOCK_AZALT,
                            POS.STOCK_ID,
                            POS.SPECT_MAIN_ID,
                            PO.PRODUCTION_DEP_ID as DEPARTMENT_ID,
                            PO.PRODUCTION_LOC_ID AS LOCATION_ID,
							PO.P_ORDER_ID
                        FROM
                            PRODUCTION_ORDERS PO,
                            PRODUCTION_ORDERS_STOCKS POS
                        WHERE
                            PO.IS_STOCK_RESERVED=1 AND
                            PO.P_ORDER_ID = POS.P_ORDER_ID AND
                            PO.IS_DEMONTAJ = 1 AND
                            POS.IS_SEVK <> 1 AND
                            ISNULL(IS_FREE_AMOUNT,0) = 0
							AND PO.STATUS=1
                    UNION ALL
                        SELECT 
                            (P_ORD_R_R.AMOUNT)*-1 AS STOCK_ARTIR,
                            0 AS STOCK_AZALT,
                            P_ORD_R_R.STOCK_ID,
                            SP.SPECT_MAIN_ID,
                            P_ORD_R.PRODUCTION_DEP_ID AS DEPARTMENT_ID,
                            P_ORD_R.PRODUCTION_LOC_ID AS LOCATION_ID,
							P_ORD.P_ORDER_ID
                        FROM
                            PRODUCTION_ORDER_RESULTS P_ORD_R,
                            PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                            PRODUCTION_ORDERS P_ORD,
                            SPECT_MAIN SP
                        WHERE
                            P_ORD.IS_STOCK_RESERVED=1 AND
                            P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                            P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                            SP.SPECT_MAIN_ID=P_ORD_R_R.SPEC_MAIN_ID AND
                            P_ORD_R_R.TYPE=1 AND
                            P_ORD_R.IS_STOCK_FIS=1 AND
                            ISNULL(P_ORD_R_R.IS_SEVKIYAT,0)<>1
							AND P_ORD.STATUS=1
                    UNION ALL
                        SELECT 
                            0 AS STOCK_ARTIR,
                            (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                            P_ORD_R_R.STOCK_ID,
                            SP.SPECT_MAIN_ID,
                            P_ORD_R.EXIT_DEP_ID AS DEPARTMENT_ID,
                            P_ORD_R.EXIT_LOC_ID AS LOCATION_ID,
							P_ORD.P_ORDER_ID
                        FROM
                            PRODUCTION_ORDER_RESULTS P_ORD_R,
                            PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                            PRODUCTION_ORDERS P_ORD,
                            SPECT_MAIN SP
                        WHERE
                            P_ORD.IS_STOCK_RESERVED=1 AND
                            P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                            P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                            SP.SPECT_MAIN_ID=P_ORD_R_R.SPEC_MAIN_ID AND
                            P_ORD_R_R.TYPE IN(2,3) AND
                            P_ORD_R.IS_STOCK_FIS=1 AND
                            ISNULL(P_ORD_R_R.IS_SEVKIYAT,0)<>1
							AND P_ORD.STATUS=1
     
                    ) T1,
                        #new_prod_db#.STOCKS S
                    WHERE
                        S.STOCK_ID=T1.STOCK_ID
                    GROUP BY 
                        S.STOCK_ID,
                        S.PRODUCT_ID,
                        T1.SPECT_MAIN_ID,
                        T1.DEPARTMENT_ID,
                        T1.LOCATION_ID,
						T1.P_ORDER_ID
                    )T2
                GROUP BY
                    STOCK_ID,
                    PRODUCT_ID,
                    SPECT_MAIN_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID 
            

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_PRODUCTION_STOCKS] AS
            SELECT
                SUM(QUANTITY) AS STOK, 
                STOCK_ID
            FROM
                PRODUCTION_ORDERS
            GROUP BY
                STOCK_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [GET_STOCK_BARCODES] AS
            SELECT DISTINCT
                S.PRODUCT_ID,
                SB.STOCK_ID,
                SB.BARCODE,
                SB.UNIT_ID AS UNIT_ID
             FROM
                #new_dsn#_product.STOCKS_BARCODES SB,
                #new_dsn#_product.STOCKS S,
                #new_dsn#_product.PRODUCT P,
                #new_dsn#_product.PRODUCT_OUR_COMPANY POC
             WHERE
                S.STOCK_ID = SB.STOCK_ID AND
                S.PRODUCT_ID = P.PRODUCT_ID AND
                P.PRODUCT_ID = POC.PRODUCT_ID AND
                POC.OUR_COMPANY_ID= #OUR_COMPANY_ID#

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [INTERNALDEMAND_RELATION] AS
            SELECT DISTINCT
                INTERNALDEMAND_ID,
                TO_OFFER_ID,
                TO_ORDER_ID,
                TO_SHIP_ID,
                TO_STOCK_FIS_ID,
                PERIOD_ID
            FROM
                INTERNALDEMAND_RELATION_ROW

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [PRODUCT_BRANDS] AS
            SELECT     
                PB.BRAND_ID,
                PB.BRAND_NAME,
                PB.BRAND_CODE,
                PB.DETAIL,
                PB.IS_ACTIVE,
                PB.IS_INTERNET,
                PB.RECORD_EMP,
                PB.RECORD_DATE,
                PB.RECORD_IP,
                PB.UPDATE_EMP,
                PB.UPDATE_DATE,
                PB.UPDATE_IP
            FROM        
                #new_dsn#_product.PRODUCT_BRANDS PB,
                #new_dsn#_product.PRODUCT_BRANDS_OUR_COMPANY PBO
            WHERE
                PB.BRAND_ID = PBO.BRAND_ID AND
                PBO.OUR_COMPANY_ID = #OUR_COMPANY_ID#

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [PRODUCT_CAT] AS
            SELECT    
                PRODUCT_CAT.PRODUCT_CATID,
                PRODUCT_CAT.HIERARCHY,
                PRODUCT_CAT.PRODUCT_CAT,
                PRODUCT_CAT.DETAIL,
                PRODUCT_CAT.POSITION_CODE,
                PRODUCT_CAT.POSITION_CODE2,
                PRODUCT_CAT.DSP,
                PRODUCT_CAT.IS_PUBLIC,
                PRODUCT_CAT.PROFIT_MARGIN,
                PRODUCT_CAT.PROFIT_MARGIN_MAX,
                PRODUCT_CAT.IS_SUB_PRODUCT_CAT,
                PRODUCT_CAT.IS_CUSTOMIZABLE,
                PRODUCT_CAT.RECORD_DATE,
                PRODUCT_CAT.RECORD_EMP,
                PRODUCT_CAT.RECORD_EMP_IP,
                PRODUCT_CAT.UPDATE_DATE,
                PRODUCT_CAT.UPDATE_EMP,
                PRODUCT_CAT.UPDATE_EMP_IP,
                PRODUCT_CAT.LIST_ORDER_NO,
                PRODUCT_CAT.IMAGE_CAT,
                PRODUCT_CAT.IMAGE_CAT_SERVER_ID,
                PRODUCT_CAT.USER_FRIENDLY_URL,
                PRODUCT_CAT.IS_INSTALLMENT_PAYMENT                            
            FROM         
                 #new_dsn#_product.PRODUCT_CAT,
                 #new_dsn#_product.PRODUCT_CAT_OUR_COMPANY PBO
            WHERE
                PRODUCT_CAT.PRODUCT_CATID = PBO.PRODUCT_CATID AND 
                PBO.OUR_COMPANY_ID = #OUR_COMPANY_ID#

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [PRODUCT_IMAGES] AS
            SELECT     
                #new_dsn#_product.PRODUCT_IMAGES.PRODUCT_ID,
                #new_dsn#_product.PRODUCT_IMAGES.PRODUCT_IMAGEID,
                #new_dsn#_product.PRODUCT_IMAGES.PATH,
                #new_dsn#_product.PRODUCT_IMAGES.DETAIL,
                #new_dsn#_product.PRODUCT_IMAGES.IMAGE_SIZE,
                #new_dsn#_product.PRODUCT_IMAGES.UPDATE_DATE,
                #new_dsn#_product.PRODUCT_IMAGES.UPDATE_EMP,
                #new_dsn#_product.PRODUCT_IMAGES.UPDATE_IP,
                #new_dsn#_product.PRODUCT_IMAGES.PROPERTY_ID,
                #new_dsn#_product.PRODUCT_IMAGES.UPDATE_PAR,
                #new_dsn#_product.PRODUCT_IMAGES.IS_INTERNET,
                #new_dsn#_product.PRODUCT_IMAGES.PATH_SERVER_ID,
                #new_dsn#_product.PRODUCT_IMAGES.STOCK_ID,
                #new_dsn#_product.PRODUCT_IMAGES.IS_EXTERNAL_LINK
            FROM   
                 #new_dsn#_product.PRODUCT,
                 #new_dsn#_product.PRODUCT_IMAGES,
                 #new_dsn#_product.PRODUCT_OUR_COMPANY
            WHERE     
                 (#new_dsn#_product.PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = #OUR_COMPANY_ID#) AND
                 #new_dsn#_product.PRODUCT.PRODUCT_ID = #new_dsn#_product.PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                 #new_dsn#_product.PRODUCT_IMAGES.PRODUCT_ID = #new_dsn#_product.PRODUCT.PRODUCT_ID

</cfquery>
    <cfquery name="create_company_db_views" datasource="#new_dsn3#">
        CREATE VIEW [STOCKS_PROPERTY] AS
            SELECT     
                #new_dsn#_product. STOCKS_PROPERTY.STOCK_ID,
                #new_dsn#_product.STOCKS_PROPERTY.PROPERTY_ID,
                #new_dsn#_product.STOCKS_PROPERTY.PROPERTY_DETAIL_ID,
                #new_dsn#_product.STOCKS_PROPERTY.PROPERTY_DETAIL,
                #new_dsn#_product.STOCKS_PROPERTY.TOTAL_MIN,
                #new_dsn#_product.STOCKS_PROPERTY.TOTAL_MAX,
                #new_dsn#_product.STOCKS_PROPERTY.OLD_PROPERTY_ID
            FROM   
                #new_dsn#_product.PRODUCT,
                #new_dsn#_product.STOCKS_PROPERTY,
                #new_dsn#_product.STOCKS,
                #new_dsn#_product.PRODUCT_OUR_COMPANY
            WHERE     
                (#new_dsn#_product.PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = #OUR_COMPANY_ID#) AND
                #new_dsn#_product.PRODUCT.PRODUCT_ID = #new_dsn#_product.PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                #new_dsn#_product.STOCKS.PRODUCT_ID = #new_dsn#_product.PRODUCT.PRODUCT_ID AND
                #new_dsn#_product.STOCKS_PROPERTY.STOCK_ID = #new_dsn#_product.STOCKS.STOCK_ID
</cfquery>


    
    <cfquery name="add_sp" datasource="#new_dsn3#">
    CREATE PROCEDURE [add_price]
					@product_id int,
					@product_unit_id int,
					@price_cat int,
					@start_date datetime,
					@price float,
					@price_money nvarchar(10),
					@is_kdv float,
					@price_with_kdv float,
					@catalog_id int,
					@user_id int,
					@remote_addr nvarchar(40),
					@price_discount float,
					@stock_id int,
					@spect_var_id int
				AS
				
					DELETE FROM 
						PRICE 
					WHERE 
						PRICE_CATID = @price_cat AND 
						STARTDATE= @start_date AND 
						PRODUCT_ID= @product_id AND		
						UNIT= @product_unit_id AND
						ISNULL(STOCK_ID,0)=@stock_id AND
						ISNULL(SPECT_VAR_ID,0)=@spect_var_id
					
					DELETE FROM 
						PRICE_HISTORY 
					WHERE 
						PRICE_CATID = @price_cat AND 
						STARTDATE= @start_date AND 
						PRODUCT_ID= @product_id AND 
						UNIT= @product_unit_id AND 
						ISNULL(STOCK_ID,0)=@stock_id AND
						ISNULL(SPECT_VAR_ID,0)=@spect_var_id
				
				DELETE FROM 
					PRICE 
				WHERE 
					FINISHDATE < DATEADD(d,-1,GETDATE())
				
				UPDATE 
					PRICE 
				SET 
					FINISHDATE = DATEADD(s,-1,@start_date)
				WHERE 
					PRODUCT_ID = @product_id AND 
					UNIT = @product_unit_id AND 
					PRICE_CATID = @price_cat AND 
					STARTDATE < @start_date AND 
					(FINISHDATE IS NULL OR FINISHDATE > @start_date) AND
					ISNULL(STOCK_ID,0)=@stock_id AND
					ISNULL(SPECT_VAR_ID,0)=@spect_var_id
				
				UPDATE 
					PRICE_HISTORY 
				SET 
					FINISHDATE = DATEADD(s,-1,@start_date)
				WHERE 
					PRODUCT_ID = @product_id AND 
					UNIT = @product_unit_id AND 
					PRICE_CATID = @price_cat AND 
					STARTDATE < @start_date AND 
					(FINISHDATE IS NULL OR FINISHDATE > @start_date) AND
					ISNULL(STOCK_ID,0)=@stock_id AND
					ISNULL(SPECT_VAR_ID,0)=@spect_var_id
			
				
				DECLARE @ST_DATE datetime
				SELECT @ST_DATE = 	(SELECT 
								TOP 1 STARTDATE 
							FROM 
								PRICE 
							WHERE 
								PRODUCT_ID = @product_id AND 
								UNIT = @product_unit_id AND 
								PRICE_CATID = @price_cat AND 
								STARTDATE > @start_date AND
								ISNULL(STOCK_ID,0)=@stock_id AND
								ISNULL(SPECT_VAR_ID,0)=@spect_var_id
							ORDER BY 
								STARTDATE)
				
				DECLARE @FINISHDATE datetime
				if ( @ST_DATE IS NOT NULL)
					SELECT @FINISHDATE  = DATEADD(s,-1,@ST_DATE)
				
				DECLARE @CATALOGID int
				if ( @catalog_id > 0 )
					SELECT @CATALOGID = @catalog_id
				
				DECLARE @STOCK_ID_ int
				if ( @stock_id > 0 )
					SELECT @STOCK_ID_ = @stock_id
				
				DECLARE @SPECT_VAR_ID_ int
				if ( @spect_var_id > 0 )
					SELECT @SPECT_VAR_ID_ = @spect_var_id
					
				INSERT INTO	
					PRICE
					(
						PRICE_CATID,
						PRODUCT_ID,
						STOCK_ID,
						SPECT_VAR_ID,
						STARTDATE,
						FINISHDATE,
						PRICE,
						IS_KDV,
						PRICE_KDV,
						PRICE_DISCOUNT,
						MONEY,
						UNIT,
						CATALOG_ID,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
				VALUES
					(
						@price_cat,
						@product_id,
						@STOCK_ID_,
						@SPECT_VAR_ID_,
						@start_date,
						@FINISHDATE,
						@price,
						@is_kdv,
						@price_with_kdv,
						@price_discount,
						@price_money,
						@product_unit_id,
						@CATALOGID,
						getdate(),
						@user_id,
						@remote_addr
					)
				
				INSERT INTO	
					PRICE_HISTORY
					(
						PRICE_CATID,
						PRODUCT_ID,
						STOCK_ID,
						SPECT_VAR_ID,
						STARTDATE,
						FINISHDATE,
						PRICE,
						IS_KDV,
						PRICE_KDV,
						PRICE_DISCOUNT,
						MONEY,
						UNIT,
						CATALOG_ID,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
				VALUES
					(
						@price_cat,
						@product_id,
						@STOCK_ID_,
						@SPECT_VAR_ID_,
						@start_date,
						@FINISHDATE,
						@price,
						@is_kdv,
						@price_with_kdv,
						@price_discount,
						@price_money,
						@product_unit_id,
						@CATALOGID,
						getdate(),
						@user_id,
						@remote_addr
					)

</cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">
        CREATE PROCEDURE [ADD_PRODUCTION_OPERATION] 
            @P_ORDER_ID int,
            @STATION_ID int,
            @O_MINUTE float,
            @OPERATION_TYPE_ID int,
            @AMOUNT float,
            @RECORD_EMP int,
            @RECORD_DATE datetime,
            @RECORD_IP nvarchar(50),
            @STAGE int
            AS
        BEGIN
            SET NOCOUNT ON;
            INSERT INTO 
                PRODUCTION_OPERATION
                (
                    P_ORDER_ID,
                    STATION_ID,
                    O_MINUTE,
                    OPERATION_TYPE_ID,
                    AMOUNT,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP,
                    STAGE
                )
                VALUES
                (
                    @P_ORDER_ID,
                    @STATION_ID,
                    @O_MINUTE,
                    @OPERATION_TYPE_ID,
                    @AMOUNT,
                    @RECORD_EMP,
                    @RECORD_DATE,
                    @RECORD_IP,
                    @STAGE
                )
        END
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">
        CREATE PROCEDURE [ADD_PRODUCTION_ORDER]
            @PO_RELATED_ID int,
            @STOCK_ID int,
            @QUANTITY float,
            @START_DATE datetime,
            @FINISH_DATE datetime,
            @RECORD_EMP int,
            @RECORD_DATE datetime,
            @RECORD_IP nvarchar(50),
            @STATUS int,
            @PROJECT_ID int,
            @P_ORDER_NO nvarchar(50),
            @DETAIL nvarchar(2000),
            @PROD_ORDER_STAGE int,
            @STATION_ID int,
            @SPECT_VAR_ID int,
            @SPECT_VAR_NAME nvarchar(500),
            @IS_STOCK_RESERVED bit,
            @IS_DEMONTAJ bit,
            @LOT_NO nvarchar(100),
            @PRODUCTION_LEVEL nvarchar(50),
            @SPEC_MAIN_ID int,
            @IS_STAGE int,
            @WRK_ROW_ID nvarchar(40),
            @DEMAND_NO nvarchar(50),
            @EXIT_DEP_ID int,
            @EXIT_LOC_ID int,
            @PRODUCTION_DEP_ID int,
            @PRODUCTION_LOC_ID int,
            @WORK_ID int ,
            @WRK_ROW_RELATION_ID nvarchar(50)	
            
            AS
            BEGIN
                SET NOCOUNT ON;
                                INSERT INTO 
                                        PRODUCTION_ORDERS
                                    (
                                        PO_RELATED_ID,
                                        STOCK_ID,
                                        QUANTITY,
                                        START_DATE,
                                        FINISH_DATE,
                                        RECORD_EMP,
                                        RECORD_DATE,
                                        RECORD_IP,
                                        STATUS,
                                        PROJECT_ID,
                                        P_ORDER_NO,
                                        DETAIL,
                                        PROD_ORDER_STAGE,
                                        STATION_ID,
                                        SPECT_VAR_ID,
                                        SPECT_VAR_NAME,
                                        IS_STOCK_RESERVED,
                                        IS_DEMONTAJ,
                                        LOT_NO,
                                        PRODUCTION_LEVEL,
                                        SPEC_MAIN_ID,
                                        IS_STAGE,
                                        WRK_ROW_ID,
                                        DEMAND_NO,
                                        EXIT_DEP_ID,
                                        EXIT_LOC_ID,
                                        PRODUCTION_DEP_ID,
                                        PRODUCTION_LOC_ID,
                                        WORK_ID,
                                        WRK_ROW_RELATION_ID
                                    )
                                    VALUES
                                    ( 
                                        @PO_RELATED_ID,
                                        @STOCK_ID,
                                        @QUANTITY,
                                        @START_DATE,
                                        @FINISH_DATE,
                                        @RECORD_EMP,
                                        @RECORD_DATE,
                                        @RECORD_IP,
                                        @STATUS,
                                        @PROJECT_ID,
                                        @P_ORDER_NO,
                                        @DETAIL,
                                        @PROD_ORDER_STAGE,
                                        @STATION_ID,
                                        @SPECT_VAR_ID,
                                        @SPECT_VAR_NAME,
                                        @IS_STOCK_RESERVED,
                                        @IS_DEMONTAJ,
                                        @LOT_NO,
                                        @PRODUCTION_LEVEL,
                                        @SPEC_MAIN_ID,
                                        @IS_STAGE,
                                        @WRK_ROW_ID,
                                        @DEMAND_NO,
                                        @EXIT_DEP_ID,
                                        @EXIT_LOC_ID,
                                        @PRODUCTION_DEP_ID,
                                        @PRODUCTION_LOC_ID,
                                        @WORK_ID,
                                        @WRK_ROW_RELATION_ID	
                                    )
            END
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">  
        CREATE PROCEDURE [ADD_PRODUCTION_ORDER_CASH] 
            @startdate datetime,
            @finishdate datetime,
            @station_id int
        AS
        BEGIN
            -- SET NOCOUNT ON added to prevent extra result sets from
            -- interfering with SELECT statements.
            SET NOCOUNT ON;
        
           INSERT INTO
                PRODUCTION_ORDERS_CASH
                (
                    START_DATE,
                    FINISH_DATE,
                    STATION_ID
                )
            VALUES
                (
                    @startdate,
                    @finishdate,
                    @station_id
                )
        END
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">  
        CREATE PROCEDURE [ADD_PRODUCTION_ORDER_RESULT]
            @P_ORDER_ID int,
            @PROCESS_ID int,
            @START_DATE datetime ,
            @FINISH_DATE datetime,
            @EXIT_DEP_ID int,
            @EXIT_LOC_ID int,
            @STATION_ID int,
            @PRODUCTION_ORDER_NO nvarchar(43),
            @RESULT_NO nvarchar(43),
            @ENTER_DEP_ID int,
            @ENTER_LOC_ID int,
            @ORDER_NO nvarchar(250),
            @REFERENCE_NO nvarchar(500),
            @POSITION_ID int ,
            @RECORD_EMP int,
            @RECORD_DATE datetime,
            @RECORD_IP nvarchar(50),
            @LOT_NO nvarchar(100),
            @PRODUCTION_DEP_ID int,
            @PRODUCTION_LOC_ID int,
            @PROD_ORD_RESULT_STAGE int,
            @IS_STOCK_FIS bit,
            @WRK_ROW_ID nvarchar(40),
            @EXPIRATION_DATE datetime
        AS
        BEGIN
            SET NOCOUNT ON;
                INSERT INTO 
                    PRODUCTION_ORDER_RESULTS 
                ( 
                    P_ORDER_ID,
                    PROCESS_ID,
                    START_DATE,
                    FINISH_DATE,
                    EXIT_DEP_ID,
                    EXIT_LOC_ID,
                    STATION_ID,
                    PRODUCTION_ORDER_NO,
                    RESULT_NO,
                    ENTER_DEP_ID,
                    ENTER_LOC_ID,
                    ORDER_NO,
                    REFERENCE_NO,
                    POSITION_ID ,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP,
                    LOT_NO,
                    PRODUCTION_DEP_ID,
                    PRODUCTION_LOC_ID,
                    PROD_ORD_RESULT_STAGE,
                    IS_STOCK_FIS,
                    WRK_ROW_ID,
                    EXPIRATION_DATE
                )
                VALUES
                (
                    @P_ORDER_ID,
                    @PROCESS_ID,
                    @START_DATE,
                    @FINISH_DATE,
                    @EXIT_DEP_ID,
                    @EXIT_LOC_ID,
                    @STATION_ID,
                    @PRODUCTION_ORDER_NO,
                    @RESULT_NO,
                    @ENTER_DEP_ID,
                    @ENTER_LOC_ID,
                    @ORDER_NO,
                    @REFERENCE_NO,
                    @POSITION_ID ,
                    @RECORD_EMP,
                    @RECORD_DATE,
                    @RECORD_IP,
                    @LOT_NO,
                    @PRODUCTION_DEP_ID,
                    @PRODUCTION_LOC_ID,
                    @PROD_ORD_RESULT_STAGE,
                    @IS_STOCK_FIS,
                    @WRK_ROW_ID,
                    @EXPIRATION_DATE
                )
                
        END
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">  
        CREATE PROCEDURE [ADD_PRODUCTION_ORDER_RESULTS_ROW]
            @TREE_TYPE NVARCHAR(43),
            @TYPE int,
            @PR_ORDER_ID int,
            @BARCODE nvarchar(43),
            @STOCK_ID int,
            @PRODUCT_ID int,
            @AMOUNT float,
            @AMOUNT2 float,
            @UNIT_ID int,
            @UNIT2 nvarchar(50),
            @NAME_PRODUCT nvarchar(500),
            @UNIT_NAME nvarchar(65),
            @SPECT_ID int,
            @SPEC_MAIN_ID int,
            @SPECT_NAME nvarchar(500),
            @COST_ID int,
            @KDV_PRICE float,
            @PURCHASE_NET_SYSTEM float,
            @PURCHASE_NET_SYSTEM_MONEY nvarchar(43),
            @PURCHASE_EXTRA_COST_SYSTEM float,
            @PURCHASE_NET_SYSTEM_TOTAL float,
            @PURCHASE_NET float,
            @PURCHASE_NET_MONEY nvarchar(43),
            @PURCHASE_NET_2 float,
            @PURCHASE_EXTRA_COST_SYSTEM_2 float,
            @PURCHASE_NET_MONEY_2 nvarchar(43),
            @PURCHASE_EXTRA_COST float,
            @PURCHASE_NET_TOTAL float,
            @PRODUCT_NAME2 nvarchar(500),
            @FIRE_AMOUNT float,
            @IS_FREE_AMOUNT bit,
            @WRK_ROW_ID nvarchar(50),
            @WRK_ROW_RELATION_ID nvarchar(50)
        AS
        BEGIN
            SET NOCOUNT ON;
        
           INSERT INTO
                PRODUCTION_ORDER_RESULTS_ROW
                (
                    TREE_TYPE,
                    TYPE,
                    PR_ORDER_ID,
                    BARCODE,
                    STOCK_ID,
                    PRODUCT_ID,
                    AMOUNT,
                    AMOUNT2,
                    UNIT_ID,
                    UNIT2,
                    NAME_PRODUCT,
                    UNIT_NAME,
                    SPECT_ID,
                    SPEC_MAIN_ID,
                    SPECT_NAME,
                    COST_ID,
                    KDV_PRICE,
                    PURCHASE_NET_SYSTEM,
                    PURCHASE_NET_SYSTEM_MONEY,
                    PURCHASE_EXTRA_COST_SYSTEM,
                    PURCHASE_NET_SYSTEM_TOTAL,
                    PURCHASE_NET,
                    PURCHASE_NET_MONEY,
                    PURCHASE_NET_2,
                    PURCHASE_EXTRA_COST_SYSTEM_2,
                    PURCHASE_NET_MONEY_2,
                    PURCHASE_EXTRA_COST,
                    PURCHASE_NET_TOTAL,
                    PRODUCT_NAME2,
                    FIRE_AMOUNT,
                    IS_FREE_AMOUNT,
                    WRK_ROW_ID,
                    WRK_ROW_RELATION_ID
                )
                VALUES
                (
                    @TREE_TYPE,
                    @TYPE,
                    @PR_ORDER_ID,
                    @BARCODE,
                    @STOCK_ID,
                    @PRODUCT_ID,
                    @AMOUNT,
                    @AMOUNT2,
                    @UNIT_ID,
                    @UNIT2,
                    @NAME_PRODUCT,
                    @UNIT_NAME,
                    @SPECT_ID,
                    @SPEC_MAIN_ID,
                    @SPECT_NAME,
                    @COST_ID,
                    @KDV_PRICE,
                    @PURCHASE_NET_SYSTEM,
                    @PURCHASE_NET_SYSTEM_MONEY,
                    @PURCHASE_EXTRA_COST_SYSTEM,
                    @PURCHASE_NET_SYSTEM_TOTAL,
                    @PURCHASE_NET,
                    @PURCHASE_NET_MONEY,
                    @PURCHASE_NET_2,
                    @PURCHASE_EXTRA_COST_SYSTEM_2,
                    @PURCHASE_NET_MONEY_2,
                    @PURCHASE_EXTRA_COST,
                    @PURCHASE_NET_TOTAL,
                    @PRODUCT_NAME2,
                    @FIRE_AMOUNT,
                    @IS_FREE_AMOUNT,
                    @WRK_ROW_ID,
                    @WRK_ROW_RELATION_ID
                
                )
        END
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">  
        CREATE PROCEDURE [ADD_PRODUCTION_ORDER_RESULTS_ROW_O]
            @TYPE int,
            @PR_ORDER_ID int,
            @BARCODE nvarchar(43),
            @STOCK_ID int,
            @PRODUCT_ID int,
            @LOT_NO nvarchar(100),
            @AMOUNT float,
            @AMOUNT2 float,
            @UNIT_ID int,
            @UNIT2 nvarchar(50),
            @SERIAL_NO nvarchar(50),
            @NAME_PRODUCT nvarchar(500),
            @UNIT_NAME nvarchar(65),
            @IS_SEVKIYAT bit,
            @SPECT_ID int,
            @SPEC_MAIN_ID int,
            @SPECT_NAME nvarchar(500) ,
            @COST_ID int,
            @KDV_PRICE float,
            @PURCHASE_NET_SYSTEM float,
            @PURCHASE_NET_SYSTEM_MONEY nvarchar(43),
            @PURCHASE_EXTRA_COST_SYSTEM float,
            @PURCHASE_NET_SYSTEM_TOTAL float,
            @PURCHASE_NET float,
            @PURCHASE_NET_MONEY nvarchar(43),
            @PURCHASE_NET_2 float,
            @PURCHASE_EXTRA_COST_SYSTEM_2 float,
            @PURCHASE_NET_MONEY_2 nvarchar(43),
            @PURCHASE_EXTRA_COST float,
            @PURCHASE_NET_TOTAL float,
            @PRODUCT_NAME2 nvarchar(500),
            @WRK_ROW_ID nvarchar(50),
            @WRK_ROW_RELATION_ID nvarchar(50),
            @LINE_NUMBER int,
            @IS_MANUAL_COST bit,
            @EXPIRATION_DATE datetime
        AS
            BEGIN
                SET NOCOUNT ON;
                    INSERT INTO
                            PRODUCTION_ORDER_RESULTS_ROW
                            (
                                TYPE,
                                PR_ORDER_ID,
                                BARCODE,
                                STOCK_ID,
                                PRODUCT_ID,
                                LOT_NO,
                                AMOUNT,
                                AMOUNT2,
                                UNIT_ID,
                                UNIT2,
                                SERIAL_NO,
                                NAME_PRODUCT,
                                UNIT_NAME,
                                IS_SEVKIYAT,
                                SPECT_ID,
                                SPEC_MAIN_ID,
                                SPECT_NAME,
                                COST_ID,
                                KDV_PRICE,
                                PURCHASE_NET_SYSTEM,
                                PURCHASE_NET_SYSTEM_MONEY,
                                PURCHASE_EXTRA_COST_SYSTEM,
                                PURCHASE_NET_SYSTEM_TOTAL,
                                PURCHASE_NET,
                                PURCHASE_NET_MONEY,
                                PURCHASE_NET_2,
                                PURCHASE_EXTRA_COST_SYSTEM_2,
                                PURCHASE_NET_MONEY_2,
                                PURCHASE_EXTRA_COST,
                                PURCHASE_NET_TOTAL,
                                PRODUCT_NAME2,
                                WRK_ROW_ID,
                                WRK_ROW_RELATION_ID,
                                LINE_NUMBER,
                                IS_MANUAL_COST,
                                EXPIRATION_DATE
                            )
                            VALUES
                            (
                                @TYPE,
                                @PR_ORDER_ID,
                                @BARCODE,
                                @STOCK_ID,
                                @PRODUCT_ID,
                                @LOT_NO,
                                @AMOUNT,
                                @AMOUNT2,
                                @UNIT_ID,
                                @UNIT2,
                                @SERIAL_NO,
                                @NAME_PRODUCT,
                                @UNIT_NAME,
                                @IS_SEVKIYAT,
                                @SPECT_ID,
                                @SPEC_MAIN_ID,
                                @SPECT_NAME,
                                @COST_ID,
                                @KDV_PRICE,
                                @PURCHASE_NET_SYSTEM,
                                @PURCHASE_NET_SYSTEM_MONEY,
                                @PURCHASE_EXTRA_COST_SYSTEM,
                                @PURCHASE_NET_SYSTEM_TOTAL,
                                @PURCHASE_NET,
                                @PURCHASE_NET_MONEY,
                                @PURCHASE_NET_2,
                                @PURCHASE_EXTRA_COST_SYSTEM_2,
                                @PURCHASE_NET_MONEY_2,
                                @PURCHASE_EXTRA_COST,
                                @PURCHASE_NET_TOTAL,
                                @PRODUCT_NAME2,
                                @WRK_ROW_ID,
                                @WRK_ROW_RELATION_ID,
                                @LINE_NUMBER,
                                @IS_MANUAL_COST,
                                @EXPIRATION_DATE
                            )
    	END
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">  
        CREATE PROCEDURE [ADD_PRODUCTION_ORDER_RESULTS_ROW_S] 
            @TREE_TYPE nvarchar(43),
            @TYPE int,
            @PR_ORDER_ID int,
            @BARCODE nvarchar(43),
            @STOCK_ID int,
            @PRODUCT_ID int,
            @LOT_NO nvarchar(100) ,
            @AMOUNT float,
            @AMOUNT2 float,
            @UNIT_ID int ,
            @UNIT2 nvarchar(50),
            @SERIAL_NO nvarchar(50),
            @NAME_PRODUCT nvarchar(500),
            @UNIT_NAME nvarchar(65),
            @IS_SEVKIYAT bit,
            @SPECT_ID int,
            @SPEC_MAIN_ID int,
            @SPECT_NAME nvarchar(500),								
            @COST_ID int,
            @KDV_PRICE float,
            @PURCHASE_NET_SYSTEM float,
            @PURCHASE_NET_SYSTEM_MONEY nvarchar(43),
            @PURCHASE_EXTRA_COST_SYSTEM float,
            @PURCHASE_NET_SYSTEM_TOTAL float,
            @PURCHASE_NET float,
            @PURCHASE_NET_MONEY nvarchar(43),
            @PURCHASE_NET_2 float,
            @PURCHASE_EXTRA_COST_SYSTEM_2 float,
            @PURCHASE_NET_MONEY_2 nvarchar(43),
            @PURCHASE_EXTRA_COST float ,
            @PURCHASE_NET_TOTAL float,
            @PRODUCT_NAME2 nvarchar(500),
            @IS_FROM_SPECT bit ,
            @IS_FREE_AMOUNT bit,
            @WRK_ROW_ID nvarchar(50),
            @WRK_ROW_RELATION_ID nvarchar(50),
            @LINE_NUMBER int,
            @IS_MANUAL_COST bit,
            @EXPIRATION_DATE datetime
        AS
        BEGIN
            SET NOCOUNT ON;
            INSERT INTO
                PRODUCTION_ORDER_RESULTS_ROW
            (
                TREE_TYPE,
                TYPE,
                PR_ORDER_ID,
                BARCODE,
                STOCK_ID,
                PRODUCT_ID,
                LOT_NO,
                AMOUNT,
                AMOUNT2,
                UNIT_ID,
                UNIT2,
                SERIAL_NO,
                NAME_PRODUCT,
                UNIT_NAME,
                IS_SEVKIYAT,
                SPECT_ID,
                SPEC_MAIN_ID,
                SPECT_NAME,								
                COST_ID,
                KDV_PRICE,
                PURCHASE_NET_SYSTEM,
                PURCHASE_NET_SYSTEM_MONEY,
                PURCHASE_EXTRA_COST_SYSTEM,
                PURCHASE_NET_SYSTEM_TOTAL,
                PURCHASE_NET,
                PURCHASE_NET_MONEY,
                PURCHASE_NET_2,
                PURCHASE_EXTRA_COST_SYSTEM_2,
                PURCHASE_NET_MONEY_2,
                PURCHASE_EXTRA_COST,
                PURCHASE_NET_TOTAL,
                PRODUCT_NAME2,
                IS_FROM_SPECT,
                IS_FREE_AMOUNT,
                WRK_ROW_ID,
                WRK_ROW_RELATION_ID,
                LINE_NUMBER,
                IS_MANUAL_COST,
                EXPIRATION_DATE
            )
            VALUES
            (
                @TREE_TYPE,
                @TYPE,
                @PR_ORDER_ID,
                @BARCODE,
                @STOCK_ID,
                @PRODUCT_ID,
                @LOT_NO,
                @AMOUNT,
                @AMOUNT2,
                @UNIT_ID,
                @UNIT2,
                @SERIAL_NO,
                @NAME_PRODUCT,
                @UNIT_NAME,
                @IS_SEVKIYAT,
                @SPECT_ID,
                @SPEC_MAIN_ID,
                @SPECT_NAME,								
                @COST_ID,
                @KDV_PRICE,
                @PURCHASE_NET_SYSTEM,
                @PURCHASE_NET_SYSTEM_MONEY,
                @PURCHASE_EXTRA_COST_SYSTEM,
                @PURCHASE_NET_SYSTEM_TOTAL,
                @PURCHASE_NET,
                @PURCHASE_NET_MONEY,
                @PURCHASE_NET_2,
                @PURCHASE_EXTRA_COST_SYSTEM_2,
                @PURCHASE_NET_MONEY_2,
                @PURCHASE_EXTRA_COST,
                @PURCHASE_NET_TOTAL,
                @PRODUCT_NAME2,
                @IS_FROM_SPECT,
                @IS_FREE_AMOUNT,
                @WRK_ROW_ID,
                @WRK_ROW_RELATION_ID,
                @LINE_NUMBER,
                @IS_MANUAL_COST,
                @EXPIRATION_DATE
            )	
        END
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">  
        CREATE PROCEDURE [ADD_PRODUCTION_ORDERS_ROW] 
            @PRODUCTION_ORDER_ID int,
            @ORDER_ID int,
            @ORDER_ROW_ID int,
            @TYPE int
        AS
        BEGIN
            SET NOCOUNT ON;
           INSERT INTO
                PRODUCTION_ORDERS_ROW
            (
                PRODUCTION_ORDER_ID ,
                ORDER_ID ,
                ORDER_ROW_ID ,
                TYPE 
            )
            VALUES
            (
                @PRODUCTION_ORDER_ID,
                @ORDER_ID,
                @ORDER_ROW_ID,
                @TYPE
            )
            END
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">  
        CREATE PROCEDURE  [ADD_PRODUCTION_ORDERS_STOCKS]
            @P_ORDER_ID int ,
            @PRODUCT_ID int ,
            @STOCK_ID int ,
            @SPECT_MAIN_ID int,
            @AMOUNT float,
            @TYPE int,
            @PRODUCT_UNIT_ID int,
            @RECORD_EMP int ,
            @RECORD_DATE datetime,
            @RECORD_IP nvarchar(50),
            @IS_PHANTOM bit,
            @IS_SEVK bit,
            @IS_PROPERTY int,
            @IS_FREE_AMOUNT bit,
            @FIRE_AMOUNT float,
            @FIRE_RATE float,
            @SPECT_MAIN_ROW_ID int,
            @IS_FLAG bit,
            @WRK_ROW_ID nvarchar(40),
            @LINE_NUMBER int
        AS
        BEGIN
            -- SET NOCOUNT ON added to prevent extra result sets from
            -- interfering with SELECT statements.
            SET NOCOUNT ON;
        
            INSERT INTO
                    PRODUCTION_ORDERS_STOCKS
                (
                    P_ORDER_ID,
                    PRODUCT_ID,
                    STOCK_ID,
                    SPECT_MAIN_ID,
                    AMOUNT,
                    TYPE,
                    PRODUCT_UNIT_ID,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP,
                    IS_PHANTOM,
                    IS_SEVK,
                    IS_PROPERTY,
                    IS_FREE_AMOUNT,
                    FIRE_AMOUNT,
                    FIRE_RATE,
                    SPECT_MAIN_ROW_ID,
                    IS_FLAG,
                    WRK_ROW_ID,
                    LINE_NUMBER
                )
                VALUES
                (
                    @P_ORDER_ID,
                    @PRODUCT_ID,
                    @STOCK_ID,
                    @SPECT_MAIN_ID,
                    @AMOUNT,
                    @TYPE,
                    @PRODUCT_UNIT_ID,
                    @RECORD_EMP,
                    @RECORD_DATE,
                    @RECORD_IP,
                    @IS_PHANTOM,
                    @IS_SEVK,
                    @IS_PROPERTY,
                    @IS_FREE_AMOUNT,
                    @FIRE_AMOUNT,
                    @FIRE_RATE,
                    @SPECT_MAIN_ROW_ID,
                    @IS_FLAG,
                    @WRK_ROW_ID,
                    @LINE_NUMBER
                )
        END
    </cfquery>
            
    <cfquery name="add_sp" datasource="#new_dsn3#"> 
        CREATE PROCEDURE [DEL_ORDER_ROW_RESERVED]
            @cftoken nvarchar(1000)
        AS
        BEGIN
            SET NOCOUNT ON;
            DELETE FROM ORDER_ROW_RESERVED WHERE PRE_ORDER_ID = @cftoken
        END
    </cfquery>
    
    <cfquery name="add_sp" datasource="#new_dsn3#"> 
        CREATE PROCEDURE [GET_PRODUCTION_ORDER_MAX]
            @wrk_id_new nvarchar(40)
        AS
        BEGIN
            SET NOCOUNT ON;
                SELECT
                    P_ORDER_ID PID,
                    IS_DEMONTAJ,
                    QUANTITY AMOUNT
                FROM
                    PRODUCTION_ORDERS
                WHERE
                    WRK_ROW_ID = @wrk_id_new
        END
    </cfquery>
            
    <cfquery name="add_sp" datasource="#new_dsn3#"> 
        CREATE PROCEDURE  [GET_PRODUCTION_ORDER_RESULT_MAX_ID]
        AS
        BEGIN
            SET NOCOUNT ON;
                SELECT MAX(PR_ORDER_ID) AS MAX_ID FROM PRODUCTION_ORDER_RESULTS
        END
    </cfquery>
            
    <cfquery name="add_sp" datasource="#new_dsn3#"> 
        CREATE PROCEDURE [GET_SUB_PRODUCT_FIRE] 
             @spect_main_id___ int
        AS
        BEGIN
            -- SET NOCOUNT ON added to prevent extra result sets from
            -- interfering with SELECT statements.
            SET NOCOUNT ON;
        
                    SELECT
                        SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
                        CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) <> 0)
                        THEN
                            SPECT_MAIN_ROW.FIRE_AMOUNT
                        ELSE
                            CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) <> 0)
                            THEN
                            SPECT_MAIN_ROW.AMOUNT*SPECT_MAIN_ROW.FIRE_RATE/100
                            ELSE
                            SPECT_MAIN_ROW.AMOUNT
                            END
                        END AS AMOUNT ,
                        ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
                        STOCKS.PRODUCT_ID,
                        STOCKS.STOCK_ID,
                        PRODUCT_UNIT.PRODUCT_UNIT_ID,
                        SPECT_MAIN_ROW.IS_SEVK,
                        SPECT_MAIN_ROW.IS_PROPERTY,
                        ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
                        ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
                        SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
                        SPECT_MAIN_ROW.LINE_NUMBER
                    FROM
                        SPECT_MAIN,
                        SPECT_MAIN_ROW,
                        STOCKS,
                        PRODUCT_UNIT,
                        PRICE_STANDART
                    WHERE
                        PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                        PRICE_STANDART.PURCHASESALES = 1 AND
                        PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                        STOCKS.STOCK_STATUS = 1	AND
                        ISNULL(IS_PHANTOM,0) = 0 AND
                        SPECT_MAIN.SPECT_MAIN_ID = @spect_main_id___ AND
                        SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
                        SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                        (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0)<>0 OR ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0)<>0)  AND
                        PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
                        STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
        END

    </cfquery>
            
    <cfquery name="add_sp" datasource="#new_dsn3#"> 
        CREATE PROCEDURE [GET_WORKSTATIONS_PRODUCTS] 
        @_OPERATION_TYPE_ID_  int,
        @production_stock_id int	
        AS
        BEGIN
            -- SET NOCOUNT ON added to prevent extra result sets from
            -- interfering with SELECT statements.
            SET NOCOUNT ON;
            SELECT 
                WS_ID AS STATION_ID,
                OPERATION_TYPE_ID,
                PRODUCTION_TIME 
            FROM
                WORKSTATIONS_PRODUCTS 
            WHERE 
                OPERATION_TYPE_ID = @_OPERATION_TYPE_ID_  
                AND MAIN_STOCK_ID = @production_stock_id
          
        END
    </cfquery>

<cfquery name="add_sp" datasource="#new_dsn3#">
        CREATE PROCEDURE [SP_GET_STOCK_RESERVED_SPECT] 
            @STOCK_ID_LIST nvarchar(850)
        AS
        BEGIN
            SET NOCOUNT ON;
            SELECT 
            ISNULL(SUM(STOCK_ARTIR),0) AS ARTAN,
                        ISNULL(SUM(STOCK_AZALT),0) AS AZALAN,
                        STOCK_ID,
                        SPECT_MAIN_ID
            FROM	
            (
                            SELECT
                                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                                S.PRODUCT_ID, 
                                S.STOCK_ID,
                                S.STOCK_CODE, 
                                S.PROPERTY, 
                                S.BARCOD, 
                                PU.MAIN_UNIT,
                                ORDS.ORDER_ID,
                                SP.SPECT_MAIN_ID
                            FROM
                                STOCKS S
                                JOIN #new_dsn#.FNsplit(@STOCK_ID_LIST,',') as xxx on xxx.item = S.STOCK_ID,
                                GET_ORDER_ROW_RESERVED ORR,
                                ORDERS ORDS,
                                PRODUCT_UNIT PU,
                                SPECTS SP
                            WHERE
                                ORR.STOCK_ID = S.STOCK_ID AND 
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND
                                ORR.ORDER_ID = ORDS.ORDER_ID AND
                                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                                SP.SPECT_VAR_ID=ORR.SPECT_VAR_ID AND
                                ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
                            GROUP BY
                                S.PRODUCT_ID,
                                S.STOCK_ID,
                                S.STOCK_CODE,
                                S.PROPERTY,
                                S.BARCOD,
                                PU.MAIN_UNIT,
                                ORDS.ORDER_ID,
                                SP.SPECT_MAIN_ID
                        UNION
                            SELECT
                                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                                S.PRODUCT_ID, 
                                S.STOCK_ID,
                                S.STOCK_CODE, 
                                S.PROPERTY, 
                                S.BARCOD, 
                                PU.MAIN_UNIT,
                                ORDS.ORDER_ID,
                                NULL
                            FROM
                                STOCKS S
                                JOIN #new_dsn#.FNsplit(@STOCK_ID_LIST,',') as xxx on xxx.item = S.STOCK_ID,
                                GET_ORDER_ROW_RESERVED ORR,
                                ORDERS ORDS,
                                PRODUCT_UNIT PU
                            WHERE
                                ORR.STOCK_ID = S.STOCK_ID AND 
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND
                                ORR.ORDER_ID = ORDS.ORDER_ID AND
                                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                                ORR.SPECT_VAR_ID IS NULL AND
                                ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
                            GROUP BY
                                S.PRODUCT_ID,
                                S.STOCK_ID,
                                S.STOCK_CODE,
                                S.PROPERTY,
                                S.BARCOD,
                                PU.MAIN_UNIT,
                                ORDS.ORDER_ID
                        UNION 
                            SELECT
                                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_AZALT,
                                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) *SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_ARTIR,
                                S.PRODUCT_ID,
                                S.STOCK_ID,
                                S.STOCK_CODE,
                                S.PROPERTY,
                                S.BARCOD, 
                                PU.MAIN_UNIT,
                                ORDS.ORDER_ID,
                                NULL
                             FROM
                                STOCKS S
                                JOIN #new_dsn#.FNsplit(@STOCK_ID_LIST,',') as xxx on xxx.item = S.STOCK_ID,
                                GET_ORDER_ROW_RESERVED ORR, 
                                ORDERS ORDS,
                                SPECTS_ROW SR,
                                PRODUCT_UNIT PU
                             WHERE
                                SR.STOCK_ID = S.STOCK_ID AND 
                                ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                                SR.IS_SEVK=1 AND
                                ORDS.RESERVED = 1 AND
                                ORDS.ORDER_STATUS = 1 AND
                                ORR.ORDER_ID = ORDS.ORDER_ID AND
                                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                                ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
                             GROUP BY
                                S.PRODUCT_ID,
                                S.STOCK_ID,
                                S.STOCK_CODE,
                                S.PROPERTY,
                                S.BARCOD, 
                                PU.MAIN_UNIT,
                                ORDS.ORDER_ID
            ) AS XXXX
            GROUP BY STOCK_ID,SPECT_MAIN_ID
        END
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">
        CREATE PROCEDURE [SP_GET_STOCK_RESERVED]
            @product_id INT
        AS
        BEGIN
            SET NOCOUNT ON;
            
            SELECT SUM(STOCK_AZALT)  AS AZALAN,
                   SUM(STOCK_ARTIR)  AS ARTAN
            FROM   (
                       SELECT SUM(STOCK_AZALT) AS STOCK_AZALT,
                              SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                              PRODUCT_ID,
                              STOCK_ID,
                              STOCK_CODE,
                              PROPERTY,
                              BARCOD,
                              MAIN_UNIT
                       FROM   (
                                  SELECT SUM((ORR.RESERVE_STOCK_OUT -ORR.STOCK_OUT) * PU.MULTIPLIER) AS 
                                         STOCK_AZALT,
                                         0       AS STOCK_ARTIR,
                                         S.PRODUCT_ID,
                                         S.STOCK_ID,
                                         S.STOCK_CODE,
                                         S.PROPERTY,
                                         S.BARCOD,
                                         PU.MAIN_UNIT,
                                         ORDS.ORDER_ID
                                  FROM   STOCKS     S,
                                         GET_ORDER_ROW_RESERVED_ALL ORR,
                                         ORDERS     ORDS,
                                         PRODUCT_UNIT PU
                                  WHERE  ORR.STOCK_ID = S.STOCK_ID
                                         AND ORDS.RESERVED = 1
                                         AND ORDS.ORDER_STATUS = 1
                                         AND ORR.ORDER_ID = ORDS.ORDER_ID
                                         AND (
                                                 (ORDS.PURCHASE_SALES = 1 AND ORDS.ORDER_ZONE = 0)
                                                 OR (ORDS.PURCHASE_SALES = 0 AND ORDS.ORDER_ZONE = 1)
                                             )
                                         AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                                         AND (ORR.RESERVE_STOCK_OUT -ORR.STOCK_OUT) > 0
                                         AND ORR.PRODUCT_ID = @product_id
                                  GROUP BY
                                         S.PRODUCT_ID,
                                         S.STOCK_ID,
                                         S.STOCK_CODE,
                                         S.PROPERTY,
                                         S.BARCOD,
                                         PU.MAIN_UNIT,
                                         ORDS.ORDER_ID
                                  UNION
                                  SELECT 0       AS STOCK_AZALT,
                                         SUM((ORR.RESERVE_STOCK_IN -ORR.STOCK_IN) * PU.MULTIPLIER) AS 
                                         STOCK_ARTIR,
                                         S.PRODUCT_ID,
                                         S.STOCK_ID,
                                         S.STOCK_CODE,
                                         S.PROPERTY,
                                         S.BARCOD,
                                         PU.MAIN_UNIT,
                                         ORDS.ORDER_ID
                                  FROM   STOCKS     S,
                                         GET_ORDER_ROW_RESERVED ORR,
                                         ORDERS     ORDS,
                                         #new_dsn#.STOCKS_LOCATION SL,
                                         PRODUCT_UNIT PU
                                  WHERE  ORR.PRODUCT_ID = @product_id
                                         AND ORR.STOCK_ID = S.STOCK_ID
                                         AND ORDS.RESERVED = 1
                                         AND ORDS.ORDER_STATUS = 1
                                         AND ORR.ORDER_ID = ORDS.ORDER_ID
                                         AND ORDS.PURCHASE_SALES = 0
                                         AND ORDS.ORDER_ZONE = 0
                                         AND ORDS.DELIVER_DEPT_ID = SL.DEPARTMENT_ID
                                         AND ORDS.LOCATION_ID = SL.LOCATION_ID
                                         AND ORDS.DELIVER_DEPT_ID IS NOT NULL
                                         AND SL.NO_SALE = 0
                                         AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                                         AND (ORR.RESERVE_STOCK_IN -ORR.STOCK_IN) > 0
                                  GROUP BY
                                         S.PRODUCT_ID,
                                         S.STOCK_ID,
                                         S.STOCK_CODE,
                                         S.PROPERTY,
                                         S.BARCOD,
                                         PU.MAIN_UNIT,
                                         ORDS.ORDER_ID
                                  UNION 
                                  SELECT SUM(
                                             (ORR.RESERVE_STOCK_OUT -ORR.STOCK_OUT) * SR.AMOUNT_VALUE 
                                             * PU.MULTIPLIER
                                         )       AS STOCK_AZALT,
                                         0       AS STOCK_ARTIR,
                                         S.PRODUCT_ID,
                                         S.STOCK_ID,
                                         S.STOCK_CODE,
                                         S.PROPERTY,
                                         S.BARCOD,
                                         PU.MAIN_UNIT,
                                         ORDS.ORDER_ID
                                  FROM   STOCKS     S,
                                         GET_ORDER_ROW_RESERVED ORR,
                                         ORDERS     ORDS,
                                         SPECTS_ROW SR,
                                         PRODUCT_UNIT PU
                                  WHERE  ORR.PRODUCT_ID = @product_id
                                         AND SR.STOCK_ID = S.STOCK_ID
                                         AND ORR.SPECT_VAR_ID = SR.SPECT_ID
                                         AND SR.IS_SEVK = 1
                                         AND ORDS.RESERVED = 1
                                         AND ORDS.ORDER_STATUS = 1
                                         AND ORR.ORDER_ID = ORDS.ORDER_ID
                                         AND (
                                                 (ORDS.PURCHASE_SALES = 1 AND ORDS.ORDER_ZONE = 0)
                                                 OR (ORDS.PURCHASE_SALES = 0 AND ORDS.ORDER_ZONE = 1)
                                             )
                                         AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                                         AND (ORR.RESERVE_STOCK_OUT -ORR.STOCK_OUT) > 0
                                  GROUP BY
                                         S.PRODUCT_ID,
                                         S.STOCK_ID,
                                         S.STOCK_CODE,
                                         S.PROPERTY,
                                         S.BARCOD,
                                         PU.MAIN_UNIT,
                                         ORDS.ORDER_ID
                                  UNION 	
                                  SELECT 0       AS STOCK_AZALT,
                                         SUM(
                                             (ORR.RESERVE_STOCK_IN -ORR.STOCK_IN) * SR.AMOUNT_VALUE 
                                             * PU.MULTIPLIER
                                         )       AS STOCK_ARTIR,
                                         S.PRODUCT_ID,
                                         S.STOCK_ID,
                                         S.STOCK_CODE,
                                         S.PROPERTY,
                                         S.BARCOD,
                                         PU.MAIN_UNIT,
                                         ORDS.ORDER_ID
                                  FROM   STOCKS     S,
                                         GET_ORDER_ROW_RESERVED ORR,
                                         ORDERS     ORDS,
                                         SPECTS_ROW SR,
                                         #new_dsn#.STOCKS_LOCATION SL,
                                         PRODUCT_UNIT PU
                                  WHERE  ORR.PRODUCT_ID = @product_id
                                         AND SR.STOCK_ID = S.STOCK_ID
                                         AND ORR.SPECT_VAR_ID = SR.SPECT_ID
                                         AND SR.IS_SEVK = 1
                                         AND ORDS.RESERVED = 1
                                         AND ORDS.ORDER_STATUS = 1
                                         AND ORR.ORDER_ID = ORDS.ORDER_ID
                                         AND ORDS.PURCHASE_SALES = 0
                                         AND ORDS.ORDER_ZONE = 0
                                         AND ORDS.DELIVER_DEPT_ID = SL.DEPARTMENT_ID
                                         AND ORDS.LOCATION_ID = SL.LOCATION_ID
                                         AND ORDS.DELIVER_DEPT_ID IS NOT NULL
                                         AND SL.NO_SALE = 0
                                         AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                                         AND (ORR.RESERVE_STOCK_IN -ORR.STOCK_IN) > 0
                                  GROUP BY
                                         S.PRODUCT_ID,
                                         S.STOCK_ID,
                                         S.STOCK_CODE,
                                         S.PROPERTY,
                                         S.BARCOD,
                                         PU.MAIN_UNIT,
                                         ORDS.ORDER_ID
                                  UNION
                                  SELECT SUM((ORR.RESERVE_STOCK_OUT -ORR.STOCK_OUT) * PU.MULTIPLIER) AS 
                                         STOCK_AZALT,
                                         SUM((ORR.RESERVE_STOCK_IN -ORR.STOCK_IN) * PU.MULTIPLIER) AS 
                                         STOCK_ARTIR,
                                         S.PRODUCT_ID,
                                         S.STOCK_ID,
                                         S.STOCK_CODE,
                                         S.PROPERTY,
                                         S.BARCOD,
                                         PU.MAIN_UNIT,
                                         0          ORDER_ID
                                  FROM   STOCKS     S,
                                         GET_ORDER_ROW_RESERVED ORR,
                                         PRODUCT_UNIT PU
                                  WHERE  ORR.PRODUCT_ID = @product_id
                                         AND ORR.STOCK_ID = S.STOCK_ID
                                         AND ORR.ORDER_ID IS NULL
                                         AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                                         AND (
                                                 (ORR.RESERVE_STOCK_IN -ORR.STOCK_IN) > 
                                                 0
                                                 OR (ORR.RESERVE_STOCK_OUT -ORR.STOCK_OUT)
                                                    > 0
                                             )
                                  GROUP BY
                                         S.PRODUCT_ID,
                                         S.STOCK_ID,
                                         S.STOCK_CODE,
                                         S.PROPERTY,
                                         S.BARCOD,
                                         PU.MAIN_UNIT
                              ) AS GET_STOCK_RESERVED_ROW
                       GROUP BY
                              PRODUCT_ID,
                              STOCK_ID,
                              STOCK_CODE,
                              PROPERTY,
                              BARCOD,
                              MAIN_UNIT
                   )                 AS GET_STOCK_RESERVED
            WHERE  PRODUCT_ID = @product_id
        END
    </cfquery>
            
    <cfquery name="add_sp" datasource="#new_dsn3#"> 
        CREATE PROCEDURE  [UPD_GENERAL_PAPERS]
        @system_paper_no_add int
        AS
        BEGIN
            SET NOCOUNT ON;
                UPDATE 
                    GENERAL_PAPERS
                SET
                    PRODUCTION_RESULT_NUMBER = @system_paper_no_add
                WHERE
                    PRODUCTION_RESULT_NUMBER IS NOT NULL
        END
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#"> 
        CREATE PROCEDURE [UPD_GENERAL_PAPERS_LOT_NUMBER] 
        @lot_system_paper_no_add int
        AS
        BEGIN
            -- SET NOCOUNT ON added to prevent extra result sets from
            -- interfering with SELECT statements.
            SET NOCOUNT ON;
            UPDATE 
                GENERAL_PAPERS
            SET
                PRODUCTION_LOT_NUMBER = @lot_system_paper_no_add
            WHERE
                PRODUCTION_LOT_NUMBER IS NOT NULL
        END
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">
        CREATE PROCEDURE  [UPD_GENERAL_PAPERS_PROD_ORDER_NUMBER]
        @system_paper_no_add int
        AS
        BEGIN
            SET NOCOUNT ON;
            UPDATE 
                GENERAL_PAPERS
            SET
                PROD_ORDER_NUMBER = @system_paper_no_add
            WHERE
                PROD_ORDER_NUMBER IS NOT NULL
        END
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">
        CREATE PROCEDURE  [UPD_PRO_ORDER_LOT_NUMBER]
            @lot_no nvarchar(50),
            @p_order_id int
        AS
        BEGIN
            SET NOCOUNT ON;
                UPDATE PRODUCTION_ORDERS SET LOT_NO = @lot_no  WHERE P_ORDER_ID = @p_order_id
        END
    </cfquery>	
    <cfquery name="add_sp" datasource="#new_dsn3#">
        create PROCEDURE  [UPD_PROD_ORDER_ROW_SPECT]
            @new_created_spect_id int,
            @new_created_spect_name nvarchar(500),
            @new_created_spect_main_id int ,
            @p_order_id int
            AS
            BEGIN
                SET NOCOUNT ON;
                UPDATE 
                            PRODUCTION_ORDER_RESULTS_ROW
                        SET
                            SPECT_ID = @new_created_spect_id,
                            SPECT_NAME = @new_created_spect_name,
                            SPEC_MAIN_ID = @new_created_spect_main_id
                        WHERE
                            TYPE=1 AND 
                            PR_ORDER_ID = @p_order_id
            END	
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">
        create PROCEDURE  [UPD_PROD_ORDER_SPECT]
            @new_created_spect_id int,
            @new_created_spect_name nvarchar(500),
            @new_created_spect_main_id int ,
            @p_order_id int
            AS
            BEGIN
                SET NOCOUNT ON;
                UPDATE 
                            PRODUCTION_ORDERS
                        SET
                            SPECT_VAR_ID = @new_created_spect_id,
                            SPECT_VAR_NAME = @new_created_spect_name,
                            SPEC_MAIN_ID = @new_created_spect_main_id
                        WHERE
                            P_ORDER_ID =  @p_order_id
            END
    </cfquery>
    <cfquery name="add_sp" datasource="#new_dsn3#">
        CREATE PROCEDURE [UPD_PRODUCTION_ORDERS_REF_NO] 
            @ref_no nvarchar(50),
            @p_order_id int
        AS
        BEGIN
            SET NOCOUNT ON;
                UPDATE PRODUCTION_ORDERS SET REFERENCE_NO = @ref_no  WHERE P_ORDER_ID = @p_order_id
        END	
    </cfquery>
    
    
    <cfquery name="ADD_SP" datasource="#new_dsn3#">
    	CREATE PROCEDURE [GET_NETBOOK]
                    @action_date datetime,			
                    @process_date datetime,			
                    @db_alias nvarchar(50)
                AS
                BEGIN
                                
                    SET NOCOUNT ON;
                    DECLARE @SQL_TEXT NVARCHAR(500);
                                
                    IF LEN(@db_alias) > 0
                        BEGIN
                            IF @action_date IS NOT NULL
                                BEGIN
                                    SET @SQL_TEXT = 'SELECT TOP 1 NETBOOK_ID FROM '+ @db_alias +'NETBOOKS WHERE STATUS = 1 AND (' + ''''+CONVERT(nvarchar(50),@action_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE OR ' + ''''+CONVERT(nvarchar(50),@process_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE)';
                                END
                            ELSE
                                BEGIN
                                    SET @SQL_TEXT = 'SELECT TOP 1 NETBOOK_ID FROM '+ @db_alias +'NETBOOKS WHERE STATUS = 1 AND ' + ''''+CONVERT(nvarchar(50),@process_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE';
                                END
                        END
                                
                    ELSE
                        BEGIN
                            IF @action_date IS NOT NULL
                                BEGIN
                                    SET @SQL_TEXT = 'SELECT TOP 1 NETBOOK_ID FROM NETBOOKS WHERE STATUS = 1 AND (' + ''''+CONVERT(nvarchar(50),@action_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE OR ' + ''''+CONVERT(nvarchar(50),@process_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE)';
                                END
                            ELSE
                                BEGIN
                                    SET @SQL_TEXT = 'SELECT TOP 1 NETBOOK_ID FROM NETBOOKS WHERE STATUS = 1 AND ' + ''''+CONVERT(nvarchar(50),@process_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE';
                                END
                        END
                                
                    exec (@SQL_TEXT); 
                END
    </cfquery>
    
ok --> <cfoutput>#get_our_comps.currentrow#</cfoutput><br/>
	</cfloop>
</cfif>
    

