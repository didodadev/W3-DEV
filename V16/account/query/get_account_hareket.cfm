<cfif not isdefined("db_source") ><cfset db_source = DSN2 ></cfif>
<cfif not isdefined("db_source3_alias")><cfset db_source3_alias=dsn3_alias></cfif>
<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
	SELECT <cfif database_type eq "MSSQL" > TOP 1 </cfif> ACCOUNT_ID FROM ACCOUNT_CARD_ROWS WHERE ACCOUNT_ID = '#account.account_code#'
</cfquery>
<cfif not get_acc.recordcount>
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT  
			ACCOUNT_CODE 
		FROM 
			#dsn_alias#.COMPANY_PERIOD 
		WHERE 
			ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#account.account_code#"> AND 
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
			ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#account.account_code#"> AND 
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
			PERIOD_ID = #session.ep.period_id# AND
			(
			ACCOUNT_CODE LIKE '#account.account_code#'
			OR ACCOUNT_CODE_PUR LIKE '#account.account_code#'
			OR ACCOUNT_DISCOUNT LIKE '#account.account_code#'
			OR ACCOUNT_PRICE LIKE '#account.account_code#'
			OR ACCOUNT_PUR_IADE LIKE '#account.account_code#'
			OR ACCOUNT_IADE LIKE '#account.account_code#'
			OR ACCOUNT_YURTDISI LIKE '#account.account_code#'
			OR ACCOUNT_YURTDISI_PUR LIKE '#account.account_code#'
			OR ACCOUNT_DISCOUNT_PUR LIKE '#account.account_code#'
			OR ACCOUNT_LOSS LIKE '#account.account_code#'
			OR ACCOUNT_EXPENDITURE LIKE '#account.account_code#'
			OR OVER_COUNT LIKE '#account.account_code#'
			OR UNDER_COUNT LIKE '#account.account_code#'
			OR PRODUCTION_COST LIKE '#account.account_code#'
			OR HALF_PRODUCTION_COST LIKE '#account.account_code#'
			OR SALE_PRODUCT_COST LIKE '#account.account_code#'
			OR MATERIAL_CODE LIKE '#account.account_code#'
			OR KONSINYE_PUR_CODE LIKE '#account.account_code#'
			OR KONSINYE_SALE_CODE LIKE '#account.account_code#'
			OR KONSINYE_SALE_NAZ_CODE LIKE '#account.account_code#'
			OR DIMM_CODE LIKE '#account.account_code#'
			OR DIMM_YANS_CODE LIKE '#account.account_code#'
			OR PROMOTION_CODE LIKE '#account.account_code#'
			)
	</cfquery>
</cfif>
<cfif not get_acc.recordcount><!--- muhasebe kodu bir proje için seçilmiş mi kontrol ediliyor. --->
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT  
			ACCOUNT_CODE
		FROM 
			#dsn3_alias#.PROJECT_PERIOD PRODUCT_PERIOD 
		WHERE
			PERIOD_ID = #session.ep.period_id# AND
			(
			ACCOUNT_CODE LIKE '#account.account_code#'
			OR ACCOUNT_CODE_PUR LIKE '#account.account_code#'
			OR ACCOUNT_DISCOUNT LIKE '#account.account_code#'
			OR ACCOUNT_PRICE LIKE '#account.account_code#'
			OR ACCOUNT_PUR_IADE LIKE '#account.account_code#'
			OR ACCOUNT_IADE LIKE '#account.account_code#'
			OR ACCOUNT_YURTDISI LIKE '#account.account_code#'
			OR ACCOUNT_YURTDISI_PUR LIKE '#account.account_code#'
			OR ACCOUNT_DISCOUNT_PUR LIKE '#account.account_code#'
			OR ACCOUNT_LOSS LIKE '#account.account_code#'
			OR ACCOUNT_EXPENDITURE LIKE '#account.account_code#'
			OR PRODUCTION_COST LIKE '#account.account_code#'
			OR OVER_COUNT LIKE '#account.account_code#'
			OR UNDER_COUNT LIKE '#account.account_code#'
			OR KONSINYE_PUR_CODE LIKE '#account.account_code#'
			OR KONSINYE_SALE_CODE LIKE '#account.account_code#'
			OR KONSINYE_SALE_NAZ_CODE LIKE '#account.account_code#'
			OR HALF_PRODUCTION_COST LIKE '#account.account_code#'
			OR SALE_PRODUCT_COST LIKE '#account.account_code#'
			OR MATERIAL_CODE LIKE '#account.account_code#'
			OR DIMM_CODE LIKE '#account.account_code#'
			OR DIMM_YANS_CODE LIKE '#account.account_code#'
			OR PROMOTION_CODE LIKE '#account.account_code#'
			)
	</cfquery>
