<!--- Create Date GecmisGunHatirlamiyorum 
Modifier: Sevda Mersin--->
<cfparam name="attributes.module_id_control" default="13">
<cfinclude template="report_authority_control.cfm">
<cf_xml_page_edit fuseact="report.stock_profile">
<cfsetting showdebugoutput="no"><!--- Excele alınırken sorun oluyor, debug ı açmayınız --->
<cfprocessingdirective suppresswhitespace="yes">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_code" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.price_catid" default="-2">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.list_type" default="">
<cfparam name="attributes.product_status" default="">
<cfparam name="attributes.strategy_status" default="1">
<cfparam name="attributes.volume_unit" default="">
<cfparam name="attributes.weight_unit" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset is_stock_table = 0>
<cfif isdefined("attributes.is_form_submitted") and isdefined("attributes.is_excel") and   attributes.is_excel eq 1  and isdefined("attributes.is_strategy")  and  not isdefined("attributes.is_location_group") and  not isdefined("attributes.is_shelf_group") and  not isdefined("attributes.is_branch_group") and  not isdefined("attributes.is_price_list") and  not isdefined("attributes.is_zero_stock") >
	<cfinclude template="stock_profile_excel.cfm">
</cfif>
<cfquery name="get_price_cats" datasource="#DSN3#">
	SELECT PRICE_CATID, PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT
