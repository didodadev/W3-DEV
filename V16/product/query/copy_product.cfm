<cfsetting showdebugoutput="yes">
<cfset attributes.is_barcode_control = 1>
<cfset attributes.barcode_require = 1>
<cfset list="',""">
<cfset list2=" , ">
<cfset max_product_id="">
<cfset attributes.PRODUCT_NAME = replacelist(attributes.PRODUCT_NAME,list,list2)><!--- ürün adına tek ve cift tirnak yazilmamali --->
<cfset attributes.PRODUCT_NAME = trim(attributes.PRODUCT_NAME)>
<cfquery name="CHECK_SAME" datasource="#DSN1#">
	SELECT PRODUCT_ID FROM PRODUCT WHERE PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_name#">
</cfquery>
<cfif check_same.recordcount>
	<cfif isdefined('attributes.use_same_product_name') and attributes.use_same_product_name eq 1>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='37925.Aynı İsimli Bir Ürün Daha Var'>!");
		</script>
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='37892.Aynı İsimli Bir Ürün Daha Var Lütfen Başka Bir Ürün İsmi Giriniz'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfset product_code = get_product_no(action_type:'product_no')>

<cfif attributes.new_stock eq 0>
    <cfset FORM.BARCOD=trim(FORM.BARCOD)>
    <cfset brand_id=trim(brand_id)>
    <cfif len(FORM.BARCOD)>
        <cfquery name="CHECK_BARCODE" datasource="#DSN1#">
            SELECT STOCK_ID FROM GET_STOCK_BARCODES_ALL WHERE BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#">
        </cfquery>
        <cfif check_barcode.recordcount>
            <cfif attributes.is_barcode_control eq 0>
                <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id='37893.Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta  Lütfen Başka Bir Barkod Giriniz'> !");
                    history.back();
                </script>
                <cfabort>
            <cfelse>
                <cfif attributes.barcode_require><!--- barcode zorunluluğu varsa kayıt işlemini yapılmaz değilse işlem uyarı verir ancak kayıt yapılır--->
                    <script type="text/javascript">
                        alert("<cf_get_lang dictionary_id='37893.Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta  Lütfen Başka Bir Barkod Giriniz'> !");
                        history.back();
                    </script>
                    <cfabort>
                <cfelse>
                    <script type="text/javascript">
                        alert("<cf_get_lang dictionary_id='37894.Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta'> !");
                    </script>
                </cfif>
           </cfif>
        </cfif>
    </cfif>
</cfif>

<cfif attributes.new_stock eq 1>
	<cfquery name="get_barcode" datasource="#dsn1#">
    	SELECT BARCODE FROM STOCKS_BARCODES WHERE STOCK_ID = #attributes.transfer_stock_id#
    </cfquery>
    <cfif get_barcode.recordcount>
    	<cfset FORM.BARCOD=trim(get_barcode.BARCODE)>
    </cfif>
</cfif>

<!--- ürün kodunu hierarchye göre oluşturalım --->
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT IS_BRAND_TO_CODE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID = #attributes.c_product_catid#
</cfquery>
<cfset form.product_code="#trim(product_code)#">
<cfset form.manufact_code="#trim(product_code)#">
<cfset form.brand_id="#brand_id#">
<cfset form.product_code_2="#trim(product_code)#">
<cfset form.product_code="#get_product_cat.hierarchy#.#product_code#">
<cfset product_code_2_format="#listlast(get_product_cat.hierarchy,'.')#.">
<!--- ürün kodu oluştu --->
<cfquery name="CHECK_SAME" datasource="#DSN1#">
	SELECT PRODUCT_CODE FROM PRODUCT WHERE PRODUCT.PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.product_code#">
</cfquery>
<cfif check_same.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='37895.Girdiğiniz Ürün Kodu Başka Bir Ürün Tarafından Kullanılmakta Lütfen Başka Bir Ürün Kodu Giriniz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfset bugun_00 = DateFormat(now(),'dd/mm/yyyy')>
<cf_date tarih='bugun_00'>
<cfif isdefined('attributes.acc_code_cat') and len(attributes.acc_code_cat)>
	<cfquery name="GET_CODES" datasource="#DSN3#">
		SELECT * FROM SETUP_PRODUCT_PERIOD_CAT WHERE PRO_CODE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_code_cat#">
	</cfquery>
	<cfquery name="GET_OTHER_PERIOD" datasource="#DSN3#">
		SELECT PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">
	</cfquery>
