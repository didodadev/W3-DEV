<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<!---
	by : 
	notes : İstenen üyenin,calisanin veya urunun muhasebe hesabini döndüren fonksiyonlar...
			-Bu fonksiyonlarin hepsi tek parametre ile, param ismi belirtilmeden int degerlerle kullanılır
			-Dikkat edilirse genel olarak hep donem db den çalistigimiz gorulur ve transaction sorunu olmaması için
			 donem db icinden maindb lere eriserek calisir.
	usage :
		GET_CONSUMER_PERIOD(i);
		GET_COMPANY_PERIOD(123);
		GET_EMPLOYEE_PERIOD('#some_query.some_id#');
		get_product_account(prod_id:1,period_id:1); //period_id optional verilmezse session dakini alir.
		//table_type_id: EGer Müsterinin Dovizli hesabi isteniyorsa table_type_id=1 olarak fonksiyon cagirilmalidir
	revisions : 20040304
--->
<cffunction name="GET_CONSUMER_PERIOD" output="false">
	<cfargument name="consumer_id" type="numeric" required="true">
	<cfargument name="period_id" type="numeric">
	<cfargument name="basket_money_db" type="string" default="#dsn2#">
	<cfquery name="GET_CONSUMER_ACCOUNT_CODE" datasource="#arguments.basket_money_db#">
		SELECT
			ACCOUNT_CODE
		FROM
			#dsn_alias#.CONSUMER_PERIOD
		WHERE
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
			<cfif not isDefined('arguments.period_id')>
				<cfif isDefined('session.ep')>
					AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				<cfelseif isDefined('session.pp')>
					AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
				<cfelseif isDefined('session.ww')>
					AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
				</cfif>
			<cfelse>
				AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
			</cfif>
	</cfquery>
	<cfreturn GET_CONSUMER_ACCOUNT_CODE.ACCOUNT_CODE>
</cffunction>
<cffunction name="GET_COMPANY_PERIOD" output="false">
	<cfargument name="company_id" type="numeric" required="true">
	<cfargument name="period_id" type="numeric">
	<cfargument name="basket_money_db" type="string" default="#dsn2#">
	<cfquery name="GET_COMPANY_ACCOUNT_CODE" datasource="#arguments.basket_money_db#">
		SELECT
			ACCOUNT_CODE
		FROM
			#dsn_alias#.COMPANY_PERIOD
		WHERE
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
			<cfif not isDefined('arguments.period_id')>
				<cfif isDefined('session.ep')>
					AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				<cfelseif isDefined('session.pp')>
					AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
				<cfelseif isDefined('session.ww')>
					AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
				</cfif>
			<cfelse>
				AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
			</cfif>
	</cfquery>
	<cfreturn GET_COMPANY_ACCOUNT_CODE.ACCOUNT_CODE>
</cffunction>
<cffunction name="GET_EMPLOYEE_PERIOD" output="false">
	<cfargument name="employee_id" type="numeric" required="true">
	<cfargument name="acc_type_id" type="string" default="0">
	<cfargument name="basket_money_db" type="string" default="#dsn2#">
	<cfargument name="basket_money_db_dsn3" type="string" default="#dsn3#">
	<cfargument name="period_id" type="numeric">
	<cfquery name="EMP_ACCOUNT_CODE" datasource="#arguments.basket_money_db#">
		SELECT TOP 1
			EIOP.ACCOUNT_CODE
		FROM
			#dsn_alias#.EMPLOYEES_IN_OUT EIO,
            <cfif len(arguments.acc_type_id) and arguments.acc_type_id neq 0>
                #dsn_alias#.EMPLOYEES_ACCOUNTS EIOP
            <cfelse>
                #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD EIOP
			</cfif>
		WHERE
			EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
			 <cfif len(arguments.acc_type_id) and arguments.acc_type_id neq 0>
				AND EIO.EMPLOYEE_ID = EIOP.EMPLOYEE_ID
            <cfelse>
				AND EIO.IN_OUT_ID = EIOP.IN_OUT_ID
			</cfif>
            <cfif len(arguments.acc_type_id) and arguments.acc_type_id neq 0>
				AND EIOP.ACC_TYPE_ID = #arguments.acc_type_id#
			</cfif>
			<cfif not isDefined('arguments.period_id')>
				<cfif isDefined('session.ep')>
					AND	EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				<cfelseif isDefined('session.pp')>
					AND	EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
				<cfelseif isDefined('session.ww')>
					AND	EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
				</cfif>
			<cfelse>
				AND	EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
			</cfif>
		ORDER BY
			EIO.IN_OUT_ID DESC
	</cfquery>
	<cfif (emp_account_code.recordcount eq 0 or not len(emp_account_code.account_code))>
		<cfquery name="EMP_ACCOUNT_CODE" datasource="#arguments.basket_money_db#">
			SELECT PERSONAL_ADVANCE_ACCOUNT AS ACCOUNT_CODE FROM #basket_money_db_dsn3#.SETUP_SALARY_PAYROLL_ACCOUNTS
		</cfquery>
	</cfif>
	<cfreturn EMP_ACCOUNT_CODE.ACCOUNT_CODE>
