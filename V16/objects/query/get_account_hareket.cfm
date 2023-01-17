<cfif not isdefined("db_source") ><cfset db_source = DSN2 ></cfif>
<cfif not isdefined("db_source3_alias")><cfset db_source3_alias=dsn3_alias></cfif>
<cfquery name="get_acc" datasource="#DSN2#" maxrows="1" >
	SELECT ACCOUNT_ID FROM ACCOUNT_CARD_ROWS WHERE ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
</cfquery>
<cfif not get_acc.recordcount>
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT  
			ACCOUNT_CODE 
		FROM 
			#dsn_alias#.COMPANY_PERIOD 
		WHERE 
			ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#"> AND 
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#">
	</cfquery>
</cfif>
<cfif not get_acc.recordcount>
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT  
			ACCOUNT_CODE 
		FROM 
			#dsn_alias#.CONSUMER_PERIOD 
		WHERE 
			ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#"> AND 
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#">
	</cfquery>
</cfif>
<cfif not get_acc.recordcount>
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT  
			ACCOUNT_CODE 
		FROM 
			#dsn3_alias#.PRODUCT_PERIOD PRODUCT_PERIOD 
		WHERE 
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
			(
			ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_CODE_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_DISCOUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_PRICE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_PUR_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_YURTDISI LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_YURTDISI_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_DISCOUNT_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_LOSS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_EXPENDITURE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR OVER_COUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR UNDER_COUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR PRODUCTION_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR HALF_PRODUCTION_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR SALE_PRODUCT_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR MATERIAL_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR KONSINYE_PUR_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR KONSINYE_SALE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR KONSINYE_SALE_NAZ_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR DIMM_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR DIMM_YANS_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR PROMOTION_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			)
	</cfquery>
</cfif>
<cfif not get_acc.recordcount> <!--- muhasebe kodu bir proje için seçilmiş mi kontrol ediliyor. --->
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT  
			ACCOUNT_CODE
		FROM 
			#dsn3_alias#.PROJECT_PERIOD PRODUCT_PERIOD 
		WHERE
			PERIOD_ID = #session.ep.period_id# AND
			(
			ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_CODE_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_DISCOUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_PRICE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_PUR_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_YURTDISI LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_YURTDISI_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_DISCOUNT_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_LOSS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR ACCOUNT_EXPENDITURE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR PRODUCTION_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR OVER_COUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR UNDER_COUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR KONSINYE_PUR_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR KONSINYE_SALE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR KONSINYE_SALE_NAZ_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR HALF_PRODUCTION_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR SALE_PRODUCT_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR MATERIAL_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR DIMM_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR DIMM_YANS_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			OR PROMOTION_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
			)
	</cfquery>
</cfif>
<!---Kdv tanımlarında kullanılıp kullanılmadığını kontrol ediyor--->
<cfif not get_acc.recordcount>
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT 
			* 
		FROM 
			SETUP_TAX 
		WHERE 
			SALE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#"> OR
			PURCHASE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#"> OR
			SALE_CODE_IADE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#"> OR
			PURCHASE_CODE_IADE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#control_account_code#">
	</cfquery>
</cfif>