<cfelse>
	<cfset get_codes.recordcount = 0>
</cfif>
	<cfquery name="GET_OTHER_PERIOD" datasource="#DSN3#">
		SELECT PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">
	</cfquery>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_PRODUCT" datasource="#DSN3#">
			INSERT INTO 
			#dsn1_alias#.PRODUCT
			(
			[PRODUCT_STATUS]
           ,[G_PRODUCT_TYPE]
           ,[PRODUCT_CODE]
           ,[COMPANY_ID]
           ,[PRODUCT_CATID]
           ,[BARCOD]
           ,[PRODUCT_NAME]
           ,[PRODUCT_DETAIL]
           ,[PRODUCT_DETAIL2]
           ,[TAX]
           ,[TAX_PURCHASE]
           ,[IS_INVENTORY]
           ,[IS_PRODUCTION]
           ,[SHELF_LIFE]
           ,[IS_SALES]
           ,[IS_PURCHASE]
           ,[MANUFACT_CODE]
           ,[IS_PROTOTYPE]
           ,[PRODUCT_TREE_AMOUNT]           
           ,[IS_INTERNET]
           ,[PROD_COMPETITIVE]
           ,[PRODUCT_STAGE]
           ,[IS_TERAZI]
           ,[BRAND_ID]
           ,[IS_SERIAL_NO]
           ,[IS_ZERO_STOCK]
           ,[MIN_MARGIN]
           ,[MAX_MARGIN]
           ,[OTV]
           ,[IS_KARMA]
           ,[PRODUCT_CODE_2]
           ,[SHORT_CODE]
           ,[IS_COST]
           ,[WORK_STOCK_ID]
           ,[WORK_STOCK_AMOUNT]
           ,[IS_EXTRANET]
           ,[IS_KARMA_SEVK]
           ,[RECORD_BRANCH_ID]
           ,[RECORD_MEMBER]
           ,[RECORD_DATE]
           ,[MEMBER_TYPE]
           ,[UPDATE_DATE]
           ,[UPDATE_EMP]
           ,[UPDATE_PAR]
           ,[UPDATE_IP]
           ,[USER_FRIENDLY_URL]
           ,[PACKAGE_CONTROL_TYPE]
           ,[OTV_AMOUNT]
           ,[IS_LIMITED_STOCK]
           ,[SHORT_CODE_ID]
           ,[IS_COMMISSION]
           ,[CUSTOMS_RECIPE_CODE]
           ,[IS_ADD_XML]
           ,[IS_GIFT_CARD]
           ,[GIFT_VALID_DAY]
           ,[REF_PRODUCT_CODE]
           ,[IS_QUALITY]
           ,[PROJECT_ID]
           ,[PRODUCT_MANAGER]
           ,[SEGMENT_ID]
           ,[IS_PURCHASE_C]
           ,[IS_PURCHASE_M]
           ,[P_PROFIT]
           ,[S_PROFIT]
           ,[DUEDAY]
           ,[MAXIMUM_STOCK]
           ,[ORDER_LIMIT]
           ,[MINIMUM_STOCK]
           ,[REVENUE_RATE]
           ,[ADD_STOCK_DAY]
           ,[IS_ORDER_NO]
			)
            SELECT
			[PRODUCT_STATUS]
           ,[G_PRODUCT_TYPE]
           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.product_code#">
           ,<cfif len(FORM.COMPANY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.COMPANY_ID#"><cfelse>NULL</cfif>
           ,<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.C_PRODUCT_CATID#">
           ,<cfif len(FORM.BARCOD)><cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#"><cfelse>NULL</cfif>
           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_NAME#">
           ,[PRODUCT_DETAIL]
           ,[PRODUCT_DETAIL2]
           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tax_sat#">
           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.tax_pur#">
           ,[IS_INVENTORY]
           ,[IS_PRODUCTION]
           ,[SHELF_LIFE]
           ,[IS_SALES]
           ,[IS_PURCHASE]
           ,[MANUFACT_CODE]
           ,[IS_PROTOTYPE]
           ,[PRODUCT_TREE_AMOUNT]           
           ,[IS_INTERNET]
           ,[PROD_COMPETITIVE]
           ,[PRODUCT_STAGE]
           ,[IS_TERAZI]
           ,<cfif len(FORM.brand_id)>#FORM.brand_id#<cfelse>NULL</cfif>
           ,[IS_SERIAL_NO]
           ,[IS_ZERO_STOCK]
           ,[MIN_MARGIN]
           ,[MAX_MARGIN]
           ,[OTV]
           ,[IS_KARMA]
           ,NULL
           ,[SHORT_CODE]
           ,[IS_COST]
           ,[WORK_STOCK_ID]
           ,[WORK_STOCK_AMOUNT]
           ,[IS_EXTRANET]
           ,[IS_KARMA_SEVK]
           ,[RECORD_BRANCH_ID]
           ,#session.ep.userid#
           ,#now()#
           ,[MEMBER_TYPE]
           ,#now()#
           ,#session.ep.userid#
           ,[UPDATE_PAR]
           ,[UPDATE_IP]
           ,[USER_FRIENDLY_URL]
           ,[PACKAGE_CONTROL_TYPE]
           ,[OTV_AMOUNT]
           ,[IS_LIMITED_STOCK]
           ,[SHORT_CODE_ID]
           ,[IS_COMMISSION]
           ,[CUSTOMS_RECIPE_CODE]
           ,[IS_ADD_XML]
           ,[IS_GIFT_CARD]
           ,[GIFT_VALID_DAY]
           ,[REF_PRODUCT_CODE]
           ,[IS_QUALITY]
           ,<cfif len(FORM.project_id)>#FORM.project_id#<cfelse>NULL</cfif>
           ,[PRODUCT_MANAGER]
           ,[SEGMENT_ID]
           ,[IS_PURCHASE_C]
           ,[IS_PURCHASE_M]
           ,[P_PROFIT]
           ,[S_PROFIT]
           ,[DUEDAY]
           ,[MAXIMUM_STOCK]
           ,[ORDER_LIMIT]
           ,[MINIMUM_STOCK]
           ,[REVENUE_RATE]
           ,[ADD_STOCK_DAY]
           ,[IS_ORDER_NO]
            FROM
            #dsn1_alias#.PRODUCT
            WHERE
            PRODUCT_ID = #url.pid# 
            
        	SELECT @@IDENTITY AS MAX_PRODUCT_ID
		</cfquery>
		<cfquery name="GET_PID" datasource="#DSN3#">
			SELECT MAX(PRODUCT_ID) AS PRODUCT_ID FROM #dsn1_alias#.PRODUCT
		</cfquery>
        <cfset pid = GET_PID.PRODUCT_ID>
        <cfif isdefined("dsn_dev_alias") and len(dsn_dev_alias)>
            <cfquery name="old_kriter" datasource="#dsn3#">
                    SELECT
                    [TYPE_ID]
                ,[SUB_TYPE_ID]
                ,[SUB_TYPE_NAME]
                ,[PRODUCT_ID]
                FROM
                    #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS
                WHERE
                    PRODUCT_ID = #url.pid#
            </cfquery>
            <cfif old_kriter.recordcount gt 0>
                <cfquery name="KRITER" datasource="#dsn3#">
                    INSERT INTO #dsn_dev_alias#.[EXTRA_PRODUCT_TYPES_ROWS]
                    (
                        [TYPE_ID]
                        ,[SUB_TYPE_ID]
                        ,[SUB_TYPE_NAME]
                        ,[PRODUCT_ID]
                    )         		
                        SELECT
                            [TYPE_ID]
                        ,[SUB_TYPE_ID]
                        ,[SUB_TYPE_NAME]
                        ,#GET_PID.PRODUCT_ID#
                        FROM
                            #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS
                        WHERE
                            PRODUCT_ID = #url.pid#
                </cfquery>
            </cfif>		
        </cfif>	
				<cfquery name="ADD_MAIN_UNIT" datasource="#DSN3#">
					INSERT INTO
						PRODUCT_PERIOD
					(
						PRODUCT_ID,  
						PERIOD_ID,
						ACCOUNT_CODE,
						ACCOUNT_CODE_PUR,
						ACCOUNT_DISCOUNT,
						ACCOUNT_PRICE,
						ACCOUNT_PUR_IADE,
						ACCOUNT_IADE,
						ACCOUNT_DISCOUNT_PUR,
						ACCOUNT_YURTDISI,					
						ACCOUNT_YURTDISI_PUR,
						EXPENSE_CENTER_ID,
						EXPENSE_ITEM_ID,
						INCOME_ITEM_ID,
						EXPENSE_TEMPLATE_ID,
						ACTIVITY_TYPE_ID,
						COST_EXPENSE_CENTER_ID,
						INCOME_ACTIVITY_TYPE_ID,
						INCOME_TEMPLATE_ID,
						ACCOUNT_LOSS,
						ACCOUNT_EXPENDITURE,
						OVER_COUNT,
						UNDER_COUNT,
						PRODUCTION_COST,
						HALF_PRODUCTION_COST,
						SALE_PRODUCT_COST,
						MATERIAL_CODE,
						KONSINYE_PUR_CODE,
						KONSINYE_SALE_CODE,
						KONSINYE_SALE_NAZ_CODE,
						DIMM_CODE,
						DIMM_YANS_CODE,
						PROMOTION_CODE,
						PRODUCT_PERIOD_CAT_ID,
                        ACCOUNT_PRICE_PUR,
                        MATERIAL_CODE_SALE,
                        PRODUCTION_COST_SALE,
                        SALE_MANUFACTURED_COST,
                        PROVIDED_PROGRESS_CODE,
                        SCRAP_CODE_SALE,
                        SCRAP_CODE,
                        PROD_GENERAL_CODE,
                        PROD_LABOR_COST_CODE,
                        RECEIVED_PROGRESS_CODE,
                        INVENTORY_CAT_ID,
                        INVENTORY_CODE,
                        AMORTIZATION_METHOD_ID,
                        AMORTIZATION_TYPE_ID,
                        AMORTIZATION_EXP_CENTER_ID,
                        AMORTIZATION_EXP_ITEM_ID,
                        AMORTIZATION_CODE
					)					
						SELECT
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PID.PRODUCT_ID#">,  
						PERIOD_ID,
						ACCOUNT_CODE,
						ACCOUNT_CODE_PUR,
						ACCOUNT_DISCOUNT,
						ACCOUNT_PRICE,
						ACCOUNT_PUR_IADE,
						ACCOUNT_IADE,
						ACCOUNT_DISCOUNT_PUR,
						ACCOUNT_YURTDISI,					
						ACCOUNT_YURTDISI_PUR,
						EXPENSE_CENTER_ID,
						EXPENSE_ITEM_ID,
						INCOME_ITEM_ID,
						EXPENSE_TEMPLATE_ID,
						ACTIVITY_TYPE_ID,
						COST_EXPENSE_CENTER_ID,
						INCOME_ACTIVITY_TYPE_ID,
						INCOME_TEMPLATE_ID,
						ACCOUNT_LOSS,
						ACCOUNT_EXPENDITURE,
						OVER_COUNT,
						UNDER_COUNT,
						PRODUCTION_COST,
						HALF_PRODUCTION_COST,
						SALE_PRODUCT_COST,
						MATERIAL_CODE,
						KONSINYE_PUR_CODE,
						KONSINYE_SALE_CODE,
						KONSINYE_SALE_NAZ_CODE,
						DIMM_CODE,
						DIMM_YANS_CODE,
						PROMOTION_CODE,
						PRODUCT_PERIOD_CAT_ID,
                        ACCOUNT_PRICE_PUR,
                        MATERIAL_CODE_SALE,
                        PRODUCTION_COST_SALE,
                        SALE_MANUFACTURED_COST,
                        PROVIDED_PROGRESS_CODE,
                        SCRAP_CODE_SALE,
                        SCRAP_CODE,
                        PROD_GENERAL_CODE,
                        PROD_LABOR_COST_CODE,
                        RECEIVED_PROGRESS_CODE,
                        INVENTORY_CAT_ID,
                        INVENTORY_CODE,
                        AMORTIZATION_METHOD_ID,
                        AMORTIZATION_TYPE_ID,
                        AMORTIZATION_EXP_CENTER_ID,
                        AMORTIZATION_EXP_ITEM_ID,
                        AMORTIZATION_CODE
                    FROM 
                    	PRODUCT_PERIOD
                    WHERE
                    	PRODUCT_ID = #url.pid#						
				</cfquery>			
		<cfquery name="get_unit" datasource="#dsn3#">
        	SELECT * FROM #dsn1_alias#.PRODUCT_UNIT WHERE PRODUCT_ID =  #url.pid#
        </cfquery>
        <cfloop query="get_unit" startrow="1" endrow="#get_unit.recordcount#">
            <cfquery name="ADD_MAIN_UNIT" datasource="#DSN3#">
                INSERT INTO
                    #dsn1_alias#.PRODUCT_UNIT 
                (
                    PRODUCT_ID, 
                    PRODUCT_UNIT_STATUS, 
                    MAIN_UNIT_ID, 
                    MAIN_UNIT, 
                    UNIT_ID, 
                    ADD_UNIT,
                    DIMENTION,
                    WEIGHT,
                    VOLUME,
                    IS_MAIN,
                    IS_SHIP_UNIT,
                    RECORD_EMP,
                    RECORD_DATE,
                    MULTIPLIER,
                    DESI_VALUE,
                    UNIT_MULTIPLIER,
                    UNIT_MULTIPLIER_STATIC,
                    IS_ADD_UNIT    
                )
                    SELECT
                    #GET_PID.PRODUCT_ID#, 
                    PRODUCT_UNIT_STATUS, 
                    MAIN_UNIT_ID, 
                    MAIN_UNIT, 
                    UNIT_ID, 
                    ADD_UNIT,
                    DIMENTION,
                    WEIGHT,
                    VOLUME,
                    IS_MAIN,
                    IS_SHIP_UNIT,
                    RECORD_EMP,
                    RECORD_DATE,
                    MULTIPLIER,
                    DESI_VALUE,
                    UNIT_MULTIPLIER,
                    UNIT_MULTIPLIER_STATIC,
                    IS_ADD_UNIT    
                    FROM
                        #dsn1_alias#.PRODUCT_UNIT 
                    WHERE
                        PRODUCT_ID = #url.pid# AND PRODUCT_UNIT_ID = #get_unit.PRODUCT_UNIT_ID#                
            </cfquery>
     </cfloop>
		<cfquery name="GET_MAX_UNIT" datasource="#DSN3#">
			SELECT PRODUCT_UNIT_ID AS MAX_UNIT FROM #dsn1_alias#.PRODUCT_UNIT WHERE PRODUCT_ID = #GET_PID.PRODUCT_ID# AND IS_MAIN = 1
		</cfquery>
		<!--- purchasesales is 0 / alış fiyatı --->
	<cfquery name="ADD_STD_PRICE" datasource="#DSN3#">
			INSERT INTO
				#dsn1_alias#.PRICE_STANDART
			(
				PRODUCT_ID, 
				PURCHASESALES, 
				PRICE, 
				PRICE_KDV,
				IS_KDV,
				ROUNDING,
				MONEY,
				START_DATE,
				RECORD_DATE,
				PRICESTANDART_STATUS,
				UNIT_ID,
				RECORD_EMP
			)
			
            	SELECT 
                	#GET_PID.PRODUCT_ID#, 
                    0, 
                    <cfif form.is_tax_included_purchas eq 1>#filterNum(form.alis)-(filterNum(form.alis)/(form.tax_pur+100)*form.tax_pur)#<CFELSE>#filterNum(form.alis)#</cfif>,
                    <cfif form.is_tax_included_purchas eq 1>#filterNum(form.alis)#<cfelse>#filterNum(form.alis)*(form.tax_pur/100)+filterNum(form.alis)#</cfif>,
                    #form.is_tax_included_purchas#,
                    0,
                    '#form.MONEY_ID_AL#',
                    START_DATE,
                    #NOW()#,
                    1,
                   	#GET_MAX_UNIT.MAX_UNIT#,
                    #SESSION.EP.USERID#
                FROM
                	#dsn1_alias#.PRICE_STANDART
                WHERE
                	PRODUCT_ID = #url.pid# and PURCHASESALES =0
		</cfquery>
		<!--- purchasesales is 1 / satış fiyatı --->
		<cfquery name="ADD_STD_PRICE" datasource="#DSN3#">
			INSERT INTO 
				#dsn1_alias#.PRICE_STANDART
			(
				PRODUCT_ID, 
				PURCHASESALES, 
				PRICE, 
				PRICE_KDV,
				IS_KDV,
				ROUNDING,
				MONEY,
				START_DATE,
				RECORD_DATE,
				PRICESTANDART_STATUS,
				UNIT_ID,
				RECORD_EMP
			)
				SELECT 
                	#GET_PID.PRODUCT_ID#, 
                    1, 
                    <cfif form.is_tax_included_sales eq 1>#filterNum(form.satis)-(filterNum(form.satis)/(form.tax_sat+100)*form.tax_sat)#<CFELSE>#filterNum(form.satis)#</cfif>,
                    <cfif form.is_tax_included_sales eq 1>#filterNum(form.satis)#<cfelse>#filterNum(form.satis)*(form.tax_sat/100)+filterNum(form.satis)#</cfif>,
                    #form.is_tax_included_sales#,
                    0,
                    '#form.MONEY_ID_SAT#',
                    START_DATE,
                    #NOW()#,
                    1,
                   	#GET_MAX_UNIT.MAX_UNIT#,
                    #SESSION.EP.USERID#
                FROM
                	#dsn1_alias#.PRICE_STANDART
                WHERE
                	PRODUCT_ID = #url.pid# and PURCHASESALES =1 			
		</cfquery>	
        
        <cfquery name="ADD_PRODUCT_OUR_COMPANY_ID" datasource="#DSN3#">
			INSERT INTO 
				#dsn1_alias#.PRODUCT_OUR_COMPANY
				(
					PRODUCT_ID,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
		</cfquery>		
        <cfquery name="branch_list" datasource="#dsn3#">
			SELECT BRANCH_ID FROM  #dsn_alias#.BRANCH        
        </cfquery>
        <cfloop query="branch_list" startrow="1" endrow="#branch_list.recordcount#">
        <cfoutput>
            <cfquery name="add_product_branch_id" datasource="#DSN3#">
                INSERT INTO
                    #dsn1_alias#.PRODUCT_BRANCH
                (
                    PRODUCT_ID,
                    BRANCH_ID,
                    RECORD_EMP, 
                    RECORD_IP,
                    RECORD_DATE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
                    #branch_list.branch_id#,
                    #session.ep.userid#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
                    #now()#				
                )
            </cfquery>
        </cfoutput>
        </cfloop>
        <cfif attributes.new_stock eq 0>	
                <!--- stock kismi --->
                <cfquery name="ADD_STOCKS" datasource="#DSN3#">
                    INSERT INTO
                        #dsn1_alias#.STOCKS
                    (
                        STOCK_CODE,
                        STOCK_CODE_2,
                        PRODUCT_ID,
                        PROPERTY,
                        BARCOD,					
                        PRODUCT_UNIT_ID,
                        STOCK_STATUS,
                        MANUFACT_CODE,
                        RECORD_EMP, 
                        RECORD_IP,
                        RECORD_DATE
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_CODE#">,
                        NULL,
                        #GET_PID.PRODUCT_ID#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PRODUCT_NAME#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#">,
                        #GET_MAX_UNIT.MAX_UNIT#,
                        1,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.MANUFACT_CODE#">,
                        #session.ep.userid#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
                        #now()#
                    )
                </cfquery>		
                <cfquery name="GET_MAX_STCK" datasource="#DSN3#">
                    SELECT MAX(STOCK_ID) AS MAX_STCK FROM #dsn1_alias#.STOCKS
                </cfquery>
                <cfquery name="ADD_STOCK_BARCODE" datasource="#DSN3#">
                    INSERT INTO 
                        #dsn1_alias#.STOCKS_BARCODES
                    (
                        STOCK_ID,
                        BARCODE,
                        UNIT_ID
                    )
                    VALUES 
                    (
                        #GET_MAX_STCK.MAX_STCK#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BARCOD#">,
                        #GET_MAX_UNIT.MAX_UNIT#
                    )
                </cfquery>
				
                <cfquery name="get_my_periods" datasource="#DSN3#">
                    SELECT * FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = #SESSION.EP.COMPANY_ID#
                </cfquery>
                <cfloop query="get_my_periods">
                    <cfif database_type is "MSSQL">
                        <cfset temp_dsn = "#DSN#_#PERIOD_YEAR#_#SESSION.EP.COMPANY_ID#">
                    <cfelseif database_type is "DB2">
                        <cfset temp_dsn = "#dsn#_#SESSION.EP.COMPANY_ID#_#right(period_year,2)#">
                    </cfif>
                    <cfquery name="INSRT_STK_ROW" datasource="#DSN3#">
                        INSERT INTO #temp_dsn#.STOCKS_ROW 
                            (
                                STOCK_ID,
                                PRODUCT_ID
                            )
                        VALUES 
                            (
                                #GET_MAX_STCK.MAX_STCK#,
                                #GET_PID.PRODUCT_ID#
                            )
                    </cfquery>
                </cfloop>
                <!--- stock kismi --->
      </cfif>
	</cftransaction>
</cflock>
<cfif attributes.new_stock eq 1>
	<cfset attributes.to_product_id = GET_PID.PRODUCT_ID>
    <cfset attributes.from_stock_id = attributes.transfer_stock_id>
    <cfinclude template="copy_stock_code_ic.cfm">
</cfif>
<cflocation url="#request.self#?fuseaction=product.list_product&event=det&pid=#get_pid.product_id#" addtoken="no">