</cfif>
<!---Kdv tanımlarında kullanılıp kullanılmadığını kontrol ediyor--->
<cfif not get_acc.recordcount>
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT 
			SALE_CODE 
		FROM 
			SETUP_TAX 
		WHERE 
			SALE_CODE LIKE '#account.account_code#' OR
			PURCHASE_CODE = '#account.account_code#' OR
			SALE_CODE_IADE = '#account.account_code#' OR
			PURCHASE_CODE_IADE = '#account.account_code#'
	</cfquery>
</cfif>
<!---// Kdv tanımlarında kullanılıp kullanılmadığını kontrol ediyor--->

<!--- FS 20080328 bu bolumden sonrasini (7 kontrol) ben ekledim sorun olursa bildiriniz --->
<!--- Tevkifat Oranlarini kontrol ediyor --->
<cfif not get_acc.recordcount>
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT
			TEVKIFAT_CODE
		FROM
			#dsn3_alias#.SETUP_TEVKIFAT_ROW
		WHERE
			TEVKIFAT_CODE LIKE '#account.account_code#' OR
			TEVKIFAT_BEYAN_CODE LIKE '#account.account_code#' OR
			TEVKIFAT_CODE_PUR LIKE '#account.account_code#' OR
			TEVKIFAT_BEYAN_CODE_PUR LIKE '#account.account_code#'
	</cfquery>
</cfif>
<!--- // Tevkifat Oranlarini kontrol ediyor --->

<!--- OTV Oranlarini kontrol ediyor --->
<cfif not get_acc.recordcount>
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT
			ACCOUNT_CODE
		FROM
			#dsn3_alias#.SETUP_OTV
		WHERE
			PERIOD_ID = #session.ep.period_id# AND
			(
				ACCOUNT_CODE LIKE '#account.account_code#' OR
				PURCHASE_CODE LIKE '#account.account_code#' OR
				ACCOUNT_CODE_IADE LIKE '#account.account_code#' OR
				PURCHASE_CODE_IADE LIKE '#account.account_code#'
			)
	</cfquery>
</cfif>
<!--- // OTV Oranlarini kontrol ediyor --->

<!--- Fatura Satis Tanimlarini kontrol ediyor --->
<cfif not get_acc.recordcount>
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT
			A_DISC
		FROM
			#dsn3_alias#.SETUP_INVOICE
		WHERE
			A_DISC LIKE '#account.account_code#' OR
			HIZLI_F LIKE '#account.account_code#' OR
			VERILEN_D_F LIKE '#account.account_code#' OR
			FARK_GELIR LIKE '#account.account_code#' OR
			FARK_GIDER LIKE '#account.account_code#'
	</cfquery>
</cfif>
<!--- // Fatura Satis Tanimlarini kontrol ediyor --->

<!--- Fatura Alis Tanimlarini kontrol ediyor --->
<cfif not get_acc.recordcount>
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT
			A_DISC
		FROM
			#dsn3_alias#.SETUP_INVOICE_PURCHASE
		WHERE
			A_DISC LIKE '#account.account_code#' OR
			PERAKENDE_S_I_F LIKE '#account.account_code#' OR
			M_MAKBUZU LIKE '#account.account_code#' OR
			ALINAN_D_F LIKE '#account.account_code#' OR
			YUVARLAMA_GELIR LIKE '#account.account_code#' OR
			YUVARLAMA_GIDER LIKE '#account.account_code#' OR
			FARK_GELIR LIKE '#account.account_code#' OR
			FARK_GIDER LIKE '#account.account_code#'
	</cfquery>
</cfif>
<!--- // Fatura Alis Tanimlarini kontrol ediyor --->

<!--- Stopaj Oranlarini kontrol ediyor --->
<cfif not get_acc.recordcount>
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT
			STOPPAGE_ACCOUNT_CODE
		FROM
			#dsn2_alias#.SETUP_STOPPAGE_RATES
		WHERE
			STOPPAGE_ACCOUNT_CODE LIKE '#account.account_code#'
	</cfquery>
</cfif>
<!--- // Stopaj Oranlarini kontrol ediyor --->

<!--- Sube Harcama Tiplerini kontrol ediyor --->
<cfif not get_acc.recordcount>
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT
			ACCOUNT_CODE
		FROM
			#dsn_alias#.STORE_EXPENSE_TYPE
		WHERE
			ACCOUNT_CODE LIKE '#account.account_code#'
	</cfquery>
</cfif>
<!--- //Sube Harcama Tiplerini kontrol ediyor --->

<!--- Bütçe Kalemlerini kontrol ediyor --->
<cfif not get_acc.recordcount>
	<cfquery name="get_acc" datasource="#DSN2#" maxrows="1">
		SELECT
			ACCOUNT_CODE
		FROM
			#dsn2_alias#.EXPENSE_ITEMS
		WHERE
			ACCOUNT_CODE LIKE '#account.account_code#'
	</cfquery>
</cfif>