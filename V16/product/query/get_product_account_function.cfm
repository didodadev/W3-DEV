<cffunction name="get_account_code" returntype="struct">
	<cfargument name="pid">
	<cfargument name="period_id">	
	<cfargument name="type_id">
	<cfargument name="account_code_type">
	
	<cfquery name="get_acc_code" datasource="#dsn3#">
		SELECT
			AP.ACCOUNT_NAME,
			PRODUCT_PERIOD.*
		FROM
			PRODUCT_PERIOD,
			#dsn2_alias#.ACCOUNT_PLAN AP
		WHERE 
			PRODUCT_PERIOD.#account_code_type# = AP.ACCOUNT_CODE AND
			PERIOD_ID = #period_id# AND
			PRODUCT_ID = #pid#
	</cfquery>
	
	<cfif get_acc_code.recordcount>
		<cfswitch expression="#type_id#">
			<cfcase value="1"><cfset code=get_acc_code.ACCOUNT_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="2"><cfset code=get_acc_code.ACCOUNT_CODE_PUR><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="3"><cfset code=get_acc_code.ACCOUNT_DISCOUNT><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="4"><cfset code=get_acc_code.ACCOUNT_PRICE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="5"><cfset code=get_acc_code.ACCOUNT_PRICE_PUR><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="6"><cfset code=get_acc_code.ACCOUNT_PUR_IADE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="7"><cfset code=get_acc_code.ACCOUNT_IADE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="8"><cfset code=get_acc_code.ACCOUNT_YURTDISI><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="9"><cfset code=get_acc_code.ACCOUNT_DISCOUNT_PUR><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="10"><cfset code=get_acc_code.ACCOUNT_YURTDISI_PUR><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="11"><cfset code=get_acc_code.ACCOUNT_LOSS><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="12"><cfset code=get_acc_code.ACCOUNT_EXPENDITURE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="13"><cfset code=get_acc_code.OVER_COUNT><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="14"><cfset code=get_acc_code.UNDER_COUNT><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="15"><cfset code=get_acc_code.PRODUCTION_COST><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="16"><cfset code=get_acc_code.HALF_PRODUCTION_COST><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="17"><cfset code=get_acc_code.SALE_PRODUCT_COST><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="18"><cfset code=get_acc_code.MATERIAL_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="19"><cfset code=get_acc_code.KONSINYE_PUR_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="20"><cfset code=get_acc_code.KONSINYE_SALE_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="21"><cfset code=get_acc_code.KONSINYE_SALE_NAZ_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="22"><cfset code=get_acc_code.DIMM_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="23"><cfset code=get_acc_code.DIMM_YANS_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="24"><cfset code=get_acc_code.PROMOTION_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="25"><cfset code=get_acc_code.INVENTORY_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="26"><cfset code=get_acc_code.PROD_GENERAL_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="27"><cfset code=get_acc_code.PROD_LABOR_COST_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="28"><cfset code=get_acc_code.RECEIVED_PROGRESS_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="29"><cfset code=get_acc_code.PROVIDED_PROGRESS_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="30"><cfset code=get_acc_code.SALE_MANUFACTURED_COST><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="31"><cfset code=get_acc_code.SCRAP_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="32"><cfset code=get_acc_code.MATERIAL_CODE_SALE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="33"><cfset code=get_acc_code.PRODUCTION_COST_SALE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="34"><cfset code=get_acc_code.SCRAP_CODE_SALE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="35"><cfset code=get_acc_code.EXE_VAT_SALE_INVOICE><cfset name=get_acc_code.EXE_VAT_SALE_INVOICE></cfcase>

			<cfcase value="36"><cfset code=get_acc_code.NEXT_MONTH_INCOMES_ACC_CODE><cfset name=get_acc_code.NEXT_MONTH_INCOMES_ACC_CODE></cfcase>
			<cfcase value="37"><cfset code=get_acc_code.NEXT_YEAR_INCOMES_ACC_CODE><cfset name=get_acc_code.NEXT_YEAR_INCOMES_ACC_CODE></cfcase>
			<cfcase value="38"><cfset code=get_acc_code.NEXT_MONTH_EXPENSES_ACC_CODE><cfset name=get_acc_code.NEXT_MONTH_EXPENSES_ACC_CODE></cfcase>
			<cfcase value="39"><cfset code=get_acc_code.NEXT_YEAR_EXPENSES_ACC_CODE><cfset name=get_acc_code.NEXT_YEAR_EXPENSES_ACC_CODE></cfcase>
			<cfcase value="62"><cfset code=get_acc_code.ACCOUNT_EXPORTREGISTERED><cfset name=get_acc_code.ACCOUNT_EXPORTREGISTERED></cfcase>
			<cfcase value="61"><cfset code=get_acc_code.INCOMING_STOCK><cfset name=get_acc_code.INCOMING_STOCK></cfcase>
			<cfcase value="60"><cfset code=get_acc_code.OUTGOING_STOCK><cfset name=get_acc_code.OUTGOING_STOCK></cfcase>
		</cfswitch>
		<cfset acc_inf = StructNew()>
		<cfset new_struct = StructInsert(acc_inf, "acc_code", code)>
		<cfset new_struct = StructInsert(acc_inf, "acc_name", name)>
		<cfreturn acc_inf>
	<cfelse>	
		<cfset acc_inf = StructNew()>
		<cfset new_struct = StructInsert(acc_inf, "acc_code", "")>
		<cfset new_struct = StructInsert(acc_inf, "acc_name", "")>
		<cfreturn acc_inf>
	</cfif>
</cffunction>
<cffunction name="get_account_name">
	<cfargument name="code">
	<cfquery name="get_acc_name" datasource="#dsn2#">
		SELECT DISTINCT
			ACCOUNT_NAME
		FROM
			ACCOUNT_PLAN
		WHERE 
			ACCOUNT_CODE = '#code#'
	</cfquery>
	<cfif get_acc_name.recordcount>
		<cfset name = get_acc_name.ACCOUNT_NAME>
		<cfreturn name>
	<cfelse>
		<cfreturn ''>
	</cfif>
</cffunction>