</cfquery>
<cfquery name="get_department" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD
	FROM
		BRANCH B,
		DEPARTMENT D 
	WHERE
		B.COMPANY_ID = #session.ep.company_id# AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2 AND
		<cfif x_show_pasive_departments eq 0>
            D.DEPARTMENT_STATUS = 1 AND
        </cfif>
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY
    DEPARTMENT_HEAD
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cfif isdefined("attributes.is_strategy")><!--- Strateji seçildiğinde her durumda satılabilir stok gelsin --->
		<cfif len(attributes.list_type)>
			<cfif not listfind(attributes.list_type,7)>
				<cfset attributes.list_type = listappend(attributes.list_type,7,',')>
			</cfif>
		<cfelse>
			<cfset attributes.list_type = 7>
		</cfif>
	</cfif>
	<cfif len(attributes.company_id) and len(attributes.company)>
		<cfset is_stock_table=1>
	<cfelseif len(attributes.pos_code) and len(attributes.employee)>
		<cfset is_stock_table=1>
	<cfelseif len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
		<cfset is_stock_table=1>
	<cfelseif len(attributes.product_code) and len(attributes.product_cat)>
		<cfset is_stock_table=1>
	</cfif>
	
	<cfquery name="chehktable" datasource="#dsn1#">
		IF EXISTS(SELECT * FROM tempdb.sys.tables where name='####GetStockProfile')
		BEGIN
			DROP TABLE ####GetStockProfile
		END
        IF EXISTS(SELECT * FROM tempdb.sys.tables where name='####TStockProfile')
        BEGIN
            DROP TABLE ####TStockProfile
        END
        IF EXISTS(SELECT * FROM tempdb.sys.tables where name='####TStockLastProfile')
        BEGIN
            DROP TABLE ####TStockLastProfile
        END
		IF EXISTS(SELECT * FROM tempdb.sys.tables where name='####TStocStrategy')
        BEGIN
            DROP TABLE ####TStocStrategy
        END
	</cfquery>

	<cfquery name="get_stock_table" datasource="#dsn3#">
    	SELECT
			S.PRODUCT_UNIT_ID,
            S.PRODUCT_ID,
            S.STOCK_ID,
            S.PRODUCT_NAME,
            S.STOCK_CODE_2,
            S.STOCK_CODE,
            S.BARCOD,
            S.STOCK_ID AS PRODUCT_GROUPBY_ID,
            <cfif x_show_second_unit>
                (SELECT top 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                (SELECT top 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
            </cfif>	
            (S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'')) PROD_NAME,
             PU.MAIN_UNIT
		INTO ####GetStockProfile
		FROM
            STOCKS S
                LEFT JOIN PRODUCT_UNIT PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
				LEFT JOIN PRODUCT AS P ON P.PRODUCT_ID = S.PRODUCT_ID	
		WHERE
			p.IS_INVENTORY  = 1 
			<cfif len(attributes.product_id) and len(attributes.product_name)>
                AND S.PRODUCT_ID = #attributes.product_id#
            </cfif>
            <cfif len(attributes.company_id) and len(attributes.company)>
                AND S.COMPANY_ID = #attributes.company_id#
            </cfif>
            <cfif len(attributes.pos_code) and len(attributes.employee)>
                AND S.PRODUCT_MANAGER = #attributes.pos_code#
            </cfif>
            <cfif len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
                AND S.BRAND_ID = #attributes.brand_id# 
            </cfif>	
            <cfif len(attributes.product_code) and len(attributes.product_cat)>
                AND S.STOCK_CODE LIKE '#attributes.product_code#%'
            </cfif>
			<cfif len(attributes.product_status)>
				AND S.PRODUCT_STATUS = #attributes.product_status#
			</cfif>
			<cfif isdefined("attributes.is_price_list") and attributes.price_catid neq -2>
                        AND S.PRODUCT_ID IN(
                                                SELECT  
                                                    P.PRODUCT_ID
                                                FROM 
                                                    #dsn3_alias#.PRICE P,
                                                    #dsn3_alias#.PRODUCT_UNIT AS PU
                                                WHERE 
                                                    P.PRODUCT_ID = PU.PRODUCT_ID
                                                    AND ((ISNULL(P.STOCK_ID,0) = S.STOCK_ID AND P.STOCK_ID IS NOT NULL) OR (ISNULL(P.STOCK_ID,0) = 0 AND P.STOCK_ID IS NULL))
                                                    AND ISNULL(P.SPECT_VAR_ID,0)=0
                                                    AND PU.IS_MAIN = 1
                                                    AND P.PRICE_CATID = #attributes.price_catid#
                                                    AND P.STARTDATE <= #createodbcdatetime(dateformat(now(),'yyyy-mm-dd'))#
                                                    AND (P.FINISHDATE >= #createodbcdatetime(dateformat(now(),'yyyy-mm-dd'))# OR P.FINISHDATE IS NULL)
                                                    AND P.PRODUCT_ID = S.PRODUCT_ID
                                            )
                    <cfelseif isdefined("attributes.is_price_list") and attributes.price_catid eq -2>
                        AND S.PRODUCT_ID IN(
                                                SELECT  
                                                    PS.PRODUCT_ID
                                                FROM 
                                                    #dsn3_alias#.PRICE_STANDART PS,
                                                    #dsn3_alias#.PRODUCT_UNIT AS PU
                                                WHERE 
                                                    PS.PRODUCT_ID = PU.PRODUCT_ID
                                                    AND PU.IS_MAIN = 1
                                                    AND PS.PURCHASESALES = 1
                                                    AND PS.PRICESTANDART_STATUS = 1
                                                    AND PS.PRODUCT_ID = S.PRODUCT_ID
                                            )
                    </cfif>	
	</cfquery>

	<cfif not len(attributes.department_id)>
        <cfstoredproc procedure="SpGetStoctProfile" datasource="#dsn2#">
        </cfstoredproc>
	<cfelse>
        <cfstoredproc procedure="SpGetStockLastStrategy" datasource="#dsn2#">
        </cfstoredproc>
	</cfif>
    <cfstoredproc procedure="SpGetStockStrategy" datasource="#dsn2#">
    </cfstoredproc>

	<cfquery name="GET_ALL_STOCK" datasource="#dsn2#">
		SELECT
        	  DISTINCT GET_ALL_STOCK.*
            <cfif not isdefined("attributes.is_branch_group") and not isdefined("attributes.is_shelf_group") and not isdefined("attributes.is_location_group")>
                ,ISNULL(GET_DISPATCH_SHIP.STOCK_SHIP_AMOUNT,0) STOCK_SHIP_AMOUNT
                ,ISNULL(GET_PURCHASE_PRICE.PRICE,0) PRICE
                ,ISNULL(GET_PURCHASE_PRICE.MONEY,0) MONEY
                ,ISNULL(GET_PURCHASE_PRICE.PURCHASESALES,0) PURCHASESALES
                <cfif isDefined("attributes.is_strategy")>
	                ,GET_ACTION_TYPES.STOCK_ACTION_MESSAGE
                </cfif>
                <cfif listfind(attributes.list_type,10)> 
	                ,GET_PRODUCT_UNIT.DIMENTION
    	            ,GET_PRODUCT_UNIT.WEIGHT
                </cfif>
                ,ISNULL(GET_PRICES.PRICE,0) AS PRICE1
                ,ISNULL(GET_PRICES.MONEY,0) AS MONEY1
			<cfelseif isdefined("attributes.is_branch_group")>
              <!---  ,ISNULL(GET_DEPARTMENT_AMOUNT.REAL_STOCK,0) REAL_STOCK1
            	,ISNULL(GET_DEPARTMENT_AMOUNT.SALEABLE_STOCK,0) SALEABLE_STOCK1--->
			<cfelseif isdefined("attributes.is_location_group")>
                <!---,ISNULL(GET_LOCATION_AMOUNT.REAL_STOCK,0)     REAL_STOCK 
            	,ISNULL(GET_LOCATION_AMOUNT.SALEABLE_STOCK,0) SALEABLE_STOCK--->
			<cfelseif isdefined("attributes.is_shelf_group")>
              <!---  ,ISNULL(GET_SHELF_AMOUNT.REAL_STOCK,0)      REAL_STOCK
            	,ISNULL(GET_SHELF_AMOUNT.SALEABLE_STOCK,0) SALEABLE_STOCK--->
            </cfif>
        FROM 
			(
			<cfif attributes.strategy_status eq 1 or not len(attributes.strategy_status)>
                SELECT
                    gsp.PRODUCT_UNIT_ID,
                    gsp.PRODUCT_ID,
                    gsp.STOCK_ID,
                    gsp.PRODUCT_NAME,
                    gsp.STOCK_CODE_2,
                    gsp.STOCK_CODE,
                    gsp.BARCOD,
                    gsp.PRODUCT_GROUPBY_ID,
                    <cfif x_show_second_unit>
                       gsp.UNIT2,
                       gsp.MULTIPLIER,
                    </cfif>	
                   gsp.PROD_NAME,
                    <cfif isDefined("attributes.is_strategy")>
                        GS_STRATEGY.MAXIMUM_STOCK MAXIMUM_STOCK,
                        GS_STRATEGY.REPEAT_STOCK_VALUE REPEAT_STOCK_VALUE,
                        GS_STRATEGY.MINIMUM_STOCK MINIMUM_STOCK,
                        GS_STRATEGY.BLOCK_STOCK_VALUE BLOCK_STOCK_VALUE,
                        GS_STRATEGY.MINIMUM_ORDER_STOCK_VALUE MINIMUM_ORDER_STOCK_VALUE,
                        GS_STRATEGY.MAXIMUM_ORDER_STOCK_VALUE MAXIMUM_ORDER_STOCK_VALUE,
                        GS_STRATEGY.STOCK_ACTION_ID STOCK_ACTION_ID,
                    </cfif>
                    SUM(GSL.REAL_STOCK) REAL_STOCK,
                    SUM(GSL.SALEABLE_STOCK) SALEABLE_STOCK,
                    SUM(GSL.RESERVE_SALE_ORDER_STOCK) RESERVE_SALE_ORDER_STOCK,
                    SUM(GSL.RESERVE_PURCHASE_ORDER_STOCK) RESERVE_PURCHASE_ORDER_STOCK,
                    SUM(GSL.RESERVED_PROD_STOCK) RESERVED_PROD_STOCK,
                    SUM(GSL.PURCHASE_PROD_STOCK) PURCHASE_PROD_STOCK,
                    SUM(GSL.NOSALE_STOCK) NOSALE_STOCK,
                    SUM(GSL.BELONGTO_INSTITUTION_STOCK) BELONGTO_INSTITUTION_STOCK,
                    SUM(GSL.NOSALE_RESERVED_STOCK) NOSALE_RESERVED_STOCK,
                    gsp.MAIN_UNIT
                FROM
                    
					####GetStockProfile gsp
					<cfif not len(attributes.department_id)>
                        , ####TStockProfile GSL
                    <cfelse>
                        , ####TStockLastProfile  GSL
                    </cfif>
                    <cfif isDefined("attributes.is_strategy")>
                        ,####TStocStrategy GS_STRATEGY
                    </cfif>
                WHERE
                    GSL.STOCK_ID = gsp.STOCK_ID 
                    
					<cfif isDefined("attributes.is_strategy")>
						AND GS_STRATEGY.STOCK_ID = gsp.STOCK_ID 
					</cfif>
					<cfif len(attributes.department_id)>
                        AND
                        (
                            (
                                <cfif isDefined("attributes.is_strategy") and listlen(attributes.dept_name) eq 1>
                                    GS_STRATEGY.DEPARTMENT_ID = GSL.DEPARTMENT_ID AND
                                </cfif>
                                (
                                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                    (GSL.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND GSL.LOCATION_ID = #listlast(dept_i,'-')#)
                                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                </cfloop>
                                )
                            )
                            <cfif isDefined("attributes.is_strategy")>
                            OR 
                            (
                            	<cfif not isdefined("attributes.is_location_group")>
                                	GSL.DEPARTMENT_ID = -1 AND 
                                </cfif>
                                <cfif isDefined("attributes.is_strategy") and listlen(attributes.dept_name) eq 1>
                                    GS_STRATEGY.DEPARTMENT_ID = #listfirst(attributes.department_id,'-')#
                                <cfelseif isDefined("attributes.is_strategy")>
                                    GS_STRATEGY.DEPARTMENT_ID IS NULL
                                </cfif>
                            )
                            </cfif>
                        )	
                    <cfelseif isDefined("attributes.is_strategy")>
                        AND	GS_STRATEGY.DEPARTMENT_ID IS NULL
                        AND GS_STRATEGY.MAXIMUM_STOCK IS NOT NULL
                        AND GS_STRATEGY.MINIMUM_STOCK IS NOT NULL
                        AND GS_STRATEGY.REPEAT_STOCK_VALUE IS NOT NULL
                        AND GS_STRATEGY.MINIMUM_ORDER_STOCK_VALUE IS NOT NULL
                        AND GS_STRATEGY.PROVISION_TIME IS NOT NULL		
                    </cfif>
                GROUP BY
                      	gsp.PROD_NAME,
						gsp.MAIN_UNIT,
						gsp.PRODUCT_UNIT_ID,
                        gsp.PRODUCT_ID,
                        gsp.STOCK_ID,
                        gsp.PRODUCT_NAME,
                        gsp.STOCK_CODE_2,
                        gsp.STOCK_CODE,
                        gsp.BARCOD,
                        gsp.PRODUCT_GROUPBY_ID
                        <cfif x_show_second_unit>
                           ,gsp.UNIT2
                           ,gsp.MULTIPLIER
                        </cfif>	
                    <cfif isDefined("attributes.is_strategy")>
                        ,GS_STRATEGY.MAXIMUM_STOCK
                        ,GS_STRATEGY.REPEAT_STOCK_VALUE
                        ,GS_STRATEGY.MINIMUM_STOCK
                        ,GS_STRATEGY.BLOCK_STOCK_VALUE
                        ,GS_STRATEGY.MINIMUM_ORDER_STOCK_VALUE
                        ,GS_STRATEGY.MAXIMUM_ORDER_STOCK_VALUE
                        ,GS_STRATEGY.STOCK_ACTION_ID
                    </cfif>
                <cfif isDefined("attributes.is_zero_stock")>
                    HAVING SUM(GSL.REAL_STOCK) <>0
                </cfif>
            </cfif>
            <cfif isDefined("attributes.is_strategy") and not len(attributes.strategy_status)>
                UNION ALL
            </cfif>
            <cfif isDefined("attributes.is_strategy") and (attributes.strategy_status eq 2 or not len(attributes.strategy_status))>
                SELECT
                    gsp.PRODUCT_UNIT_ID,
                    gsp.PRODUCT_ID,
                    gsp.STOCK_ID,
                    gsp.PRODUCT_NAME,
                    gsp.STOCK_CODE_2,
                    gsp.STOCK_CODE,
                    gsp.BARCOD,
                    gsp.PRODUCT_GROUPBY_ID,
                    <cfif x_show_second_unit>
                       gsp.UNIT2,
                       gsp.MULTIPLIER,
                    </cfif>	
                   gsp.PROD_NAME,
                    <cfif isDefined("attributes.is_strategy")>
                        0 MAXIMUM_STOCK,
                        0 REPEAT_STOCK_VALUE,
                        0 MINIMUM_STOCK,
                        0 BLOCK_STOCK_VALUE,
                        0 MINIMUM_ORDER_STOCK_VALUE,
                        0 MAXIMUM_ORDER_STOCK_VALUE,
                        0 STOCK_ACTION_ID,
                    </cfif>
                    SUM(GSL.REAL_STOCK) REAL_STOCK,
                    SUM(GSL.SALEABLE_STOCK) SALEABLE_STOCK,
                    SUM(GSL.RESERVE_SALE_ORDER_STOCK) RESERVE_SALE_ORDER_STOCK,
                    SUM(GSL.RESERVE_PURCHASE_ORDER_STOCK) RESERVE_PURCHASE_ORDER_STOCK,
                    SUM(GSL.RESERVED_PROD_STOCK) RESERVED_PROD_STOCK,
                    SUM(GSL.PURCHASE_PROD_STOCK) PURCHASE_PROD_STOCK,
                    SUM(GSL.NOSALE_STOCK) NOSALE_STOCK,
                    SUM(GSL.BELONGTO_INSTITUTION_STOCK) BELONGTO_INSTITUTION_STOCK,
                    SUM(GSL.NOSALE_RESERVED_STOCK) NOSALE_RESERVED_STOCK,
                    gsp.MAIN_UNIT
                FROM
                    ####GetStockProfile gsp
					<cfif isDefined("attributes.is_strategy")>
						LEFT JOIN ####TStocStrategy GS_STRATEGY ON   gsp.STOCK_ID   = GS_STRATEGY.STOCK_ID
					</cfif>
					
					<cfif not len(attributes.department_id)>
                        , ####TStockProfile GSL
                    <cfelse>
                        , ####TStockLastProfile  GSL
                    </cfif>
                WHERE
                    GSL.STOCK_ID = gsp.STOCK_ID 
                    
					<cfif isDefined("attributes.is_strategy")>
						AND GS_STRATEGY.STOCK_ID IS NULL
					</cfif>
					<cfif len(attributes.department_id)>
                        AND((
                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                            (GSL.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND GSL.LOCATION_ID = #listlast(dept_i,'-')#)
                            <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                        </cfloop>)
                        OR 
                        GSL.DEPARTMENT_ID = -1)	
                    </cfif>
					
                GROUP BY
                    gsp.MAIN_UNIT,
					gsp.PRODUCT_UNIT_ID,
                    gsp.PRODUCT_ID,
                    gsp.STOCK_ID,
                    gsp.PRODUCT_NAME,
                    gsp.STOCK_CODE_2,
                    gsp.STOCK_CODE,
                    gsp.PROD_NAME,
					gsp.BARCOD,
                    gsp.PRODUCT_GROUPBY_ID,
                    <cfif x_show_second_unit>
                       gsp.UNIT2,
                       gsp.MULTIPLIER,
                    </cfif>	
                    gsp.PROD_NAME
                <cfif isDefined("attributes.is_zero_stock")>
                    HAVING SUM(GSL.REAL_STOCK) <>0
                </cfif>
            </cfif>
        	) AS GET_ALL_STOCK 
			<cfif not isdefined("attributes.is_branch_group") and not isdefined("attributes.is_shelf_group") and not isdefined("attributes.is_location_group")>  
                LEFT JOIN
                    (
                        SELECT 
                            SUM(STOCK_IN-STOCK_OUT) AS STOCK_SHIP_AMOUNT,			
                            SR.STOCK_ID,
                            SR.PRODUCT_ID
                        FROM
                            STOCKS_ROW SR
                            <cfif is_stock_table>
                            ,#dsn3_alias#.STOCKS S
                            </cfif>
                        WHERE
                            SR.PROCESS_TYPE IN (81,811)
                            <cfif is_stock_table>
                                AND SR.STOCK_ID=S.STOCK_ID 
                            </cfif>
                            <cfif len(attributes.product_id) and len(attributes.product_name)>
                                AND SR.PRODUCT_ID = #attributes.product_id#
                            </cfif>
                            <cfif is_stock_table>
                                <cfif len(attributes.company_id) and len(attributes.company)>
                                    AND S.COMPANY_ID = #attributes.company_id#
                                </cfif>
                                <cfif len(attributes.pos_code) and len(attributes.employee)>
                                    AND S.PRODUCT_MANAGER = #attributes.pos_code#
                                </cfif>
                                <cfif len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                </cfif>	
                                <cfif len(attributes.product_code) and len(attributes.product_cat)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                </cfif>
                            </cfif>
                        GROUP BY
                            SR.PRODUCT_ID,
                            SR.STOCK_ID
                	) AS GET_DISPATCH_SHIP ON GET_ALL_STOCK.STOCK_ID = GET_DISPATCH_SHIP.STOCK_ID
                LEFT JOIN 
                    (
                        SELECT
                            PS.PRODUCT_ID,
                            PS.PRICE,
                            PS.MONEY,
                            PS.PURCHASESALES,
                            PS.PRICESTANDART_STATUS
                        FROM
                            #DSN3_ALIAS#.PRICE_STANDART AS PS 
                            <cfif is_stock_table>
                            	,#dsn3_alias#.STOCKS S
                            </cfif>
                        WHERE
                            <cfif attributes.price_catid neq '-2'> <!--- standart satış haricinde bir satış fiyat listesi secilmisse sadece alıs fiyatı cekilecek --->
                                 PS.PURCHASESALES = 0 AND
                            </cfif>
                             PS.PURCHASESALES = 0 AND
                             PS.PRICESTANDART_STATUS = 1
                            <cfif len(attributes.product_id) and len(attributes.product_name)>
                                AND PS.PRODUCT_ID = #attributes.product_id#
                            </cfif>
                            <cfif is_stock_table>
                                AND PS.PRODUCT_ID=S.PRODUCT_ID
                                <cfif len(attributes.company_id) and len(attributes.company)>
                                    AND S.COMPANY_ID = #attributes.company_id#
                                </cfif>
                                <cfif len(attributes.pos_code) and len(attributes.employee)>
                                    AND S.PRODUCT_MANAGER = #attributes.pos_code#
                                </cfif>
                                <cfif len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                </cfif>	
                                <cfif len(attributes.product_code) and len(attributes.product_cat)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                </cfif>
                            </cfif>
                    ) AS GET_PURCHASE_PRICE ON GET_ALL_STOCK.PRODUCT_ID = GET_PURCHASE_PRICE.PRODUCT_ID
                <cfif isDefined("attributes.is_strategy")>
                    LEFT JOIN 
                        (
                            SELECT
                                STOCK_ACTION_ID,
                                STOCK_ACTION_MESSAGE 
                            FROM 
                                #dsn3_alias#.SETUP_SALEABLE_STOCK_ACTION
                        ) AS GET_ACTION_TYPES ON GET_ALL_STOCK.STOCK_ACTION_ID = GET_ACTION_TYPES.STOCK_ACTION_ID   
				</cfif>                    
				<cfif listfind(attributes.list_type,10)>                                     
                    LEFT JOIN
                        (
                            SELECT
                                PU.PRODUCT_UNIT_ID,
                                PU.DIMENTION,
                                ISNULL(PU.WEIGHT,0) WEIGHT
                            FROM
                                #DSN3_ALIAS#.PRODUCT_UNIT PU
                            WHERE
                                PRODUCT_UNIT_STATUS = 1
                                <cfif len(attributes.product_id) and len(attributes.product_name)>
                                    AND PU.PRODUCT_ID = #attributes.product_id#
                                </cfif>
                        ) AS GET_PRODUCT_UNIT ON GET_ALL_STOCK.PRODUCT_UNIT_ID = GET_PRODUCT_UNIT.PRODUCT_UNIT_ID 
				</cfif>     
                    LEFT JOIN 
                        (
                            <cfif attributes.price_catid eq -2>
                                SELECT  
                                    PS.PRICE,
                                    PS.MONEY,
                                    PS.PRODUCT_ID
                                FROM 
                                    #dsn3_alias#.PRICE_STANDART PS,
                                    #dsn3_alias#.PRODUCT_UNIT AS PU
                                WHERE 
                                    PS.PRODUCT_ID = PU.PRODUCT_ID
                                    AND PU.IS_MAIN = 1
                                    AND PS.PURCHASESALES = 1
                                    AND PS.PRICESTANDART_STATUS = 1                               
                                    <cfif len(attributes.product_id) and len(attributes.product_name)>
                                        AND PS.PRODUCT_ID = #attributes.product_id#
                                    </cfif>
                            <cfelse>
                                    SELECT  
                                        MAX(P.STARTDATE) AS STARTDATE,
                                        P.PRODUCT_ID,P.PRICE,P.MONEY
                                    FROM 
                                        #dsn3_alias#.PRICE P,
                                        #dsn3_alias#.PRODUCT_UNIT AS PU,
                                        #dsn3_alias#.STOCKS S
                                    WHERE 
                                        P.PRODUCT_ID = PU.PRODUCT_ID
                                        AND ((ISNULL(P.STOCK_ID,0) = S.STOCK_ID AND P.STOCK_ID IS NOT NULL) OR (ISNULL(P.STOCK_ID,0) = 0 AND P.STOCK_ID IS NULL))
                                        AND ISNULL(P.SPECT_VAR_ID,0)=0
                                        AND PU.IS_MAIN = 1
                                        AND P.PRICE_CATID = #attributes.price_catid#
                                        AND P.STARTDATE <= #createodbcdatetime(dateformat(now(),'yyyy-mm-dd'))#
                                        AND (P.FINISHDATE >= #createodbcdatetime(dateformat(now(),'yyyy-mm-dd'))# OR P.FINISHDATE IS NULL)
                                        <cfif len(attributes.product_id) and len(attributes.product_name)>
                                            AND P.PRODUCT_ID = #attributes.product_id#
                                        </cfif>
                                    GROUP BY
                                        P.PRODUCT_ID,P.PRICE,P.MONEY
                            </cfif>
                        ) AS GET_PRICES ON GET_ALL_STOCK.PRODUCT_ID = GET_PRICES.PRODUCT_ID                  
			<cfelseif isdefined("attributes.is_branch_group")>            
                    LEFT JOIN 
                        (
                            SELECT
                                SUM(REAL_STOCK) REAL_STOCK,
                                SUM(SALEABLE_STOCK) SALEABLE_STOCK,
                                PRODUCT_ID,
                                STOCK_ID,
                                BRANCH_ID,
                                BRANCH_NAME
                            FROM
                            (
                            SELECT
                                GSL.REAL_STOCK,
                                GSL.SALEABLE_STOCK,
                                GSL.PRODUCT_ID,
                                GSL.STOCK_ID,
                                (SELECT B.BRANCH_ID FROM #dsn_alias#.DEPARTMENT D,#dsn_alias#.BRANCH B WHERE B.BRANCH_ID=D.BRANCH_ID AND D.DEPARTMENT_ID = GSL.DEPARTMENT_ID) AS BRANCH_ID,
                                (SELECT D.DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT D,#dsn_alias#.BRANCH B WHERE B.BRANCH_ID=D.BRANCH_ID AND D.DEPARTMENT_ID = GSL.DEPARTMENT_ID) AS BRANCH_NAME
                            FROM
                                GET_STOCK_LAST_LOCATION GSL
                                <cfif is_stock_table>
                                ,#dsn3_alias#.STOCKS S
                                </cfif>
                            WHERE
                                1 = 1
                                <cfif len(attributes.product_id) and len(attributes.product_name)>
                                    AND GSL.PRODUCT_ID = #attributes.product_id#
                                </cfif>
                                <cfif len(attributes.department_id)>
                                    AND((
                                    <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (GSL.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND GSL.LOCATION_ID = #listlast(dept_i,'-')#)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                    </cfloop>)
                                    OR 
                                    GSL.DEPARTMENT_ID = -1)	
                                <cfelse>
                                    AND GSL.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.BRANCH B,#dsn_alias#.DEPARTMENT D WHERE	B.COMPANY_ID = #session.ep.company_id# AND B.BRANCH_ID = D.BRANCH_ID AND D.IS_STORE <> 2 AND		
                                                                B.BRANCH_ID IN(SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#))
                                </cfif>
                                <cfif is_stock_table>
                                    AND GSL.PRODUCT_ID=S.PRODUCT_ID
                                    AND GSL.STOCK_ID=S.STOCK_ID
                                    AND GSL.REAL_STOCK <> 0
                                    <cfif len(attributes.company_id) and len(attributes.company)>
                                        AND S.COMPANY_ID = #attributes.company_id#
                                    </cfif>
                                    <cfif len(attributes.pos_code) and len(attributes.employee)>
                                        AND S.PRODUCT_MANAGER = #attributes.pos_code#
                                    </cfif>
                                    <cfif len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
                                        AND S.BRAND_ID = #attributes.brand_id# 
                                    </cfif>	
                                    <cfif len(attributes.product_code) and len(attributes.product_cat)>
                                        AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                    </cfif>
                                </cfif>
                            )T1
                            GROUP BY
                                PRODUCT_ID,
                                STOCK_ID,
                                BRANCH_ID,
                                BRANCH_NAME
                        ) AS GET_DEPARTMENT_AMOUNT ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = GET_DEPARTMENT_AMOUNT.STOCK_ID 
            <!---<cfelseif isdefined("attributes.is_location_group")>            
                LEFT JOIN 
                    (--->
                       
						
            <cfelseif isdefined("attributes.is_shelf_group")>            
         <!---       LEFT JOIN 
                    (
                        SELECT
                            SUM(REAL_STOCK) REAL_STOCK,
                            SUM(SALEABLE_STOCK) SALEABLE_STOCK,
                            PRODUCT_ID,
                            STOCK_ID,
                            SHELF_NUMBER
                        FROM
                        (
                        SELECT
                            GSL.REAL_STOCK,
                            GSL.SALEABLE_STOCK,
                            GSL.PRODUCT_ID,
                            GSL.STOCK_ID,
                            GSL.SHELF_NUMBER AS SHELF_NUMBER
                        FROM
                            GET_STOCK_LAST_SHELF GSL,
                            #dsn3_alias#.PRODUCT_PLACE PP
                            <cfif is_stock_table>
                            ,#dsn3_alias#.STOCKS S
                            </cfif>
                        WHERE
                            GSL.SHELF_NUMBER = PP.PRODUCT_PLACE_ID
                            <cfif len(attributes.product_id) and len(attributes.product_name)>
                                AND GSL.PRODUCT_ID = #attributes.product_id#
                            </cfif>
                            <cfif is_stock_table>
                                AND GSL.PRODUCT_ID=S.PRODUCT_ID
                                AND GSL.STOCK_ID=S.STOCK_ID
                                <cfif len(attributes.company_id) and len(attributes.company)>
                                    AND S.COMPANY_ID = #attributes.company_id#
                                </cfif>
                                <cfif len(attributes.pos_code) and len(attributes.employee)>
                                    AND S.PRODUCT_MANAGER = #attributes.pos_code#
                                </cfif>
                                <cfif len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                </cfif>	
                                <cfif len(attributes.product_code) and len(attributes.product_cat)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                </cfif>
                            </cfif>
                        )T1
                        GROUP BY
                            PRODUCT_ID,
                            STOCK_ID,
                            SHELF_NUMBER
                    ) AS GET_SHELF_AMOUNT ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = GET_SHELF_AMOUNT.STOCK_ID            --->    
            </cfif>                       
		ORDER BY
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME
	</cfquery>
<cfelse>
	<cfset GET_ALL_STOCK.recordcount = 0>
	<cfset GET_DISPATCH_SHIP.recordcount = 0>
	<cfset GET_PURCHASE_PRICE.recordcount = 0>
	<cfset GET_PRICES.recordcount = 0>
	<cfset GET_PRODUCT_UNIT.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_all_stock.recordcount#">
<cfform name="stock_profile" action="#request.self#?fuseaction=report.stock_profile" method="post">
<cf_report_list_search title="#getLang('report',862)#">
    <cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
                        <cfoutput>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="product_code" id="product_code" value="#attributes.product_code#">
                                                <input type="text" name="product_cat" id="product_cat" value="#attributes.product_cat#" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','product_code','','3','200');" autocomplete="off">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=stock_profile.product_code&field_name=stock_profile.product_cat&keyword='+encodeURIComponent(document.stock_profile.product_cat.value));"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id) and len(attributes.company)>#attributes.company_id#</cfif>">
                                                <input type="text" name="company" id="company" value="<cfif len(attributes.company_id) and len(attributes.company)>#attributes.company#</cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','250');" autocomplete="off">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=stock_profile.company&field_comp_id=stock_profile.company_id&select_list=2&keyword='+encodeURIComponent(document.stock_profile.company.value),'list');"></span> 
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.employee) and len(attributes.pos_code)>#attributes.pos_code#</cfif>">
                                                <input type="text" name="employee" id="employee" value="<cfif len(attributes.employee) and len(attributes.pos_code)>#attributes.employee#</cfif>" maxlength="255" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','135');" autocomplete="off">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=stock_profile.pos_code&field_code=stock_profile.pos_code&field_name=stock_profile.employee&select_list=1,9&keyword='+encodeURIComponent(document.stock_profile.employee.value),'list');"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                                        <div class="col col-12 col-xs-12">	
                                            <cf_wrkproductbrand
                                                width="120"
                                                compenent_name="getProductBrand"               
                                                boxwidth="240"
                                                boxheight="150"
                                                brand_id="#attributes.brand_id#"> 
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="price_catid" id="price_catid">
                                                <option value="-2" <cfif attributes.price_catid is '-2'>selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                                                <cfloop query="get_price_cats">
                                                    <option value="#price_catid#" <cfif get_price_cats.price_catid is attributes.price_catid> selected</cfif>>#price_cat#</option>
                                                </cfloop>
                                            </select>  
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='44019.Ürün'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="product_id" id="product_id" value="<cfif len(attributes.product_name) and len(attributes.product_id)><cfoutput>#attributes.product_id#</cfoutput></cfif>">
                                                <input type="text" name="product_name" id="product_name" value="<cfoutput>#attributes.product_name#</cfoutput>" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','225');" autocomplete="off">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=stock_profile.product_id&field_name=stock_profile.product_name&keyword='+encodeURIComponent(document.stock_profile.product_name.value),'list');"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
                                        <div class="col col-12 col-xs-12">
                                            <cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
                                                SELECT * FROM STOCKS_LOCATION <cfif x_show_pasive_departments eq 0>WHERE STATUS = 1</cfif>
                                            </cfquery>
                                            <input type="hidden" value="" name="dept_name" id="dept_name">				
                                            <select name="department_id" id="department_id" multiple>
                                            <cfloop query="get_department">
                                                <optgroup label="#department_head#">
                                                <cfquery name="GET_LOCATION" dbtype="query">
                                                    SELECT LOCATION_ID,COMMENT FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = #get_department.department_id[currentrow]#
                                                </cfquery>
                                                <cfif get_location.recordcount>
                                                    <cfloop from="1" to="#get_location.recordcount#" index="s">
                                                        <option value="#department_id#-#get_location.location_id[s]#" <cfif listfind(attributes.department_id,'#department_id#-#get_location.location_id[s]#',',')>selected</cfif>>&nbsp;&nbsp;#get_location.comment[s]#</option>
                                                    </cfloop>
                                                </cfif>
                                                </optgroup>					  
                                            </cfloop> 
                                            </select>    
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no ='97.Liste'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="list_type" id="list_type" multiple>
                                                <option value="7" <cfif listfind(attributes.list_type,7)>selected</cfif>><cf_get_lang dictionary_id='36857.Satılabilir Stok'></option>
                                                <option value="1" <cfif listfind(attributes.list_type,1)>selected</cfif>><cf_get_lang dictionary_id='40218.Alınan/Verilen Sipariş'></option>
                                                <option value="2" <cfif listfind(attributes.list_type,2)>selected</cfif>><cf_get_lang dictionary_id='40037.Üretim Emirleri'></option>
                                                <option value="5" <cfif listfind(attributes.list_type,5)>selected</cfif>><cf_get_lang dictionary_id='40219.Depolararası Sevk-İthal Mal Girişi'></option>
                                                <option value="3" <cfif listfind(attributes.list_type,3)>selected</cfif>><cf_get_lang dictionary_id='40220.Satış Yapamaz Lokasyonlar'></option>
                                                <option value="8" <cfif listfind(attributes.list_type,8)>selected</cfif>><cf_get_lang dictionary_id='40545.Satış Yapılamaz Lokasyonlardaki Rezerveler'></option>
                                                <option value="4" <cfif listfind(attributes.list_type,4)>selected</cfif>>3.<cf_get_lang dictionary_id='40221.Parti Kurumlara Ait Stok'></option>
                                                <option value="6" <cfif listfind(attributes.list_type,6)>selected</cfif>><cf_get_lang dictionary_id='32526.Alış Fiyatı'></option>
                                                <option value="9" <cfif listfind(attributes.list_type,9)>selected</cfif>><cf_get_lang dictionary_id='32763.Satış Fiyatı'></option>
                                                <option value="10" <cfif listfind(attributes.list_type,10)>selected</cfif>><cf_get_lang dictionary_id='30114.Hacim'><cf_get_lang dictionary_id='57989.ve'><cf_get_lang dictionary_id='29784.Ağırlık'></option>
                                            </select>        
                                        </div>
                                    </div>
                                </div>
                            </div>                          
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="product_status" id="product_status">
                                                <option value="" <cfif attributes.product_status eq ''>selected</cfif>>
                                                    <cf_get_lang dictionary_id='57708.Tümü'>
                                                </option>
                                                <option value="1" <cfif attributes.product_status eq 1>selected</cfif>>
                                                    <cf_get_lang dictionary_id='57493.Aktif'>
                                                </option>
                                                <option value="0" <cfif attributes.product_status eq 0>selected</cfif>>
                                                    <cf_get_lang dictionary_id='57494.Pasif'>
                                                </option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38885.Hacim Birimi'></label>
                                        <div class="col col-12 col-xs-12">
                                        <select name="volume_unit" id="volume_unit" style="width:120px;">
                                            <option value="1" <cfif attributes.volume_unit eq 1>selected</cfif>>cm3</option>
                                            <option value="2" <cfif attributes.volume_unit eq 2>selected</cfif>>dm3</option>
                                            <option value="3" <cfif attributes.volume_unit eq 3>selected</cfif>>m3</option>
                                        </select>   
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38940.Ağırlık Birimi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="weight_unit" id="weight_unit">
                                                <option value="1" <cfif attributes.weight_unit eq 1>selected</cfif>><cf_get_lang dictionary_id='37188.Kg'></option>
                                                <option value="2" <cfif attributes.weight_unit eq 2>selected</cfif>><cf_get_lang dictionary_id='39507.Ton'></option>
                                            </select> 
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12" id="strategy1" <cfif not isdefined("attributes.is_strategy")>style="display:none;"</cfif>><cf_get_lang dictionary_id='38832.Strateji Durumu'></label>
                                        <div class="col col-12 col-xs-12" id="strategy2" <cfif not isdefined("attributes.is_strategy")>style="display:none;"</cfif> >
                                        <select name="strategy_status" id="strategy_status" style="width:120px;">
                                            <option value="" <cfif attributes.strategy_status eq ''>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                            <option value="1" <cfif attributes.strategy_status eq 1>selected</cfif>><cf_get_lang dictionary_id='38830.Stratejisi Olanlar'></option>
                                            <option value="2" <cfif attributes.strategy_status eq 2>selected</cfif>><cf_get_lang dictionary_id='38831.Stratejisi Olmayanlar'></option>
                                        </select>    
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="col col-12 col-xs-12"> 
                                            <label><cf_get_lang dictionary_id='40475.Lokasyon Bazında Grupla'><input type="checkbox" name="is_location_group" id="is_location_group" onclick="kontrol_group(3);" value="" <cfif isdefined("attributes.is_location_group")>checked</cfif>></label>
                                            <label><cf_get_lang dictionary_id='40223.Sıfır Stok Getirme'><input type="checkbox" name="is_zero_stock" id="is_zero_stock" value="" <cfif isdefined("attributes.is_zero_stock")>checked</cfif>></label>
                                            <label><cf_get_lang dictionary_id='40598.Şube Bazında Grupla'><input type="checkbox" name="is_branch_group" id="is_branch_group" onclick="kontrol_group(1);" value="" <cfif isdefined("attributes.is_branch_group")>checked</cfif>></label>
                                            <label><cf_get_lang dictionary_id='38816.Fiyat Listesinde Olanları Getir'><input type="checkbox" name="is_price_list" id="is_price_list" value="" <cfif isdefined("attributes.is_price_list")>checked</cfif>></label>
                                            <label><cf_get_lang dictionary_id='40216.Raf Bazında Grupla'><input type="checkbox" name="is_shelf_group" id="is_shelf_group" onclick="kontrol_group(2);" value="" <cfif isdefined("attributes.is_shelf_group")>checked</cfif>></label>
                                            <label><cf_get_lang dictionary_id='40214.Strateji Getir'><input type="checkbox" name="is_strategy" id="is_strategy" onclick="change_strategy();" value="" <cfif isdefined("attributes.is_strategy")>checked</cfif>></label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </cfoutput>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
						<div class="ReportContentFooter">
                        <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='43958.Kayıt Sayısı Hatalı'></cfsavecontent>
                        <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                        <cfelse>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </cfif>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
                        <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
                        <cf_wrk_report_search_button search_function='kontrol_form()' insert_info='#message#' button_type='1' is_excel='1'>    
                        </div>
                    </div>
                </div>
            </div>			
    </cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined('is_form_submitted') and isdefined('attributes.is_excel') and attributes.is_excel eq 1>
            <cfset filename="stock_profile#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
            <cfheader name="Expires" value="#Now()#">
            <cfcontent type="application/vnd.msexcel;charset=utf-8">
            <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
            <meta http-equiv="content-type" content="text/plain; charset=utf-8">
			<cfset type_ = 1>
			<cfset attributes.startrow=1>
			<cfset attributes.maxrows=get_all_stock.recordcount>			
		<cfelse>
			<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_form_submitted") >
    <cf_report_list>
			 <thead>
			<cfif not isdefined("attributes.is_branch_group") and not isdefined("attributes.is_shelf_group") and not isdefined("attributes.is_location_group")>
                <tr>
                    <th width="150" nowrap><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                    <th width="120" nowrap><cf_get_lang dictionary_id='57633.Barkod'></th>
                    <th width="120" nowrap>
                    <cf_get_lang dictionary_id='57789.Özel Kod'></th>
                    <th width="150" nowrap><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                    <th width="100" nowrap style="text-align:center;"><cf_get_lang dictionary_id='57636.Birim'></th>
					<cfif x_show_second_unit>
                        <th width="100" nowrap style="text-align:center;">2. <cf_get_lang dictionary_id='57636.Birim'></th>
                    </cfif>
                    <th nowrap><cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                    <cfif x_show_second_unit>
                        <th nowrap>2. Birim <cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                    </cfif>
                    <cfif listfind(attributes.list_type,10)>
                        <th nowrap><cf_get_lang dictionary_id='30114.Hacim'></th>
                        <th nowrap><cf_get_lang dictionary_id='29784.Ağırlık'></th>
                    </cfif>
                    <cfif listfind(attributes.list_type,7)>
                        <th nowrap><cf_get_lang dictionary_id='36857.Satılabilir Stok'></th>
                        <cfif listfind(attributes.list_type,10)>
                            <th nowrap><cf_get_lang dictionary_id='30114.Hacim'></th>
                            <th nowrap><cf_get_lang dictionary_id='29784.Ağırlık'></th>
                        </cfif>
                    </cfif>
                    <cfif listfind(attributes.list_type,1)>
                        <th nowrap><cf_get_lang dictionary_id='40224.Alınan Sipariş'><br/>(<cf_get_lang dictionary_id='40225.Reserve'>)</th>
                        <th nowrap><cf_get_lang dictionary_id='33419.Verilen Siparişler'><br/>(<cf_get_lang dictionary_id='58119.Beklenen'>)</th>
                    </cfif>
                    <cfif listfind(attributes.list_type,2)>
                        <th nowrap><cf_get_lang dictionary_id='40037.Üretim Emirleri'><br/>(<cf_get_lang dictionary_id='40225.Reserve'>)</th>
                        <th nowrap><cf_get_lang dictionary_id='40037.Üretim Emirleri'><br/>(<cf_get_lang dictionary_id='58119.Beklenen'>)</th>
                    </cfif>
                    <cfif listfind(attributes.list_type,5)>
                        <th nowrap><cf_get_lang dictionary_id='45377.Depolararası Sevk'><br/><cf_get_lang dictionary_id='29588.İthal Mal Girişi'></th>
                    </cfif>
                    <cfif listfind(attributes.list_type,3)>
                        <th nowrap><cf_get_lang dictionary_id='40228.Satış Yapılamaz'><br/><cf_get_lang dictionary_id='45221.Lokasyonlar'></th>
                    </cfif>
                    <cfif listfind(attributes.list_type,8)>
                        <th nowrap><cf_get_lang dictionary_id='40228.Satış Yapılamaz'><br/><cf_get_lang dictionary_id='45221.Lokasyonlar'><br/>(<cf_get_lang dictionary_id='33419.Verilen Siparişler'>-<cf_get_lang dictionary_id='58119.Beklenen'>)</th>
                    </cfif>
                    <cfif listfind(attributes.list_type,4)>
                        <th nowrap>3.<cf_get_lang dictionary_id='40221.Parti Kurumlara Ait Stok'></th>
                    </cfif>
                    <cfif listfind(attributes.list_type,6)>
                        <th nowrap><cf_get_lang dictionary_id='37818.Standart Alış Fiyatı'></th>
                        <th><cf_get_lang dictionary_id='34434.Para Br.'></th>
                    </cfif>
                    <cfif listfind(attributes.list_type,9)>
                        <th nowrap><cf_get_lang dictionary_id='40231.Fiyat Listesindeki'><br/><cf_get_lang dictionary_id='32763.Satış Fiyatı'></th>
                        <th><cf_get_lang dictionary_id='34434.Para Br.'></th>
                    </cfif>
                    <cfif isdefined("attributes.is_strategy")>
                        <th nowrap><cf_get_lang dictionary_id='37674.Minimum Stok'></th>
                        <th nowrap><cf_get_lang dictionary_id='37672.Maksimum Stok'></th>
                        <th nowrap><cf_get_lang dictionary_id='58882.Bloke Stok'></th>
                        <th nowrap><cf_get_lang dictionary_id='37673.Yeniden Sipariş Noktası'></th>
                        <th nowrap><cf_get_lang dictionary_id='37675.Minimum Sipariş Miktarı'></th>
                        <th nowrap><cf_get_lang dictionary_id='38826.Maximum Sipariş Miktarı'></th>
                        <th nowrap><cf_get_lang dictionary_id='38564.Sipariş Miktarı'></th>
                        <th nowrap width="90"><cf_get_lang dictionary_id='57756.Durum'></th>
                        <th nowrap width="90"><cf_get_lang dictionary_id='37667.Strateji Türü'></th>
                    </cfif>
                </tr>
			</cfif>
            </thead>                   
				<cfif isdefined("attributes.is_branch_group")>
					<cfquery name="GET_BRANCH" datasource="#DSN2#">
							SELECT
                            SUM(REAL_STOCK) REAL_STOCK,
                            SUM(SALEABLE_STOCK) SALEABLE_STOCK,
                            PRODUCT_ID,
                            STOCK_ID,
                            BRANCH_ID,
                            ISNULL(BRANCH_NAME,0) BRANCH_NAME
                        FROM
                        (
                        SELECT
                            GSL.REAL_STOCK,
                            GSL.SALEABLE_STOCK,
                            GSL.PRODUCT_ID,
                            GSL.STOCK_ID,
                            (SELECT B.BRANCH_ID FROM #dsn_alias#.DEPARTMENT D,#dsn_alias#.BRANCH B WHERE B.BRANCH_ID=D.BRANCH_ID AND D.DEPARTMENT_ID = GSL.DEPARTMENT_ID) AS BRANCH_ID,
                            (SELECT B.BRANCH_NAME FROM #dsn_alias#.DEPARTMENT D,#dsn_alias#.BRANCH B WHERE B.BRANCH_ID=D.BRANCH_ID AND D.DEPARTMENT_ID = GSL.DEPARTMENT_ID) AS BRANCH_NAME
                        FROM
                            GET_STOCK_LAST_LOCATION GSL
                            <cfif is_stock_table>
                            ,#dsn3_alias#.STOCKS S
                            </cfif>
                            , ####GetStockProfile gsp
                                <cfif isDefined("attributes.is_strategy")>
                                    LEFT JOIN ####TStocStrategy GS_STRATEGY ON   gsp.STOCK_ID   = GS_STRATEGY.STOCK_ID
                                </cfif>                                
                               
                        WHERE
                            1 = 1
                          	AND GSL.STOCK_ID = gsp.STOCK_ID 
                                
                                <cfif isDefined("attributes.is_strategy")>
                                    AND GS_STRATEGY.STOCK_ID IS NULL
                                </cfif>
                            <cfif len(attributes.product_id) and len(attributes.product_name)>
                                AND GSL.PRODUCT_ID = #attributes.product_id#
                            </cfif>
                            <cfif len(attributes.department_id)>
                                AND((
                                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                    (GSL.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND GSL.LOCATION_ID = #listlast(dept_i,'-')#)
                                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                </cfloop>)
                                OR 
                                GSL.DEPARTMENT_ID = -1)
                            <cfelse>                     
                            	AND GSL.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.BRANCH B,#dsn_alias#.DEPARTMENT D WHERE	B.COMPANY_ID = #session.ep.company_id# AND B.BRANCH_ID = D.BRANCH_ID AND D.IS_STORE <> 2 AND		
															B.BRANCH_ID IN(SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#))
                               	                          
                            </cfif>
                            <cfif is_stock_table>
                                AND GSL.PRODUCT_ID=S.PRODUCT_ID
                                AND GSL.STOCK_ID=S.STOCK_ID
                                AND GSL.REAL_STOCK <> 0
                                <cfif len(attributes.company_id) and len(attributes.company)>
                                    AND S.COMPANY_ID = #attributes.company_id#
                                </cfif>
                                <cfif len(attributes.pos_code) and len(attributes.employee)>
                                    AND S.PRODUCT_MANAGER = #attributes.pos_code#
                                </cfif>
                                <cfif len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
                                    AND S.BRAND_ID = #attributes.brand_id# 
                                </cfif>	
                                <cfif len(attributes.product_code) and len(attributes.product_cat)>
                                    AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                </cfif>
                            </cfif>
                        )T1
                        GROUP BY
                            PRODUCT_ID,
                            STOCK_ID,
                            BRANCH_ID,
                            BRANCH_NAME
                      
					</cfquery>
					<cfset branch_list=listdeleteduplicates(valuelist(GET_BRANCH.BRANCH_NAME,';'),';')>
                    <cfset branch_id_list=listdeleteduplicates(valuelist(GET_BRANCH.BRANCH_ID,';'),';')>                
                    <thead>
                    <cfoutput>
                        <tr>
                            <th width="150"></th>
                            <th width="120"></th>
                            <th width="150"></th>
                            <th width="120"></th>
                            <th width="100"></th>
                            <cfif x_show_second_unit>
                            <th width="100"></th>
                            </cfif>
                         
                            <cfloop list="#branch_list#" index="branch_index" delimiters=";">
                                <cfif listfind(attributes.list_type,7)>
                                    <cfset colspan= 2>
                                    <cfif x_show_second_unit><cfset colspan= 3></cfif>
                                <cfelse>
                                    <cfset colspan= 1>
                                    <cfif x_show_second_unit><cfset colspan= 2></cfif>
                                </cfif>
                                <th colspan="#colspan#" style="text-align:center;" nowrap><cfoutput>#branch_index#</cfoutput></th>
                            </cfloop>
                            <cfif listfind(attributes.list_type,7)>
                                <cfset colspan= 2>
                                <cfif x_show_second_unit><cfset colspan= 3></cfif>
                            <cfelse>
                                <cfset colspan= 1>
                                <cfif x_show_second_unit><cfset colspan= 2></cfif>
                            </cfif>
                            <th colspan="#colspan#" style="text-align:center;"><cf_get_lang dictionary_id='40236.Ürün Toplam'></th>
                        </tr>
                        <tr>
                            <th width="150" nowrap><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                            <th width="120" nowrap><cf_get_lang dictionary_id='57633.Barkod'></th>
                            <th width="120" nowrap><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                            <th width="150" nowrap><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                            <th width="100" nowrap style="text-align:center;"><cf_get_lang dictionary_id='57636.Birim'></th>
                            <cfif x_show_second_unit>
                                <th width="100" nowrap style="text-align:center;">2. <cf_get_lang dictionary_id='57636.Birim'></th>
                            </cfif>
                     
                            <cfloop list="#branch_list#" index="branch_index" delimiters=";">
                                <th nowrap style="text-align:center;"><cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                                <cfif x_show_second_unit>
                                    <th width="100" nowrap style="text-align:center;">2. <cf_get_lang dictionary_id='57636.Birim'> <cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                                </cfif>
                                <cfif listfind(attributes.list_type,7)>
                                    <th nowrap style="text-align:center;"><cf_get_lang dictionary_id='36857.Satılabilir Stok'></th>
                                </cfif>
                            </cfloop>
                            <th nowrap style="text-align:center;"><cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                            <cfif x_show_second_unit>
                                <th width="100" nowrap style="text-align:center;">2. <cf_get_lang dictionary_id='57636.Birim'> <cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                            </cfif>
                            <cfif listfind(attributes.list_type,7)>
                                <th nowrap style="text-align:center;"><cf_get_lang dictionary_id='36857.Satılabilir Stok'></th>
                            </cfif>
                        </tr>
                    </cfoutput>
                	</thead>
                    <cfif GET_ALL_STOCK.recordcount> 
                    <tbody>
						<cfoutput query="GET_ALL_STOCK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">                       
                            <cfset satir_toplam = 0>
                            <cfset satir_toplam_sale = 0>
                            <tr>
                                <td><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >#STOCK_CODE#&nbsp; <cfelse><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#" >#STOCK_CODE#</a></cfif></td>
                                <td>#BARCOD#</td>
                                <td>#STOCK_CODE_2#</td>
                                <td><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >#PROD_NAME#<cfelse><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" >#PROD_NAME#</a></cfif></td>
                                <td style="text-align:center;">
                                    <cfif len(product_unit_id)>
                                        #MAIN_UNIT#
                                    </cfif>
                                </td>
                                <cfif x_show_second_unit>
                                	<td style="text-align:center;">
                                    	#replace(get_all_stock.UNIT2,";","","all")# 
                                    </td>
                                </cfif>
                                <cfloop list="#branch_id_list#" index="i" delimiters=";">
                                	<cfquery name="get_branch_" dbtype="query">
                                        select * from GET_BRANCH where stock_id = #GET_ALL_STOCK.stock_id# and BRANCH_ID = #i#
                                    </cfquery>                                   
                                    <td style="text-align:right;" format="numericexcel">
                                        <cfif isdefined("get_branch_.REAL_STOCK") and len(get_branch_.REAL_STOCK)>
                                            #TLFormat(get_branch_.REAL_STOCK,session.ep.our_company_info.rate_round_num)#
                                            <cfset satir_toplam = satir_toplam + get_branch_.REAL_STOCK>
                                        <cfelse>
                                            #TLFormat(0,session.ep.our_company_info.rate_round_num)#
                                        </cfif>
                                    </td>
                                    <cfif x_show_second_unit>
                                        <td style="text-align:right;" format="numericexcel">
                                        	<cfif isdefined("get_branch_.REAL_STOCK1") and len(get_branch_.REAL_STOCK) and len(get_all_stock.multiplier)>
												<cfset 'amount_satir_new_#get_all_stock.PRODUCT_GROUPBY_ID#' =  REAL_STOCK/wrk_round(get_all_stock.multiplier,8,1)>
                                                #TLFormat(evaluate('amount_satir_new_#get_all_stock.PRODUCT_GROUPBY_ID#'),4)#
                                            </cfif>
                                        </td>
                                    </cfif>
                                    <cfif listfind(attributes.list_type,7)>
                                        <td style="text-align:right;" format="numericexcel">
                                            <cfif isdefined("get_branch_.SALEABLE_STOCK") and len(get_branch_.SALEABLE_STOCK)>
                                                #TLFormat(get_branch_.SALEABLE_STOCK,session.ep.our_company_info.rate_round_num)#
                                                <cfset satir_toplam_sale = satir_toplam_sale + get_branch_.SALEABLE_STOCK>
                                            <cfelse>
                                                #TLFormat(0,session.ep.our_company_info.rate_round_num)#
                                            </cfif>
                                        </td>
                                    </cfif>
                                </cfloop>
                                <td style="text-align:right;" format="numericexcel">#TLFormat(satir_toplam,session.ep.our_company_info.rate_round_num)#</td>
                                <cfif x_show_second_unit>
                                	<td style="text-align:right;" format="numericexcel">
                                   		<cfif isdefined('satir_toplam') and len(satir_toplam) and len(get_all_stock.multiplier)>
											<cfset 'amount_satir_toplam_new_#get_all_stock.PRODUCT_GROUPBY_ID#' = satir_toplam/wrk_round(get_all_stock.multiplier,8,1)>
                                            #TLFormat(evaluate('amount_satir_toplam_new_#get_all_stock.PRODUCT_GROUPBY_ID#'),4)#
                                        </cfif>
                                    </td>
                                </cfif>
								<cfif listfind(attributes.list_type,7)>
                                    <td style="text-align:right;" format="numericexcel">#TLFormat(satir_toplam_sale,session.ep.our_company_info.rate_round_num)#</td>
                                </cfif>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tbody>
                            <tr>
                                <td colspan="35" height="20"><cfif isdefined('is_form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                            </tr>
                        </tbody>
                    </cfif>	
				<cfelseif isdefined("attributes.is_location_group")>
					<cfquery name="GET_DEP_LOCATION" datasource="#DSN#">
						SELECT 
							STOCKS_LOCATION.COMMENT,
                            STOCKS_LOCATION.LOCATION_ID,
                            STOCKS_LOCATION.DEPARTMENT_ID
						FROM 
							STOCKS_LOCATION,
                            DEPARTMENT
						WHERE
                        	DEPARTMENT.DEPARTMENT_ID = STOCKS_LOCATION.DEPARTMENT_ID AND
							STATUS=1

							<cfif len(attributes.department_id)>
								AND((
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
									(STOCKS_LOCATION.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND LOCATION_ID = #listlast(dept_i,'-')#)
									<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>))	
							</cfif>
                        ORDER BY
                        DEPARTMENT_HEAD
					</cfquery>
                    <cfset location_list=valuelist(GET_DEP_LOCATION.COMMENT,';')>
					<thead>
                    <cfoutput>
                        <tr>
                            <th width="150"></th>
                            <th width="120"></th>
                            <th width="150"></th>
                            <th width="120"></th>
                            <th width="100"></th>
                            <cfif x_show_second_unit>
                            <th width="100"></th>
                            </cfif>
                            <cfloop list="#location_list#" index="loc_index" delimiters=";">
                                <cfif listfind(attributes.list_type,7)>
                                    <cfset colspan= 2>
                                    <cfif x_show_second_unit><cfset colspan= 3></cfif>
                                <cfelse>
                                    <cfset colspan=1>
                                    <cfif x_show_second_unit><cfset colspan= 2></cfif>
                                </cfif>
                                <th colspan="#colspan#" style="text-align:center;" nowrap><cfoutput>#loc_index#</cfoutput></th>
                            </cfloop>
                            <cfif listfind(attributes.list_type,7)>
                                <cfset colspan= 2>
                                <cfif x_show_second_unit><cfset colspan= 3></cfif>
                            <cfelse>
                                <cfset colspan= 1>
                                <cfif x_show_second_unit><cfset colspan= 2></cfif>
                            </cfif>						
                            <th colspan="#colspan#" style="text-align:center;"><cf_get_lang dictionary_id='40236.Ürün Toplam'></th>
                        </tr>
                        <tr>
                            <th width="150" nowrap><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                            <th width="120" nowrap><cf_get_lang dictionary_id='57633.Barkod'></th>
                            <th width="120" nowrap><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                            <th width="150" nowrap><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                            <th width="100" nowrap style="text-align:center;"><cf_get_lang dictionary_id='57636.Birim'></th>
							<cfif x_show_second_unit>
                                <th width="100" nowrap style="text-align:center;">2. <cf_get_lang dictionary_id='57636.Birim'></th>
                            </cfif>
                            <cfloop list="#location_list#" index="loc_index" delimiters=";">
                                <th nowrap style="text-align:center;"><cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                                <cfif x_show_second_unit>
                                    <th width="100" nowrap style="text-align:center;">2. <cf_get_lang dictionary_id='57636.Birim'> <cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                                </cfif>
                                <cfif listfind(attributes.list_type,7)>
                                    <th nowrap style="text-align:center;"><cf_get_lang dictionary_id='36857.Satılabilir Stok'></th>
                                </cfif>
                            </cfloop>
                            <th nowrap style="text-align:center;"><cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                            <cfif x_show_second_unit>
                                <th width="100" nowrap style="text-align:center;">2. <cf_get_lang dictionary_id='57636.Birim'> <cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                            </cfif>
                            <cfif listfind(attributes.list_type,7)>
                                <th nowrap style="text-align:center;"><cf_get_lang dictionary_id='36857.Satılabilir Stok'></th>
                            </cfif>
                        </tr>
                    </cfoutput>
                    </thead>
                     <cfif GET_ALL_STOCK.recordcount> 
                    <tbody>
					<cfoutput query="GET_ALL_STOCK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset satir_toplam = 0>
						<cfset satir_toplam_sale = 0>
						<tr>
							<td><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >#STOCK_CODE#<cfelse><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#" >#STOCK_CODE#</a></cfif></td>
							<td>#BARCOD#</td>
                            <td>#STOCK_CODE_2#</td>
							<td><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >#PROD_NAME#<cfelse><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" >#PROD_NAME#</a></cfif></td>
							<td style="text-align:center;">
								<cfif len(product_unit_id)>
									#MAIN_UNIT#
								</cfif>
							</td>
                            <cfif x_show_second_unit>
                            	<td style="text-align:center;">#replace(get_all_stock.UNIT2,";","","all")# </td>
                            </cfif>
							<cfloop query="GET_DEP_LOCATION">
                             <cfquery name="GET_DEP" datasource="#DSN2#">
                                 SELECT
                                        SUM(REAL_STOCK) REAL_STOCK,
                                        SUM(SALEABLE_STOCK) SALEABLE_STOCK,
                                        PRODUCT_ID,
                                        STOCK_ID,
                                        DEPARTMENT_ID,
                                        LOCATION_ID,
                                        LOCATION_NAME
                                    FROM
                                    (
                                    SELECT
                                        GSL.REAL_STOCK,
                                        GSL.SALEABLE_STOCK,
                                        GSL.PRODUCT_ID,
                                        GSL.STOCK_ID,
                                        GSL.DEPARTMENT_ID,
                                        GSL.LOCATION_ID AS LOCATION_ID,
                                        (SELECT SL.COMMENT FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.LOCATION_ID=GSL.LOCATION_ID AND SL.DEPARTMENT_ID = GSL.DEPARTMENT_ID) AS LOCATION_NAME
                                    FROM
                                        GET_STOCK_LAST_LOCATION GSL
                                        <cfif is_stock_table>
                                        ,#dsn3_alias#.STOCKS S
                                        </cfif>
                                    WHERE
                                        1 = 1
                                        <cfif len(attributes.product_id) and len(attributes.product_name)>
                                            AND GSL.PRODUCT_ID = #attributes.product_id#
                                        </cfif>
                                            AND
                                                GSL.DEPARTMENT_ID = #GET_DEP_LOCATION.DEPARTMENT_ID#
                                                AND GSL.LOCATION_ID = #GET_DEP_LOCATION.LOCATION_ID#
                                                AND GSL.PRODUCT_ID = #get_all_stock.product_id#
                                        <cfif is_stock_table>
                                            AND GSL.PRODUCT_ID=S.PRODUCT_ID
                                            AND GSL.STOCK_ID=S.STOCK_ID
                                            <cfif len(attributes.company_id) and len(attributes.company)>
                                                AND S.COMPANY_ID = #attributes.company_id#
                                            </cfif>
                                            <cfif len(attributes.pos_code) and len(attributes.employee)>
                                                AND S.PRODUCT_MANAGER = #attributes.pos_code#
                                            </cfif>
                                            <cfif len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
                                                AND S.BRAND_ID = #attributes.brand_id# 
                                            </cfif>	
                                            <cfif len(attributes.product_code) and len(attributes.product_cat)>
                                                AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                            </cfif>
                                        </cfif>
                                    )T1
                                    GROUP BY
                                        PRODUCT_ID,
                                        STOCK_ID,
                                        DEPARTMENT_ID,
                                        LOCATION_ID,
                                        LOCATION_NAME
                         <!---       )  AS GET_LOCATION_AMOUNT ON GET_ALL_STOCK.PRODUCT_GROUPBY_ID = GET_LOCATION_AMOUNT.STOCK_ID 
                                    AND  GET_ALL_STOCK.DEPARTMENT_ID = GET_LOCATION_AMOUNT.DEPARTMENT_ID
                                    AND  GET_ALL_STOCK.LOCATION_ID = GET_LOCATION_AMOUNT.LOCATION_ID--->
                                </cfquery>
								<td style="text-align:right;" format="numericexcel">
									<cfif len(GET_DEP.REAL_STOCK)>
										#TLFormat(GET_DEP.REAL_STOCK,session.ep.our_company_info.rate_round_num)#
										<cfset satir_toplam = satir_toplam + GET_DEP.REAL_STOCK>
									<cfelse>
										#TLFormat(0,session.ep.our_company_info.rate_round_num)#
									</cfif>
								</td>
								<cfif x_show_second_unit>
                                    <td style="text-align:right;" format="numericexcel">
                                    	<cfif len(GET_DEP.REAL_STOCK) and len(get_all_stock.multiplier)>
											<cfset 'amount_satir_new_#get_all_stock.PRODUCT_GROUPBY_ID#' = GET_DEP.REAL_STOCK/wrk_round(get_all_stock.multiplier,8,1)>
                                            #TLFormat(evaluate('amount_satir_new_#get_all_stock.PRODUCT_GROUPBY_ID#'),4)#
                                        </cfif>
                                    </td>
                                </cfif>
								<cfif listfind(attributes.list_type,7)>
									<td style="text-align:right;" format="numericexcel">
										<cfif isdefined("GET_DEP.SALEABLE_STOCK") and len(GET_DEP.SALEABLE_STOCK)>
											#TLFormat(GET_DEP.SALEABLE_STOCK,session.ep.our_company_info.rate_round_num)#
											<cfset satir_toplam_sale = satir_toplam_sale + GET_DEP.SALEABLE_STOCK>
										<cfelse>
											#TLFormat(0,session.ep.our_company_info.rate_round_num)#
										</cfif>
									</td>
								</cfif>
							</cfloop>
							<td style="text-align:right;" format="numericexcel">#TLFormat(satir_toplam,session.ep.our_company_info.rate_round_num)#</td>
							<cfif x_show_second_unit>
                            	<td style="text-align:right;" format="numericexcel">
                                	<cfif isdefined("satir_toplam") and len(evaluate("satir_toplam")) and len(get_all_stock.multiplier)>
										<cfset 'amount_new_total_#get_all_stock.PRODUCT_GROUPBY_ID#' = satir_toplam/wrk_round(get_all_stock.multiplier,8,1)>
                                        #TLFormat(evaluate('amount_new_total_#get_all_stock.PRODUCT_GROUPBY_ID#'),session.ep.our_company_info.rate_round_num)#
                                    </cfif>
                                </td>
                            </cfif>
							<cfif listfind(attributes.list_type,7)>
								<td style="text-align:right;" format="numericexcel">#TLFormat(satir_toplam_sale,session.ep.our_company_info.rate_round_num)#</td>
							</cfif>
						</tr>
					</cfoutput>
                    </tbody>
                    <cfelse>
                        <tbody>
                            <tr>
                                <td colspan="35" height="20"><cfif isdefined('is_form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                            </tr>
                        </tbody>
                    </cfif>	
				<cfelseif isdefined("attributes.is_shelf_group")>
					<cfquery name="GET_SHELF" datasource="#DSN3#">
						SELECT 
							SHELF_CODE,PRODUCT_PLACE_ID 
						FROM 
							PRODUCT_PLACE
						WHERE
							PLACE_STATUS=1
							<cfif len(attributes.department_id)>
								AND STORE_ID IN 
								(
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
									#listfirst(dept_i,'-')#
									<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1>,</cfif>
								</cfloop>
								)
							</cfif>
						ORDER BY 
							SHELF_CODE
					</cfquery>
					<cfset shelf_list=valuelist(GET_SHELF.SHELF_CODE,';')>
					<cfset shelf_id_list=valuelist(GET_SHELF.PRODUCT_PLACE_ID,';')>
                    <thead>
                    <cfoutput>
                        <tr>
                            <th width="150"></th>
                            <th width="120"></th>
                            <th width="150"></th>
                            <th width="150"></th>
                            <th width="100"></th>
                            <cfif x_show_second_unit>
                            <th width="100"></th>
                            </cfif>
                            <cfloop list="#shelf_list#" index="shelf_index" delimiters=";">
                                <cfif listfind(attributes.list_type,7)>
                                    <cfset colspan= 2>
                                    <cfif x_show_second_unit><cfset colspan= 3></cfif>
                                <cfelse>
                                    <cfset colspan= 1>
                                    <cfif x_show_second_unit><cfset colspan= 2></cfif>
                                </cfif>						
                                <th colspan="#colspan#" style="text-align:center;" nowrap><cfoutput>#shelf_index#</cfoutput></th>
                            </cfloop>
                            <cfif listfind(attributes.list_type,7)>
                                <cfset colspan= 2>
                                <cfif x_show_second_unit><cfset colspan= 3></cfif>
                            <cfelse>
                                <cfset colspan= 1>
                                <cfif x_show_second_unit><cfset colspan= 2></cfif>
                            </cfif>								
                            <th colspan="#colspan#" style="text-align:center;"><cf_get_lang dictionary_id='40236.Ürün Toplam'></th>
                        </tr>
                        <tr>
                            <th width="150" nowrap><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                            <th width="120" nowrap><cf_get_lang dictionary_id='57633.Barkod'></th>
                            <th width="120" nowrap><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                            <th width="150" nowrap><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                            <th width="100" nowrap style="text-align:center;"><cf_get_lang dictionary_id='57636.Birim'></th>
							<cfif x_show_second_unit>
                            	<th width="100" nowrap style="text-align:center;">2. <cf_get_lang dictionary_id='57636.Birim'></th>
                            </cfif>
                            <cfloop list="#shelf_list#" index="shelf_index" delimiters=";">
                                <th nowrap style="text-align:center;"><cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                                <cfif x_show_second_unit>
                                    <th width="100" nowrap style="text-align:center;">2. <cf_get_lang dictionary_id='57636.Birim'></th>
                                </cfif>
                                <cfif listfind(attributes.list_type,7)>
                                    <th nowrap style="text-align:center;"><cf_get_lang dictionary_id='36857.Satılabilir Stok'></th>
                                </cfif>
                            </cfloop>
                            <th nowrap style="text-align:center;"><cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                            <cfif x_show_second_unit>
                                <th nowrap style="text-align:center;">2. <cf_get_lang dictionary_id='57636.Birim'> <cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                            </cfif>
                            <cfif listfind(attributes.list_type,7)>
                                <th nowrap style="text-align:center;"><cf_get_lang dictionary_id='36857.Satılabilir Stok'></th>
                            </cfif>
                        </tr>
                    </cfoutput>
                    </thead>
                    <cfif GET_ALL_STOCK.recordcount>
                    <tbody>
					<cfoutput query="GET_ALL_STOCK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset satir_toplam = 0>
						<cfset satir_toplam_sale = 0>
						<tr>
							<td><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >#STOCK_CODE#<cfelse><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#" >#STOCK_CODE#</a></cfif></td>
							<td>#BARCOD#</td>
                            <td>#STOCK_CODE_2#</td>
							<td><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >#PROD_NAME#<cfelse><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" >#PROD_NAME#</a></cfif></td>
							<td style="text-align:center;">
								<cfif len(product_unit_id)>
									#MAIN_UNIT#
								</cfif>
							</td>
                            <cfif x_show_second_unit>
                            	<td style="text-align:center;">#replace(get_all_stock.UNIT2,";","","all")# </td>
                            </cfif>
							<cfloop list="#shelf_id_list#" index="shelf_index" delimiters=";">
                            <cfquery name="GET_SHELF_STOCK" datasource="#DSN2#">
                            	SELECT
                                    SUM(REAL_STOCK) REAL_STOCK,
                                    SUM(SALEABLE_STOCK) SALEABLE_STOCK,
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    SHELF_NUMBER
                                FROM
                                (
                                    SELECT
                                        GSL.REAL_STOCK,
                                        GSL.SALEABLE_STOCK,
                                        GSL.PRODUCT_ID,
                                        GSL.STOCK_ID,
                                        GSL.SHELF_NUMBER AS SHELF_NUMBER
                                    FROM
                                        GET_STOCK_LAST_SHELF GSL,
                                        #dsn3_alias#.PRODUCT_PLACE PP
                                        <cfif is_stock_table>
                                        ,#dsn3_alias#.STOCKS S
                                        </cfif>
                                    WHERE
                                        GSL.SHELF_NUMBER = PP.PRODUCT_PLACE_ID
                                        AND PP.PRODUCT_PLACE_ID = #shelf_index#
                                        AND GSL.PRODUCT_ID = #get_all_stock.product_id#
                                        <cfif len(attributes.product_id) and len(attributes.product_name)>
                                            AND GSL.PRODUCT_ID = #attributes.product_id#
                                        </cfif>
                                        <cfif is_stock_table>
                                            AND GSL.PRODUCT_ID=S.PRODUCT_ID
                                            AND GSL.STOCK_ID=S.STOCK_ID
                                            <cfif len(attributes.company_id) and len(attributes.company)>
                                                AND S.COMPANY_ID = #attributes.company_id#
                                            </cfif>
                                            <cfif len(attributes.pos_code) and len(attributes.employee)>
                                                AND S.PRODUCT_MANAGER = #attributes.pos_code#
                                            </cfif>
                                            <cfif len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
                                                AND S.BRAND_ID = #attributes.brand_id# 
                                            </cfif>	
                                            <cfif len(attributes.product_code) and len(attributes.product_cat)>
                                                AND S.STOCK_CODE LIKE '#attributes.product_code#%'
                                            </cfif>
                                        </cfif>
                                )T1
                                GROUP BY
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    SHELF_NUMBER
                                </cfquery>
								<td style="text-align:right;" format="numericexcel">
									<cfif  len(GET_SHELF_STOCK.REAL_STOCK)>
										#TLFormat(GET_SHELF_STOCK.REAL_STOCK,session.ep.our_company_info.rate_round_num)#
										<cfset satir_toplam = satir_toplam + GET_SHELF_STOCK.REAL_STOCK>
									<cfelse>
										#TLFormat(0,session.ep.our_company_info.rate_round_num)#
									</cfif>
								</td>
                                <cfif x_show_second_unit>
                                    <td style="text-align:center;">
                                    	<cfif  len(GET_SHELF_STOCK.REAL_STOCK) and len(get_all_stock.multiplier)>
											<cfset 'amount_new_satir_#get_all_stock.PRODUCT_GROUPBY_ID#' = GET_SHELF_STOCK.REAL_STOCK/wrk_round(get_all_stock.multiplier,8,1)>
                                            #TLFormat(evaluate('amount_new_satir_#get_all_stock.PRODUCT_GROUPBY_ID#'),session.ep.our_company_info.rate_round_num)#
                                        </cfif>
                                    </td>
                                </cfif>
								<cfif listfind(attributes.list_type,7)>
									<td style="text-align:right;" format="numericexcel">
										<cfif isdefined("GET_SHELF_STOCK.SALEABLE_STOCK") and len(GET_SHELF_STOCK.SALEABLE_STOCK)>
											#TLFormat(GET_SHELF_STOCK.SALEABLE_STOCK,session.ep.our_company_info.rate_round_num)#
											<cfset satir_toplam_sale = satir_toplam_sale + GET_SHELF_STOCK.SALEABLE_STOCK>
										<cfelse>
											#TLFormat(0,session.ep.our_company_info.rate_round_num)#
										</cfif>
									</td>
								</cfif>
							</cfloop>
							<td style="text-align:right;" format="numericexcel">#TLFormat(satir_toplam,session.ep.our_company_info.rate_round_num)#</td>
							<cfif x_show_second_unit>
                            	<td style="text-align:right;" format="numericexcel">
                                	<cfif isdefined("satir_toplam") and len(evaluate("satir_toplam")) and len(get_all_stock.multiplier)>
										<cfset 'amount_new_total_#get_all_stock.PRODUCT_GROUPBY_ID#' = satir_toplam/wrk_round(get_all_stock.multiplier,8,1)>
                                        #TLFormat(evaluate('amount_new_total_#get_all_stock.PRODUCT_GROUPBY_ID#'),session.ep.our_company_info.rate_round_num)#
                                    </cfif>
                                </td>
                            </cfif>
							<cfif listfind(attributes.list_type,7)>
								<td style="text-align:right;" format="numericexcel">#TLFormat(satir_toplam_sale,session.ep.our_company_info.rate_round_num)#</td>
							</cfif>
						</tr>
					</cfoutput>
                    </tbody>
                    <cfelse>
                        <tbody>
                            <tr>
                                <td colspan="35" height="20"><cfif isdefined('is_form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                            </tr>
                        </tbody>
                    </cfif>	
				<cfelse>
					<cfset total_value_1 = 0>
					<cfset total_weight_1 = 0>
					<cfset total_value_2 = 0>
					<cfset total_weight_2 = 0>
					<cfset col_num = 0>
					<cfif listfind(attributes.list_type,1)>
						<cfset col_num = col_num + 2>
					</cfif>	
					<cfif listfind(attributes.list_type,2)>
						<cfset col_num = col_num + 2>
					</cfif>		
					<cfif listfind(attributes.list_type,5)>
						<cfset col_num = col_num + 1>
					</cfif>	
					<cfif listfind(attributes.list_type,3)>	
						<cfset col_num = col_num + 1>
					</cfif>	
					<cfif listfind(attributes.list_type,8)>	
						<cfset col_num = col_num + 1>
					</cfif>	
					<cfif listfind(attributes.list_type,4)>
						<cfset col_num = col_num + 1>
					</cfif>	
					<cfif listfind(attributes.list_type,6)>
						<cfset col_num = col_num + 2>
					</cfif>
					<cfif listfind(attributes.list_type,9)>
						<cfset col_num = col_num + 2>
					</cfif>
					<cfif isdefined("attributes.is_strategy")>
						<cfset col_num = col_num + 9>
					</cfif>
					<cfif attributes.page neq 1 and listfind(attributes.list_type,10)>
						<cfoutput query="GET_ALL_STOCK" startrow="1" maxrows="#attributes.startrow-1#">
							<cfset a = 0>
							<cfset b = 0>
							<cfset h = 0>
							<cfset volume_value = 0>
							<cfset weight_value = 0>
							<cfif len(DIMENTION) and listlen(DIMENTION,'*') eq 3>
								<cfset a = listgetat(DIMENTION,1,'*')>
								<cfset b = listgetat(DIMENTION,2,'*')>
								<cfset h = listgetat(DIMENTION,3,'*')>
							</cfif>
							<cfif attributes.volume_unit eq 1>
								<cfset volume_value = a*b*h>
							<cfelseif attributes.volume_unit eq 2>
								<cfset volume_value = a*b*h / 1000>
							<cfelseif attributes.volume_unit eq 3>
								<cfset volume_value = a*b*h / 1000000>
							</cfif>
							<cfif len(WEIGHT)>
								<cfif attributes.weight_unit eq 1>
									<cfset weight_value = WEIGHT>
								<cfelseif attributes.weight_unit eq 2>
									<cfset weight_value = WEIGHT/1000>
								</cfif>
							<cfelse>
								<cfset weight_value = 0>
							</cfif>
							<cfset total_value_1 = total_value_1 + (volume_value*REAL_STOCK)>
							<cfset total_weight_1 = total_weight_1 + (weight_value*REAL_STOCK)>
							<cfif listfind(attributes.list_type,7)>
								<cfset total_value_2 = total_value_2 + (volume_value*SALEABLE_STOCK)>
								<cfset total_weight_2 = total_weight_2 + (weight_value*SALEABLE_STOCK)>
							</cfif>
						</cfoutput>				  
					</cfif>
                    <cfif GET_ALL_STOCK.recordcount>
                        <tbody>
                        <cfoutput query="GET_ALL_STOCK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfif listfind(attributes.list_type,10)>
                                <cfset a = 0>
                                <cfset b = 0>
                                <cfset h = 0>
                                <cfset volume_value = 0>
                                <cfset weight_value = 0>
                                <cfif isdefined("get_all_stock.DIMENTION") and len(DIMENTION) and listlen(DIMENTION,'*') eq 3>
                                    <cfset a = listgetat(DIMENTION,1,'*')>
                                    <cfset b = listgetat(DIMENTION,2,'*')>
                                    <cfset h = listgetat(DIMENTION,3,'*')>
                                </cfif>
                                <cfif attributes.volume_unit eq 1>
                                    <cfset volume_value = a*b*h>
                                <cfelseif attributes.volume_unit eq 2>
                                    <cfset volume_value = a*b*h / 1000>
                                <cfelseif attributes.volume_unit eq 3>
                                    <cfset volume_value = a*b*h / 1000000>
                                </cfif>
                                <cfif isdefined("get_all_stock.WEIGHT") and len(WEIGHT)>
                                    <cfif attributes.weight_unit eq 1>
                                        <cfset weight_value = WEIGHT>
                                    <cfelseif attributes.weight_unit eq 2>
                                        <cfset weight_value = WEIGHT/1000>
                                    </cfif>
                                <cfelse>
                                    <cfset weight_value = 0>
                                </cfif>
                            </cfif>
                            <tr>
                                <td><cfif attributes.is_excel eq 1>#STOCK_CODE#<cfelse><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#" >#STOCK_CODE#</a></cfif></td>
                                <td>#BARCOD#</td>
                                <td>#STOCK_CODE_2#</td>
                                <td><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >#PROD_NAME#<cfelse><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" >#PROD_NAME#</a></cfif></td>
                                <td style="text-align:center;">
                                    <cfif len(product_unit_id)>
                                        #MAIN_UNIT#
                                    </cfif>
                                </td>
                                <cfif x_show_second_unit>
                                    <td style="text-align:center;">
                                        #replace(get_all_stock.UNIT2,";","","all")# 
                                    </td>
                                </cfif>
                                <td style="text-align:right;" format="numericexcel">#TLFormat(REAL_STOCK,session.ep.our_company_info.rate_round_num)#</td>
                                <cfif x_show_second_unit>
                                    <td style="text-align:right;" nowrap format="numericexcel">
                                        <cfif isdefined("REAL_STOCK") and len(REAL_STOCK) and len(get_all_stock.multiplier)>
                                            <cfset 'amount_new_total_#get_all_stock.PRODUCT_GROUPBY_ID#' = REAL_STOCK/wrk_round(get_all_stock.multiplier,8,1)>
                                            #TLFormat(evaluate('amount_new_total_#get_all_stock.PRODUCT_GROUPBY_ID#'),session.ep.our_company_info.rate_round_num)#
                                        </cfif>
                                    </td>
                                </cfif>
                                <cfif listfind(attributes.list_type,10)>
                                    <td style="text-align:right;" nowrap format="numericexcel">
                                        #tlformat(volume_value*REAL_STOCK,session.ep.our_company_info.rate_round_num)#
                                    </td>
                                    <td style="text-align:right;" nowrap format="numericexcel">
                                        #tlformat(weight_value*REAL_STOCK,session.ep.our_company_info.rate_round_num)#
                                    </td>
                                    <cfset total_value_1 = total_value_1 + (volume_value*REAL_STOCK)>
                                    <cfset total_weight_1 = total_weight_1 + (weight_value*REAL_STOCK)>
                                </cfif>
                                <cfif listfind(attributes.list_type,7)>
                                    <td style="text-align:right;" format="numericexcel">#TLFormat(SALEABLE_STOCK,session.ep.our_company_info.rate_round_num)#</td>
                                    <cfif listfind(attributes.list_type,10)>
                                        <td nowrap style="text-align:right;" format="numericexcel">
                                            #tlformat(volume_value*SALEABLE_STOCK,session.ep.our_company_info.rate_round_num)#
                                        </td>
                                        <td style="text-align:right;" nowrap format="numericexcel">
                                            #tlformat(weight_value*SALEABLE_STOCK,session.ep.our_company_info.rate_round_num)#
                                        </td>
                                        <cfset total_value_2 = total_value_2 + (volume_value*SALEABLE_STOCK)>
                                        <cfset total_weight_2 = total_weight_2 + (weight_value*SALEABLE_STOCK)>
                                    </cfif>
                                </cfif>
                                <cfif listfind(attributes.list_type,1)>
                                    <td style="text-align:right;" format="numericexcel"><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >#TLFormat(RESERVE_SALE_ORDER_STOCK,session.ep.our_company_info.rate_round_num)#<cfelse><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_reserved_orders&taken=1&sid=#stock_id#','medium');">#TLFormat(RESERVE_SALE_ORDER_STOCK,session.ep.our_company_info.rate_round_num)#</a></cfif></td>
                                    <td style="text-align:right;" format="numericexcel"><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >#TLFormat(RESERVE_PURCHASE_ORDER_STOCK,session.ep.our_company_info.rate_round_num)#<cfelse><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#product_id#','medium');">#TLFormat(RESERVE_PURCHASE_ORDER_STOCK,session.ep.our_company_info.rate_round_num)#</a></cfif></td>
                                </cfif>	
                                <cfif listfind(attributes.list_type,2)>
                                    <td style="text-align:right;" format="numericexcel"><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >#AmountFormat(RESERVED_PROD_STOCK,session.ep.our_company_info.rate_round_num)#<cfelse><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_reserved_production_orders&type=2&pid=#product_id#','medium');">#AmountFormat(RESERVED_PROD_STOCK,session.ep.our_company_info.rate_round_num)#</a></cfif></td>
                                    <td style="text-align:right;" format="numericexcel"><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >#AmountFormat(PURCHASE_PROD_STOCK,session.ep.our_company_info.rate_round_num)#<cfelse><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_reserved_production_orders&type=1&pid=#product_id#','medium');">#AmountFormat(PURCHASE_PROD_STOCK,session.ep.our_company_info.rate_round_num)#</a></cfif></td>
                                </cfif>		
                                <cfif listfind(attributes.list_type,5)>
                                    <td style="text-align:right;" format="numericexcel">
                                    <cfif isdefined("GET_ALL_STOCK.STOCK_SHIP_AMOUNT")and len(STOCK_SHIP_AMOUNT)>
                                        #TLFormat(STOCK_SHIP_AMOUNT,session.ep.our_company_info.rate_round_num)#
                                    <cfelse>
                                        #TLFormat(0,session.ep.our_company_info.rate_round_num)#
                                    </cfif>
                                    </td>
                                </cfif>	
                                <cfif listfind(attributes.list_type,3)>	
                                    <td style="text-align:right;" format="numericexcel">#TLFormat(NOSALE_STOCK,session.ep.our_company_info.rate_round_num)#</td>
                                </cfif>	
                                <cfif listfind(attributes.list_type,8)>	
                                    <td style="text-align:right;" format="numericexcel">#TLFormat(NOSALE_RESERVED_STOCK,session.ep.our_company_info.rate_round_num)#</td>
                                </cfif>	
                                <cfif listfind(attributes.list_type,4)>
                                    <td style="text-align:right;" format="numericexcel">#TLFormat(BELONGTO_INSTITUTION_STOCK,session.ep.our_company_info.rate_round_num)#</td>
                                </cfif>	
                                <cfif listfind(attributes.list_type,6)>
                                    <td style="text-align:right;" format="numericexcel">
                                    <cfif isdefined("GET_ALL_STOCK.PRICE") and len(PRICE) and  isdefined("GET_ALL_STOCK.MONEY") and len(MONEY)>
                                        #TLFormat(PRICE,session.ep.our_company_info.rate_round_num)#
                                    <cfelse>
                                        #TLFormat(0,session.ep.our_company_info.rate_round_num)#
                                    </cfif>
                                    </td>
                                    <cfif  len(PRICE) and  len(MONEY)>
                                        <td style="text-align:center;">#MONEY#</td>
                                    <cfelse>
                                        <cfif type_ eq 1>
                                            <td></td>									
                                        <cfelse>
                                            <td>&nbsp;</td>									
                                        </cfif>
                                    </cfif>
                                </cfif>
                                <cfif listfind(attributes.list_type,9)>
                                    <td style="text-align:right;" format="numericexcel">
                                        <cfif isdefined("GET_ALL_STOCK.PRICE") and len(PRICE) and isdefined("GET_ALL_STOCK.MONEY") and len(MONEY) and attributes.price_catid eq '-2' >
                                            <cfif PURCHASESALES eq 1>
                                                #TLFormat(PRICE,session.ep.our_company_info.rate_round_num)#
                        <cfelseif PURCHASESALES eq 0>
                                                #TLFormat(PRICE1,session.ep.our_company_info.rate_round_num)#                                            
                                            </cfif>
                                        <cfelseif attributes.price_catid neq '-2'>
                                            #TLFormat(PRICE1,session.ep.our_company_info.rate_round_num)#
                                        <cfelse>
                                            #TLFormat(0,session.ep.our_company_info.rate_round_num)#
                                        </cfif>
                                    </td>
                                    <cfif isdefined("GET_ALL_STOCK.PRICE") and len(PRICE) and isdefined("GET_ALL_STOCK.MONEY") and len(MONEY) and attributes.price_catid eq '-2' >
                                        <cfif PURCHASESALES eq 0>
                                            <td style="text-align:center;">#MONEY1#</td>
                                        <cfelseif PURCHASESALES eq 1>
                                            <td style="text-align:center;">#PRICE#</td>
                                        </cfif>
                                    <cfelseif attributes.price_catid neq '-2'>
                                        <td style="text-align:center;">#TLFormat(MONEY1,session.ep.our_company_info.rate_round_num)#</td>	                                       
                                    <cfelse>
                                        <cfif type_ eq 1>
                                            <td></td>									
                                        <cfelse>
                                            <td>&nbsp;</td>									
                                        </cfif>
                                    </cfif>
                                </cfif>
                                <cfif isdefined("attributes.is_strategy")>
                                    <td style="text-align:right;" format="numericexcel">#TLFormat(MINIMUM_STOCK,session.ep.our_company_info.rate_round_num)#</td>
                                    <td style="text-align:right;" format="numericexcel">#TLFormat(MAXIMUM_STOCK,session.ep.our_company_info.rate_round_num)#</td>
                                    <td style="text-align:right;" format="numericexcel">#TLFormat(BLOCK_STOCK_VALUE,session.ep.our_company_info.rate_round_num)#</td>
                                    <td style="text-align:right;" format="numericexcel">#TLFormat(REPEAT_STOCK_VALUE,session.ep.our_company_info.rate_round_num)#</td>
                                    <td style="text-align:right;" format="numericexcel">#TLFormat(MINIMUM_ORDER_STOCK_VALUE,session.ep.our_company_info.rate_round_num)#</td>
                                    <td style="text-align:right;" format="numericexcel">#TLFormat(MAXIMUM_ORDER_STOCK_VALUE,session.ep.our_company_info.rate_round_num)#</td>
                                    <td style="text-align:right;" format="numericexcel">
                                        <cfif len(MINIMUM_STOCK) and len(REPEAT_STOCK_VALUE)>
                                            <cfset order_value = MINIMUM_STOCK-SALEABLE_STOCK>
                                        <cfelseif len(MINIMUM_STOCK)>
                                            <cfset order_value = MINIMUM_STOCK>
                                        <cfelse>
                                            <cfset order_value = 0>
                                        </cfif>
                                        <cfif order_value gt 0>
                                            #TLFormat(MINIMUM_STOCK-SALEABLE_STOCK,session.ep.our_company_info.rate_round_num)#
                                        <cfelse>
                                            #TLFormat(0,session.ep.our_company_info.rate_round_num)#
                                        </cfif>
                                    </td>
                                    <cfset stock_strategy_status = "Tanımsız">
                                    <cfif len(saleable_stock)>
                                    <cfif saleable_stock lte 0>
                                            <cfif isdefined("attributes.is_excel") and len(attributes.is_excel)>
                                                <cfset stock_strategy_status = 'Stok Yok'>
                                            <cfelse>
                                                <cfset stock_strategy_status = '<font color="ff0000">Stok Yok</font>'>
                                            </cfif>
                                    <cfelseif isdefined('MINIMUM_STOCK') and len(MINIMUM_STOCK) and saleable_stock lte MINIMUM_STOCK>
                                            <cfif isdefined("attributes.is_excel") and len(attributes.is_excel)>
                                                <cfset stock_strategy_status = 'Yetersiz Stok'>
                                            <cfelse>
                                                <cfset stock_strategy_status = '<font color="ff0000">Yetersiz Stok</font>'>
                                            </cfif>
                                    <cfelseif isdefined('REPEAT_STOCK_VALUE') and isdefined('MINIMUM_STOCK') and len(REPEAT_STOCK_VALUE) and len(MINIMUM_STOCK) and saleable_stock lte REPEAT_STOCK_VALUE and saleable_stock gt MINIMUM_STOCK>
                                            <cfif isdefined("attributes.is_excel") and len(attributes.is_excel)>
                                                <cfset stock_strategy_status = 'Sipariş Ver'>
                                            <cfelse>
                                                <cfset stock_strategy_status = '<font color="009933">Sipariş Ver</font>'>
                                            </cfif>
                                    <cfelseif isdefined('MAXIMUM_STOCK') and isdefined('REPEAT_STOCK_VALUE') and len(MAXIMUM_STOCK) and len(REPEAT_STOCK_VALUE) and saleable_stock lt MAXIMUM_STOCK and saleable_stock gt REPEAT_STOCK_VALUE >
                                            <cfif isdefined("attributes.is_excel") and len(attributes.is_excel)>
                                                <cfset stock_strategy_status = 'Yeterli Stok'>
                                            <cfelse>
                                                <cfset stock_strategy_status = "Yeterli Stok">
                                            </cfif>
                                    <cfelseif isdefined('MAXIMUM_STOCK') and len(MAXIMUM_STOCK) and saleable_stock gte MAXIMUM_STOCK>
                                            <cfif isdefined("attributes.is_excel") and len(attributes.is_excel)>
                                                <cfset stock_strategy_status = 'Fazla Stok'>
                                            <cfelse>
                                                <cfset stock_strategy_status = '<font color="6666FF">Fazla Stok</font>'>
                                            </cfif>
                                    </cfif>
                                    <td>#stock_strategy_status#</td>
                                </cfif>
                                <td nowrap>
                                        <cfif isdefined("get_all_stock.STOCK_ACTION_MESSAGE") and len(STOCK_ACTION_MESSAGE)>
                                            #STOCK_ACTION_MESSAGE#
                                        </cfif>
                                </td>
                                </cfif>
                            </tr>
                        </cfoutput>
                        </tbody>
                        <cfif listfind(attributes.list_type,10)>
                            <tfoot>
                                <cfoutput>
                                    <tr>
                                        <cfif x_show_second_unit>
                                            <cfset cols_ = 8>
                                        <cfelse>
                                            <cfset cols_ = 6>
                                        </cfif>
                                        <td colspan="#cols_#" style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='31130.Sayfa Toplam'></td>
                                        <td style="text-align:right;" nowrap class="txtbold" format="numericexcel">
                                            #TLFormat(total_value_1,session.ep.our_company_info.rate_round_num)# 
                                            <cfif attributes.volume_unit eq 1>cm3<cfelseif attributes.volume_unit eq 2>dm3<cfelse>m3</cfif>
                                        </td>
                                        <td style="text-align:right;" nowrap class="txtbold" format="numericexcel">
                                            #TLFormat(total_weight_1,session.ep.our_company_info.rate_round_num)# 
                                            <cfif attributes.weight_unit eq 1><cf_get_lang dictionary_id='37188.Kg'><cfelse><cf_get_lang dictionary_id='39507.Ton'></cfif>
                                        </td>
                                        <cfif listfind(attributes.list_type,7)>
                                            <td></td>
                                            <td style="text-align:right;" nowrap class="txtbold" format="numericexcel">
                                                #TLFormat(total_value_2,session.ep.our_company_info.rate_round_num)# 
                                                <cfif attributes.volume_unit eq 1>cm3<cfelseif attributes.volume_unit eq 2>dm3<cfelse>m3</cfif>
                                            </td>
                                            <td style="text-align:right;" nowrap class="txtbold" format="numericexcel">
                                                #TLFormat(total_weight_2,session.ep.our_company_info.rate_round_num)# 
                                                <cfif attributes.weight_unit eq 1><cf_get_lang dictionary_id='37188.Kg'><cfelse><cf_get_lang dictionary_id='39507.Ton'></cfif>
                                            </td>
                                        </cfif>
                                        <cfif col_num gt 0><td colspan="#col_num#"></td></cfif>
                                    </tr>
                                </cfoutput>
                            </tfoot>
                        </cfif>
                     <cfelse>
            	<tbody>
                    <tr>
                        <td colspan="35" height="20"><cfif isdefined('is_form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                    </tr>
                </tbody>
			</cfif>	
				</cfif>			
				
	 </cf_report_list>
		<cfset adres = "">
		<cfif GET_ALL_STOCK.recordcount and (attributes.maxrows lt attributes.totalrecords)>
			<cfset adres = "report.stock_profile&is_form_submitted=1">	
			<cfif len(attributes.company_id) and len(attributes.company)>
				<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
			</cfif>
			<cfif len(attributes.employee) and len(attributes.pos_code)>
				<cfset adres = "#adres#&pos_code=#attributes.pos_code#&employee=#attributes.employee#">
			</cfif>
			<cfif len(attributes.product_cat) and len(attributes.product_code)>
				<cfset adres = "#adres#&product_cat=#attributes.product_cat#&product_code=#attributes.product_code#">
			</cfif>
			<cfif len(attributes.product_id) and len(attributes.product_name)>
				<cfset adres = "#adres#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
			</cfif>
			<cfif len(attributes.department_id) and len(attributes.department_id)>
				<cfset adres = "#adres#&department_id=#attributes.department_id#">
			</cfif>
			<cfif len(attributes.list_type) and len(attributes.list_type)>
				<cfset adres = "#adres#&list_type=#attributes.list_type#">
			</cfif>
			<cfif len(attributes.product_status)>
				<cfset adres = "#adres#&product_status=#attributes.product_status#">
			</cfif>
			<cfif len(attributes.strategy_status)>
				<cfset adres = "#adres#&strategy_status=#attributes.strategy_status#">
			</cfif>
			<cfif len(attributes.price_catid)>
				<cfset adres = "#adres#&price_catid=#attributes.price_catid#">
			</cfif>
			<cfif len(attributes.weight_unit)>
				<cfset adres = "#adres#&weight_unit=#attributes.weight_unit#">
			</cfif>
			<cfif len(attributes.volume_unit)>
				<cfset adres = "#adres#&volume_unit=#attributes.volume_unit#">
			</cfif>
			<cfif isdefined("attributes.is_shelf_group")>
				<cfset adres = "#adres#&is_shelf_group=#attributes.is_shelf_group#">
			</cfif>			
			<cfif isdefined("attributes.is_branch_group")>
				<cfset adres = "#adres#&is_branch_group=#attributes.is_branch_group#">
			</cfif>
			<cfif isdefined("attributes.is_location_group")>
				<cfset adres = "#adres#&is_location_group=#attributes.is_location_group#">
			</cfif>
			<cfif isdefined("attributes.is_strategy")>
				<cfset adres = "#adres#&is_strategy=#attributes.is_strategy#">
			</cfif>
			<cfif isdefined("attributes.is_zero_stock")>
				<cfset adres = "#adres#&is_zero_stock=#attributes.is_zero_stock#">
			</cfif>
			<cfif isdefined("attributes.is_price_list")>
				<cfset adres = "#adres#&is_price_list=#attributes.is_price_list#">
			</cfif>
			<cfif isdefined("attributes.dept_name")>
				<cfset adres = "#adres#&dept_name=#attributes.dept_name#">
			</cfif>	
                <cf_paging page="#attributes.page#" 
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#adres#">
		</cfif>
</cfif>
</cfprocessingdirective>
<script type="text/javascript">
	function kontrol_form()
	{
		var document_id = document.stock_profile.department_id.options.length;	
		var document_name = '';
		for(i=0;i<document_id;i++)
			{
				if(document.stock_profile.department_id.options[i].selected && document_name.length==0)
					document_name = document_name + list_getat(document.stock_profile.department_id.options[i].value,1,'-');
				else if(document.stock_profile.department_id.options[i].selected && ! list_find(document_name,list_getat(document.stock_profile.department_id.options[i].value,1,'-'),','))
					document_name = document_name + ',' + list_getat(document.stock_profile.department_id.options[i].value,1,'-');
			}
		document.stock_profile.dept_name.value = document_name;
		if(list_len(document_name,',') > 1 && document.stock_profile.is_strategy.checked)
		{
			alert("<cf_get_lang dictionary_id='40237.Birden Fazla Lokasyon Seçtiğinizde Genel Strateji Çalışır'>!");
			return true;
		}
		<cfif not x_multiple_location>
		if (document.stock_profile.is_location_group.checked && list_len(document_name,',') > 1)
		{
			alert("<cf_get_lang dictionary_id='38834.Lokasyon Bazında Rapor Alabilmek İçin Sadece Bir Depo Seçmelisiniz'> !");
			return false;
		}
		</cfif>
		if (document.stock_profile.is_location_group.checked && stock_profile.department_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='38835.Lokasyon Bazında Rapor Alabilmek İçin Bir Depo Seçmelisiniz'> !");
			return false;
		}
        if(document.stock_profile.is_excel.checked==false)
		{
			document.stock_profile.action="<cfoutput>#request.self#?fuseaction=report.stock_profile</cfoutput>";
			return true;
		}
		else
			document.stock_profile.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_stock_profile</cfoutput>";
	
	}
	function kontrol_group(kont)
	{
		if(kont==1)
		{
			if(document.stock_profile.is_branch_group.checked == true)
			{
				document.stock_profile.is_shelf_group.checked = false;
				document.stock_profile.is_location_group.checked = false;
			}
		}
		else if(kont==2)
		{
			if(document.stock_profile.is_shelf_group.checked == true)
			{
				document.stock_profile.is_branch_group.checked = false;
				document.stock_profile.is_location_group.checked = false;
			}
		}
		else
		{
			if(document.stock_profile.is_location_group.checked == true)
			{
				document.stock_profile.is_branch_group.checked = false;
				document.stock_profile.is_shelf_group.checked = false;
			}
		}
	}
	function change_strategy()
	{
		if(document.stock_profile.is_strategy.checked == true)
		{
			document.getElementById('strategy1').style.display = '';
			document.getElementById('strategy2').style.display = '';
			document.getElementById('strategy3').style.display = 'none';
		}
		else
		{
			document.getElementById('strategy1').style.display = 'none';
			document.getElementById('strategy2').style.display = 'none';
			document.getElementById('strategy3').style.display = '';
		}
	}
</script>
