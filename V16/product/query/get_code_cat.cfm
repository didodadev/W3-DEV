<cfquery name="GET_CODE_CAT" datasource="#DSN3#">
	SELECT
		IS_ACTIVE,
		ACCOUNT_CODE,
		ACCOUNT_CODE_PUR,
		ACCOUNT_DISCOUNT,
		ACCOUNT_PRICE,
		ACCOUNT_PRICE_PUR,
		ACCOUNT_PUR_IADE,
		ACCOUNT_IADE,
		ACCOUNT_YURTDISI,
		ACCOUNT_YURTDISI_PUR,
		ACCOUNT_DISCOUNT_PUR,
		ACCOUNT_LOSS,
		ACCOUNT_EXPENDITURE,
		OVER_COUNT,
		UNDER_COUNT,
		PRODUCTION_COST,
		HALF_PRODUCTION_COST,
		SALE_PRODUCT_COST,
		SALE_MANUFACTURED_COST,
		DETAIL,
		MATERIAL_CODE,
		KONSINYE_PUR_CODE,
		KONSINYE_SALE_CODE,
		KONSINYE_SALE_NAZ_CODE,
		DIMM_CODE,
		DIMM_YANS_CODE,
		PROMOTION_CODE,
		EXP_CENTER_ID,
		(SELECT EC.EXPENSE FROM #DSN2_ALIAS#.EXPENSE_CENTER EC WHERE EC.EXPENSE_ID = EXP_CENTER_ID) AS EXPENSE,
		EXP_ITEM_ID,
		(SELECT EC.EXPENSE_ITEM_NAME FROM #DSN2_ALIAS#.EXPENSE_ITEMS EC WHERE EC.EXPENSE_ITEM_ID = EXP_ITEM_ID) AS EXPENSE_ITEM_NAME,
		EXP_ACTIVITY_TYPE_ID,
		EXP_TEMPLATE_ID,
		INC_CENTER_ID,
		(SELECT EC.EXPENSE FROM #DSN2_ALIAS#.EXPENSE_CENTER EC WHERE EC.EXPENSE_ID = INC_CENTER_ID) AS EXPENSE_INCOME,
		INC_ITEM_ID,
		(SELECT EC.EXPENSE_ITEM_NAME FROM #DSN2_ALIAS#.EXPENSE_ITEMS EC WHERE EC.EXPENSE_ITEM_ID = INC_ITEM_ID) AS EXPENSE_ITEM_NAME_INCOME,
		INC_ACTIVITY_TYPE_ID,
		INC_TEMPLATE_ID,
		INVENTORY_CAT_ID,
		INVENTORY_CODE,
		AMORTIZATION_METHOD_ID,
		AMORTIZATION_TYPE_ID,
		AMORTIZATION_EXP_CENTER_ID,
		AMORTIZATION_EXP_ITEM_ID,
		AMORTIZATION_CODE,
		PROD_GENERAL_CODE,
		PROD_LABOR_COST_CODE,
		RECEIVED_PROGRESS_CODE,
		PROVIDED_PROGRESS_CODE,
		SCRAP_CODE,
		MATERIAL_CODE_SALE,
		PRODUCTION_COST_SALE,
		SCRAP_CODE_SALE,
		EXPENSE_PROGRESS_CODE,
		INCOME_PROGRESS_CODE,
		DISCOUNT_EXPENSE_CENTER_ID,
		(SELECT EC.EXPENSE FROM #DSN2_ALIAS#.EXPENSE_CENTER EC WHERE EC.EXPENSE_ID = DISCOUNT_EXPENSE_CENTER_ID) AS DISCOUNT_EXPENSE_CENTER_NAME, 
        DISCOUNT_EXPENSE_ITEM_ID,
		(SELECT EI.EXPENSE_ITEM_NAME FROM #DSN2_ALIAS#.EXPENSE_ITEMS EI WHERE EI.IS_EXPENSE = 1 And EXPENSE_ITEM_ID =DISCOUNT_EXPENSE_ITEM_ID ) as discount_expense_item_name,
        DISCOUNT_ACTIVITY_TYPE_ID,
		REASON_CODE,
		OUTGOING_STOCK,
		INCOMING_STOCK,
		ACCOUNT_EXPORTREGISTERED,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_IP,
		UPDATE_DATE,
		EXE_VAT_SALE_INVOICE,
			CASE
				WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
				ELSE #dsn#.Get_Dynamic_Language(PRO_CODE_CATID,'#session.ep.language#','SETUP_PRODUCT_PERIOD_CAT','PRO_CODE_CAT_NAME',NULL,NULL,PRO_CODE_CAT_NAME) END AS PRO_CODE_CAT_NAME,
			PRO_CODE_CATID
	FROM
		SETUP_PRODUCT_PERIOD_CAT
		LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_PRODUCT_PERIOD_CAT.PRO_CODE_CATID
		AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRO_CODE_CAT_NAME">
		AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_PRODUCT_PERIOD_CAT">
		AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	WHERE
    	1 = 1
    <cfif isdefined('attributes.active_cat')>    
		AND IS_ACTIVE = 1
	</cfif>
    <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
    	AND PRO_CODE_CAT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
    </cfif>
	ORDER BY
		PRO_CODE_CAT_NAME
</cfquery>