</cffunction>
<cffunction name="get_product_account" returntype="struct" output="false">
	<!--- structure olarak ürün muhasebe kodlarini döndürür --->
	<cfargument name="prod_id" required="true" type="numeric">
	<cfargument name="period_id" type="numeric">
	<cfargument name="product_account_db" type="string" default="#DSN2#">
	<cfargument name="product_alias_db" type="string" default="#dsn3_alias#">	
	<cfargument name="department_id" type="string" default="">	
	<cfargument name="location_id" type="string" default="">
	<!--- depo bazında muhasebeleştirme yapılıyorsa depodan alıyor muhasebe kodlarını --->
	<cfif len(arguments.department_id) and len(arguments.location_id) and arguments.department_id neq 0 and arguments.location_id neq 0>
		<cfquery datasource="#arguments.product_account_db#" name="get_pro_account_codes">
			SELECT 
				ACCOUNT_CODE,ACCOUNT_CODE_PUR,ACCOUNT_DISCOUNT,ACCOUNT_PRICE,ACCOUNT_PRICE_PUR,ACCOUNT_YURTDISI_PUR,
				MATERIAL_CODE,ACCOUNT_PUR_IADE,ACCOUNT_IADE,ACCOUNT_YURTDISI,ACCOUNT_DISCOUNT_PUR,SALE_PRODUCT_COST,
				PRODUCTION_COST,ACCOUNT_EXPENDITURE,ACCOUNT_LOSS,'' RECEIVED_PROGRESS_CODE,'' PROVIDED_PROGRESS_CODE,SCRAP_CODE,
                '' SALE_MANUFACTURED_COST,'' KONSINYE_SALE_CODE,SCRAP_CODE_SALE,MATERIAL_CODE_SALE,PRODUCTION_COST_SALE,
                '' KONSINYE_PUR_CODE,'' PROMOTION_CODE,
                '' OVER_COUNT, '' EXE_VAT_SALE_INVOICE
			FROM 
				#dsn_alias#.STOCKS_LOCATION_PERIOD
			WHERE
				DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
				AND	LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#">
			<cfif not (isDefined('arguments.period_id') and len(arguments.period_id))>
				<cfif isDefined('session.ep')>
					AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				<cfelseif isDefined('session.pp')>
					AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
				<cfelseif isDefined('session.ww')>
					AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
				</cfif>
			<cfelse>
				AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
			</cfif>
		</cfquery>
	<cfelse>
		<cfquery datasource="#arguments.product_account_db#" name="get_pro_account_codes">
			SELECT 
				ACCOUNT_CODE,ACCOUNT_CODE_PUR,ACCOUNT_DISCOUNT,ACCOUNT_PRICE,ACCOUNT_PRICE_PUR,ACCOUNT_YURTDISI_PUR,
				MATERIAL_CODE,ACCOUNT_PUR_IADE,ACCOUNT_IADE,ACCOUNT_YURTDISI,ACCOUNT_DISCOUNT_PUR,SALE_PRODUCT_COST,
				PRODUCTION_COST,ACCOUNT_EXPENDITURE,ACCOUNT_LOSS,RECEIVED_PROGRESS_CODE,PROVIDED_PROGRESS_CODE,SCRAP_CODE,
                SALE_MANUFACTURED_COST,KONSINYE_SALE_CODE,SCRAP_CODE_SALE,MATERIAL_CODE_SALE,PRODUCTION_COST_SALE,
                KONSINYE_PUR_CODE,PROMOTION_CODE,
                OVER_COUNT,EXE_VAT_SALE_INVOICE
			FROM 
				#arguments.product_alias_db#.PRODUCT_PERIOD
			WHERE
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prod_id#">
			<cfif not (isDefined('arguments.period_id') and len(arguments.period_id))>
				<cfif isDefined('session.ep')>
					AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				<cfelseif isDefined('session.pp')>
					AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
				<cfelseif isDefined('session.ww')>
					AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
				</cfif>
			<cfelse>
				AND	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
			</cfif>
		</cfquery>
	</cfif>
	<cfscript>
		product_account_codes = StructNew();
		product_account_codes = StructNew();
		product_account_codes.ACCOUNT_CODE = get_pro_account_codes.ACCOUNT_CODE;
		product_account_codes.ACCOUNT_CODE_PUR = get_pro_account_codes.ACCOUNT_CODE_PUR;
		product_account_codes.ACCOUNT_DISCOUNT = get_pro_account_codes.ACCOUNT_DISCOUNT;
		product_account_codes.ACCOUNT_PRICE = get_pro_account_codes.ACCOUNT_PRICE;
		product_account_codes.ACCOUNT_PRICE_PUR = get_pro_account_codes.ACCOUNT_PRICE_PUR;
		product_account_codes.ACCOUNT_PUR_IADE = get_pro_account_codes.ACCOUNT_PUR_IADE;
		product_account_codes.ACCOUNT_IADE = get_pro_account_codes.ACCOUNT_IADE;
		product_account_codes.ACCOUNT_YURTDISI = get_pro_account_codes.ACCOUNT_YURTDISI;
		product_account_codes.ACCOUNT_YURTDISI_PUR = get_pro_account_codes.ACCOUNT_YURTDISI_PUR;
		product_account_codes.ACCOUNT_DISCOUNT_PUR = get_pro_account_codes.ACCOUNT_DISCOUNT_PUR;
		product_account_codes.PRODUCTION_COST = get_pro_account_codes.PRODUCTION_COST;
		product_account_codes.MATERIAL_CODE = get_pro_account_codes.MATERIAL_CODE;
		product_account_codes.ACCOUNT_EXPENDITURE = get_pro_account_codes.ACCOUNT_EXPENDITURE;
		product_account_codes.ACCOUNT_LOSS = get_pro_account_codes.ACCOUNT_LOSS;
		product_account_codes.SALE_PRODUCT_COST = get_pro_account_codes.SALE_PRODUCT_COST;
		product_account_codes.RECEIVED_PROGRESS_CODE = get_pro_account_codes.RECEIVED_PROGRESS_CODE;
		product_account_codes.PROVIDED_PROGRESS_CODE = get_pro_account_codes.PROVIDED_PROGRESS_CODE;
		product_account_codes.SCRAP_CODE = get_pro_account_codes.SCRAP_CODE;
		product_account_codes.SALE_MANUFACTURED_COST = get_pro_account_codes.SALE_MANUFACTURED_COST;
		product_account_codes.KONSINYE_SALE_CODE = get_pro_account_codes.KONSINYE_SALE_CODE;
		product_account_codes.SCRAP_CODE_SALE = get_pro_account_codes.SCRAP_CODE_SALE;
		product_account_codes.PRODUCTION_COST_SALE = get_pro_account_codes.PRODUCTION_COST_SALE;
		product_account_codes.MATERIAL_CODE_SALE = get_pro_account_codes.MATERIAL_CODE_SALE;
		product_account_codes.KONSINYE_PUR_CODE = get_pro_account_codes.KONSINYE_PUR_CODE;
		product_account_codes.PROMOTION_CODE = get_pro_account_codes.PROMOTION_CODE;
		product_account_codes.OVER_COUNT = get_pro_account_codes.OVER_COUNT;
		product_account_codes.EXE_VAT_SALE_INVOICE = get_pro_account_codes.EXE_VAT_SALE_INVOICE;
	</cfscript>
	<cfreturn product_account_codes>
</cffunction>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
