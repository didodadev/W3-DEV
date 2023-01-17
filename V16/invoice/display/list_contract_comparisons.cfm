<cf_xml_page_edit>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.pur_sales_info" default="">
<cfparam name="attributes.result_info" default="">
<cfparam name="attributes.inv_purchase_sales" default="">
<cfparam name="attributes.list_type" default="">
<cfparam name="attributes.diff_type" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfparam name="colspan_info" default="1">
<cfif is_default_pur eq 1 and not len(attributes.inv_purchase_sales)>
	<cfset attributes.inv_purchase_sales = 0>
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih = 'attributes.date1'>
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.date1 = ''>
	<cfelseif not len(attributes.company_id) and not len(attributes.company)>
		<cfset attributes.date1 = date_add('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
	<cf_date tarih = 'attributes.date2'>
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.date2 = ''>
	<cfelseif not len(attributes.company_id) and not len(attributes.company)>
		<cfset attributes.date2 = date_add('d',7,wrk_get_today())>
	</cfif>
</cfif>
<cfquery name="GET_MONEY" datasource="#dsn#">
    SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfif isdefined('attributes.is_submitted')>
	<cfquery name="GET_COMPARISON" datasource="#DSN2#">
		<cfif attributes.diff_type neq 11>
			SELECT 
				IC.DIFF_AMOUNT,
				IC.DIFF_RATE,
				IC.DIFF_TYPE,
				IC.DIFF_AMOUNT,
				IC.DIFF_AMOUNT_OTHER,
				IC.OTHER_MONEY,
				IC.TAX,
				IC.INVOICE_TYPE,
				IC.DEPARTMENT_ID,
				IC.LOCATION_ID,
				IC.AMOUNT,
				IC.COST_ID,
				IC.MAIN_STOCK_ID,
				IC.MAIN_PRODUCT_ID,
				IC.MAIN_INVOICE_ID,
				IC.MAIN_INVOICE_ROW_ID,
				IC.MAIN_INVOICE_NUMBER,
				IC.MAIN_INVOICE_DATE,
				IC.IS_DIFF_PRICE,
				IC.IS_DIFF_DISCOUNT,
				IC.COMPANY_ID,
				IC.CONSUMER_ID,
				IC.RECORD_EMP,
				IC.RECORD_DATE,
				IC.DUE_DIFF_ID,
				-1 PURCHASE_SALES,
				IC.DIFF_INVOICE_ID,
				'' PROJECT_ID,
				IC.CONTRACT_COMPARISON_ROW_ID,
				IC.NOTE
			FROM 
				INVOICE_CONTRACT_COMPARISON IC,
				EXPENSE_ITEM_PLANS EIP
			WHERE 
				IC.MAIN_INVOICE_ID = EIP.EXPENSE_ID
				AND IC.WRK_ROW_RELATION_ID IS NULL
				AND IC.MAIN_INVOICE_ROW_ID IS NULL
				<cfif len(attributes.company_id) and len(attributes.company)>
					AND IC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif len(attributes.date1) and isdate(attributes.date1) and len(attributes.date2) and isdate(attributes.date2)>
					AND	IC.MAIN_INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				</cfif>
				<cfif len(attributes.keyword)>
					AND IC.MAIN_INVOICE_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif len(attributes.diff_type)>
					AND IC.DIFF_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.diff_type#">
				</cfif>
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND IC.MAIN_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				</cfif>
				<cfif len(attributes.pur_sales_info)>
					AND IC.INVOICE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pur_sales_info#">
				</cfif>
			UNION ALL
			SELECT 
				IC.DIFF_AMOUNT,
				IC.DIFF_RATE,
				IC.DIFF_TYPE,
				IC.DIFF_AMOUNT,
				IC.DIFF_AMOUNT_OTHER,
				IC.OTHER_MONEY,
				IC.TAX,
				IC.INVOICE_TYPE,
				IC.DEPARTMENT_ID,
				IC.LOCATION_ID,
				IC.AMOUNT,
				IC.COST_ID,
				IC.MAIN_STOCK_ID,
				IC.MAIN_PRODUCT_ID,
				IC.MAIN_INVOICE_ID,
				IC.MAIN_INVOICE_ROW_ID,
				IC.MAIN_INVOICE_NUMBER,
				IC.MAIN_INVOICE_DATE,
				IC.IS_DIFF_PRICE,
				IC.IS_DIFF_DISCOUNT,
				IC.COMPANY_ID,
				IC.CONSUMER_ID,
				IC.RECORD_EMP,
				IC.RECORD_DATE,
				IC.DUE_DIFF_ID,
				I.PURCHASE_SALES,
				IC.DIFF_INVOICE_ID,
				I.PROJECT_ID,
				IC.CONTRACT_COMPARISON_ROW_ID,
				IC.NOTE
			FROM 
				INVOICE_CONTRACT_COMPARISON IC,
				INVOICE I
			WHERE 
				IC.MAIN_INVOICE_ID = I.INVOICE_ID
				<cfif len(attributes.result_info)>
					<cfif attributes.result_info eq 0>
						AND IC.DIFF_INVOICE_ID IS NULL 
					<cfelse>
						AND IC.DIFF_INVOICE_ID IS NOT NULL 
					</cfif>
				</cfif>
				<cfif len(attributes.inv_purchase_sales)>
					AND I.PURCHASE_SALES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inv_purchase_sales#">
				</cfif>
				<cfif len(attributes.company_id) and len(attributes.company)>
					AND IC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif len(attributes.consumer_id) and len(attributes.company)>
					AND IC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif len(attributes.date1) and isdate(attributes.date1) and len(attributes.date2) and isdate(attributes.date2)>
					AND	IC.MAIN_INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				</cfif>
				<cfif len(attributes.keyword)>
					AND IC.MAIN_INVOICE_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif len(attributes.diff_type)>
					AND IC.DIFF_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.diff_type#">
				</cfif>
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND IC.MAIN_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif len(attributes.pur_sales_info)>
					AND IC.INVOICE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pur_sales_info#">
				</cfif>
			UNION ALL
			SELECT 
				IC.DIFF_AMOUNT,
				IC.DIFF_RATE,
				IC.DIFF_TYPE,
				IC.DIFF_AMOUNT,
				IC.DIFF_AMOUNT_OTHER,
				IC.OTHER_MONEY,
				IC.TAX,
				IC.INVOICE_TYPE,
				IC.DEPARTMENT_ID,
				IC.LOCATION_ID,
				IC.AMOUNT,
				IC.COST_ID,
				IC.MAIN_STOCK_ID,
				IC.MAIN_PRODUCT_ID,
				IC.MAIN_INVOICE_ID,
				IC.MAIN_INVOICE_ROW_ID,
				IC.MAIN_INVOICE_NUMBER,
				IC.RECORD_DATE MAIN_INVOICE_DATE,
				IC.IS_DIFF_PRICE,
				IC.IS_DIFF_DISCOUNT,
				IC.COMPANY_ID,
				IC.CONSUMER_ID,
				IC.RECORD_EMP,
				IC.RECORD_DATE,
				IC.DUE_DIFF_ID,
				S.IS_SALES_PURCHASE PURCHASE_SALES,
				IC.DIFF_INVOICE_ID,
				'' PROJECT_ID,
				IC.CONTRACT_COMPARISON_ROW_ID,
				IC.NOTE
			FROM 
				INVOICE_CONTRACT_COMPARISON IC,
				#dsn3_alias#.SALES_QUOTAS_ROW_RELATION SQR,
				#dsn3_alias#.SALES_QUOTAS_ROW SQ,
				#dsn3_alias#.SALES_QUOTAS S
			WHERE 
				IC.MAIN_INVOICE_ID IS NULL
				<cfif len(attributes.result_info)>
					<cfif attributes.result_info eq 0>
						AND IC.DIFF_INVOICE_ID IS NULL 
					<cfelse>
						AND IC.DIFF_INVOICE_ID IS NOT NULL 
					</cfif>
				</cfif>
				<cfif len(attributes.inv_purchase_sales)>
					AND 1 = 0
				</cfif>
				AND IC.CONTRACT_COMPARISON_ROW_ID = SQR.INVOICE_COMPARISON_ID
				AND SQR.SALES_QUOTAS_ROW_ID = SQ.SALES_QUOTA_ROW_ID
				AND SQ.SALES_QUOTA_ID = S.SALES_QUOTA_ID
				AND SQR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				<cfif len(attributes.company_id) and len(attributes.company)>
					AND IC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif len(attributes.consumer_id) and len(attributes.company)>
					AND IC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif len(attributes.date1) and isdate(attributes.date1) and len(attributes.date2) and isdate(attributes.date2)>
					AND	IC.MAIN_INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				</cfif>
				<cfif len(attributes.keyword)>
					AND IC.MAIN_INVOICE_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif len(attributes.diff_type)>
					AND IC.DIFF_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.diff_type#">
				</cfif>
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND IC.MAIN_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				</cfif>
				<cfif len(attributes.pur_sales_info)>
					AND IC.INVOICE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pur_sales_info#">
				</cfif>
			UNION ALL
			SELECT 
				IC.DIFF_AMOUNT,
				IC.DIFF_RATE,
				IC.DIFF_TYPE,
				IC.DIFF_AMOUNT,
				IC.DIFF_AMOUNT_OTHER,
				IC.OTHER_MONEY,
				IC.TAX,
				IC.INVOICE_TYPE,
				IC.DEPARTMENT_ID,
				IC.LOCATION_ID,
				IC.AMOUNT,
				IC.COST_ID,
				IC.MAIN_STOCK_ID,
				IC.MAIN_PRODUCT_ID,
				IC.MAIN_INVOICE_ID,
				IC.MAIN_INVOICE_ROW_ID,
				IC.MAIN_INVOICE_NUMBER,
				IC.RECORD_DATE MAIN_INVOICE_DATE,
				IC.IS_DIFF_PRICE,
				IC.IS_DIFF_DISCOUNT,
				IC.COMPANY_ID,
				IC.CONSUMER_ID,
				IC.RECORD_EMP,
				IC.RECORD_DATE,
				IC.DUE_DIFF_ID,
				1 PURCHASE_SALES,
				IC.DIFF_INVOICE_ID,
				'' PROJECT_ID,
				IC.CONTRACT_COMPARISON_ROW_ID,
				IC.NOTE
			FROM 
				INVOICE_CONTRACT_COMPARISON IC
			WHERE 
				IC.COST_ID IS NOT NULL
				<cfif len(attributes.result_info)>
					<cfif attributes.result_info eq 0>
						AND IC.DIFF_INVOICE_ID IS NULL 
					<cfelse>
						AND IC.DIFF_INVOICE_ID IS NOT NULL 
					</cfif>
				</cfif>
				<cfif len(attributes.inv_purchase_sales)>
					AND 1 = 0
				</cfif>
				<cfif len(attributes.company_id) and len(attributes.company)>
					AND IC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif len(attributes.consumer_id) and len(attributes.company)>
					AND IC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif len(attributes.date1) and isdate(attributes.date1) and len(attributes.date2) and isdate(attributes.date2)>
					AND	IC.MAIN_INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				</cfif>
				<cfif len(attributes.keyword)>
					AND IC.MAIN_INVOICE_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif len(attributes.diff_type)>
					AND IC.DIFF_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.diff_type#">
				</cfif>
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND IC.MAIN_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				</cfif>
				<cfif len(attributes.pur_sales_info)>
					AND IC.INVOICE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pur_sales_info#">
				</cfif>
			ORDER BY 
				IC.MAIN_INVOICE_NUMBER
		<cfelse>
			SELECT
				<cfif attributes.list_type eq 1><!--- Satır bazında --->
					0 DIFF_RATE,
					'11' DIFF_TYPE,
					ABS(((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0))*IR.AMOUNT) DIFF_AMOUNT,
					ABS(((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0))/IM.RATE2*IR.AMOUNT) DIFF_AMOUNT_OTHER,
					IR.NETTOTAL AS ROW_TOTAL,
					ISNULL(IR.COST_PRICE,0)*IR.AMOUNT COST_PRICE,
					IR.OTHER_MONEY,
					IR.TAX,
					CASE WHEN (((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0)) < 0) THEN 1 ELSE 0 END AS INVOICE_TYPE,
					I.DEPARTMENT_ID,
					I.DEPARTMENT_LOCATION LOCATION_ID,
					IR.AMOUNT,
					'' COST_ID,
					IR.STOCK_ID MAIN_STOCK_ID,
					IR.PRODUCT_ID MAIN_PRODUCT_ID,
					IR.INVOICE_ID MAIN_INVOICE_ID,
					IR.INVOICE_ROW_ID MAIN_INVOICE_ROW_ID,
					I.INVOICE_NUMBER MAIN_INVOICE_NUMBER,
					I.INVOICE_DATE MAIN_INVOICE_DATE,
					'' IS_DIFF_PRICE,
					'' IS_DIFF_DISCOUNT,
					I.COMPANY_ID,
					I.CONSUMER_ID,
					I.RECORD_EMP,
					I.RECORD_DATE,
					'' DUE_DIFF_ID,
					I.PURCHASE_SALES,
					(SELECT IC.DIFF_INVOICE_ID FROM INVOICE_CONTRACT_COMPARISON IC WHERE IC.MAIN_INVOICE_ROW_ID = IR.INVOICE_ROW_ID) DIFF_INVOICE_ID,
					I.PROJECT_ID,
					'' CONTRACT_COMPARISON_ROW_ID
				<cfelse><!--- Belge bazında --->
					0 DIFF_RATE,
					'11' DIFF_TYPE,
					SUM(ABS(((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0))*IR.AMOUNT)) DIFF_AMOUNT,
					SUM(ABS(((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0))/IM.RATE2*IR.AMOUNT)) DIFF_AMOUNT_OTHER,
					SUM(IR.NETTOTAL) AS ROW_TOTAL,
					SUM(ISNULL(IR.COST_PRICE,0)*IR.AMOUNT) COST_PRICE,
					'' OTHER_MONEY,
					'' TAX,
					CASE WHEN (SUM(((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0))) < 0) THEN 1 ELSE 0 END AS INVOICE_TYPE,
					I.DEPARTMENT_ID,
					I.DEPARTMENT_LOCATION LOCATION_ID,
					'' AMOUNT,
					'' COST_ID,
					'' MAIN_STOCK_ID,
					'' MAIN_PRODUCT_ID,
					'' MAIN_INVOICE_ID,
					'' MAIN_INVOICE_ROW_ID,
					I.INVOICE_NUMBER MAIN_INVOICE_NUMBER,
					I.INVOICE_DATE MAIN_INVOICE_DATE,
					'' IS_DIFF_PRICE,
					'' IS_DIFF_DISCOUNT,
					I.COMPANY_ID,
					I.CONSUMER_ID,
					I.RECORD_EMP,
					I.RECORD_DATE,
					'' DUE_DIFF_ID,
					I.PURCHASE_SALES,
					'' DIFF_INVOICE_ID,
					I.PROJECT_ID,
					'' CONTRACT_COMPARISON_ROW_ID
				</cfif>
			FROM 
				INVOICE_ROW IR,
				INVOICE I,
				INVOICE_MONEY IM
			WHERE 
				IR.INVOICE_ID = I.INVOICE_ID
				AND IM.ACTION_ID = I.INVOICE_ID
				AND IM.MONEY_TYPE = IR.OTHER_MONEY
				AND ((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0)) <> 0
				AND IR.STOCK_ID IS NOT NULL
				<cfif len(attributes.inv_purchase_sales)>
					AND I.PURCHASE_SALES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inv_purchase_sales#">
				</cfif>
				<cfif len(attributes.result_info)>
					<cfif attributes.result_info eq 0>
						AND 
						(
							IR.INVOICE_ROW_ID IN(SELECT IC.MAIN_INVOICE_ROW_ID FROM INVOICE_CONTRACT_COMPARISON IC WHERE IC.DIFF_INVOICE_ID IS NULL)
							OR
							IR.INVOICE_ROW_ID NOT IN(SELECT IC.MAIN_INVOICE_ROW_ID FROM INVOICE_CONTRACT_COMPARISON IC WHERE IC.MAIN_INVOICE_ROW_ID IS NOT NULL)
						)
					<cfelse>
						AND IR.INVOICE_ROW_ID IN(SELECT IC.MAIN_INVOICE_ROW_ID FROM INVOICE_CONTRACT_COMPARISON IC WHERE IC.DIFF_INVOICE_ID IS NOT NULL)
					</cfif>
				</cfif>
				<cfif len(attributes.company_id) and len(attributes.company)>
					AND I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif len(attributes.consumer_id) and len(attributes.company)>
					AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif len(attributes.date1) and isdate(attributes.date1) and len(attributes.date2) and isdate(attributes.date2)>
					AND	I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				</cfif>
				<cfif len(attributes.keyword)>
					AND I.INVOICE_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND IR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif len(attributes.pur_sales_info)>
					<cfif attributes.pur_sales_info eq 0>
						AND ((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0)) > 0
					<cfelse>
						AND ((IR.NETTOTAL/IR.AMOUNT)-ISNULL(IR.COST_PRICE,0)) < 0
					</cfif>
				</cfif>
			<cfif attributes.list_type eq 0>
				GROUP BY
					I.DEPARTMENT_ID,
					I.DEPARTMENT_LOCATION,
					I.INVOICE_NUMBER,
					I.INVOICE_DATE,
					I.COMPANY_ID,
					I.CONSUMER_ID,
					I.RECORD_EMP,
					I.RECORD_DATE,
					I.PURCHASE_SALES,
					I.PROJECT_ID
			</cfif>
			ORDER BY 
				I.INVOICE_NUMBER
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_comparison.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#"> 
<cfparam name="attributes.totalrecords" default="#get_comparison.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform action="#request.self#?fuseaction=invoice.list_conract_comparison" name="inv_form" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" placeholder="#header_#" style="width:100px;" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57448.Satış'>/<cf_get_lang dictionary_id='58176.Alış'></cfsavecontent>
					<select name="inv_purchase_sales" id="inv_purchase_sales" style="width:100px;">
						<option value=""><cf_get_lang dictionary_id='57288.Fatura Tipi'></option>
						<option value="1" <cfif attributes.inv_purchase_sales eq 1>selected</cfif>><cf_get_lang dictionary_id='57448.Satış'></option>
						<option value="0" <cfif attributes.inv_purchase_sales eq 0>selected</cfif>><cf_get_lang dictionary_id='58176.Alış'></option>
					</select>                    
				</div>
				<cfif attributes.diff_type neq 11>
					<cfset style_type = 'none'>
				<cfelse>
					<cfset style_type = ' '>
				</cfif>
				<div class="form-group">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='29539.Satır Bazında'>/<cf_get_lang dictionary_id='57660.Belge Bazında'></cfsavecontent>
					<select name="list_type" id="list_type" style="width:100px;">
						<option value="1" <cfif attributes.list_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
						<option value="0" <cfif attributes.list_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
					</select>                    
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:20px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button is_excel="0" button_type="4" search_function='input_control()'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-company">
						<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57519.Cari Hesap'></cfsavecontent>
								<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
								<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
								<input type="hidden" name="partner_id" id="partner_id" <cfif len(attributes.partner_id)> value="<cfoutput>#attributes.partner_id#</cfoutput>"</cfif>>
								<input name="company" type="text" id="company" style="width:135px;" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'\',\'2\',\'0\'','COMPANY_ID,PARTNER_ID,CONSUMER_ID','company_id,partner_id,consumer_id','','3','225');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=inv_form.company&field_comp_id=inv_form.company_id&field_consumer=inv_form.consumer_id&field_name=inv_form.company&field_partner=inv_form.partner_id</cfoutput>&keyword='+encodeURIComponent(document.inv_form.company.value),'list')" title="<cf_get_lang_main no='322.seçiniz'>"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-pur_sales_info">
						<label class="col col-12"><cf_get_lang dictionary_id='57332.Fark Tipi'></label>
						<div class="col col-12">
							<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57332.Fark Tipi'></cfsavecontent>
							<select name="pur_sales_info" id="pur_sales_info" style="width:100px;">
								<option value=""><cf_get_lang dictionary_id='57332.Fark Tipi'></option>
								<option value="1" <cfif attributes.pur_sales_info eq 1>selected</cfif>><cf_get_lang dictionary_id='58488.Alınan'></option>
								<option value="0" <cfif attributes.pur_sales_info eq 0>selected</cfif>><cf_get_lang dictionary_id='58490.Verilen'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-product_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
								<input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
								<input name="product_name" type="text" id="product_name" style="width:120px;" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','inv_form','3','250');" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" passthrough="readonly=yes" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=inv_form.product_id&field_name=inv_form.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+document.inv_form.product_name.value,'list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-result_info">
						<label class="col col-12"><cf_get_lang dictionary_id='57099.Kesilmemiş'>/<cf_get_lang dictionary_id='57229.Kesilmiş'></label>
						<div class="col col-12">
							<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57099.Kesilmemiş'>/<cf_get_lang dictionary_id='57229.Kesilmiş'></cfsavecontent>
							<select name="result_info" id="result_info" style="width:100px;">
								<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
								<option value="0" <cfif attributes.result_info eq 0 or not isdefined("attributes.is_submitted")>selected</cfif>><cf_get_lang dictionary_id='57099.Kesilmemiş'></option>
								<option value="1" <cfif attributes.result_info eq 1>selected</cfif>><cf_get_lang dictionary_id='57229.Kesilmiş'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-project_head">
						<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
								<input type="hidden" name="project_id" id="project_id" value="<cfif len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
								<input type="text" name="project_head" id="project_head" style="width:120px;" value="<cfif isdefined ("url.pro_id") and  len(url.pro_id)><cfoutput>#GET_PROJECT_NAME(url.pro_id)#</cfoutput><cfelseif len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=inv_form.project_id&project_head=inv_form.project_head');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-diff_type">
						<label class="col col-12"><cf_get_lang dictionary_id='58583.Fark'> <cf_get_lang dictionary_id='58651.Türü'></label>
						<div class="col col-12">
							<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57486.Kategori'></cfsavecontent>
							<select name="diff_type" id="diff_type" style="width:120px;">
								<option value="" selected><cf_get_lang dictionary_id='58583.Fark'> <cf_get_lang dictionary_id='58651.Türü'></option>
								<option value="1" <cfif len(attributes.diff_type) and attributes.diff_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='57327.Koşul Farkı'></option>
								<option value="2" <cfif len(attributes.diff_type) and attributes.diff_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='57333.Aksiyon Farkı'></option>
								<option value="3" <cfif len(attributes.diff_type) and attributes.diff_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='57334.Sipariş Farkı'></option>
								<option value="4" <cfif len(attributes.diff_type) and attributes.diff_type eq 4>selected</cfif>><cf_get_lang dictionary_id ='57239.Fiyat Farkı'></option>
								<option value="5" <cfif len(attributes.diff_type) and attributes.diff_type eq 5>selected</cfif>><cf_get_lang dictionary_id ='57884.Kur Farkı'></option>
								<option value="6" <cfif len(attributes.diff_type) and attributes.diff_type eq 6>selected</cfif>><cf_get_lang dictionary_id ='57335.Fiyat Koruma'></option>
								<option value="7" <cfif len(attributes.diff_type) and attributes.diff_type eq 7>selected</cfif>><cf_get_lang dictionary_id ='57336.Manuel Fark'></option>
								<option value="8" <cfif len(attributes.diff_type) and attributes.diff_type eq 8>selected</cfif>><cf_get_lang dictionary_id ='58501.Vade Farkı'></option>
								<option value="9" <cfif len(attributes.diff_type) and attributes.diff_type eq 9>selected</cfif>><cf_get_lang dictionary_id ='57398.Prim Hakedişi'></option>
								<option value="10" <cfif len(attributes.diff_type) and attributes.diff_type eq 10>selected</cfif>><cf_get_lang dictionary_id ='57399.Mal Fazlası Hakedişi'></option>
								<option value="11" <cfif len(attributes.diff_type) and attributes.diff_type eq 11>selected</cfif>><cf_get_lang dictionary_id ='57400.Manuel Maliyet'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-date1">
						<label class="col col-12"><cf_get_lang dictionary_id='58759.Fatura Tarihi'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58759.Fatura Tarihi'></cfsavecontent>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57276.Başlangıç Tarihi Hatalı'> !</cfsavecontent>
								<cfif session.ep.our_company_info.unconditional_list>
									<cfinput type="text" name="date1" value="#dateformat(attributes.date1,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
								<cfelse>
									<cfinput type="text" name="date1" value="#dateformat(attributes.date1,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
								<span class="input-group-addon no-bg"></span>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58767.Bitiş Tarihi Hatalı'> !</cfsavecontent>
								<cfif session.ep.our_company_info.unconditional_list>
									<cfinput type="text" name="date2" value="#dateformat(attributes.date2,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;"> 
								<cfelse>
									<cfinput type="text" name="date2" value="#dateformat(attributes.date2,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>

	<cfsavecontent variable="title"><cf_get_lang dictionary_id="57275.Fark ve Prim Kontrol Listesi"></cfsavecontent>
	<cf_box hide_table_column="1" uidrop="1" title="#title#">
		<cfform name="add_fark_faturasi" action="#request.self#?fuseaction=invoice.emptypopup_add_contract_comparison_rows" method="post">
			<cf_grid_list>
				<thead>
					<th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id='58133.Fatura No'></th>
					<th><cf_get_lang dictionary_id='57288.Fatura Tipi'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<cfif is_show_project eq 1>
						<th><cf_get_lang dictionary_id='57416.Proje'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id ='57332.Fark Tipi'></th>
					<cfif is_show_control_type eq 1>
						<th><cf_get_lang dictionary_id='57278.Kontrol Tipi'></th>
					</cfif>
					<cfif is_show_controller eq 1>
						<th><cf_get_lang dictionary_id='57032.Kontrol Eden'></th>
					</cfif>
					<cfif is_show_control_date eq 1>
						<th><cf_get_lang dictionary_id='57094.Kontrol Tarihi'></th>
					</cfif>
					<cfif is_note>
						<th><cf_get_lang dictionary_id='57467.Not'></th>
					</cfif>
					<cfif (attributes.diff_type eq 11 and attributes.list_type eq 1) or attributes.diff_type neq 11>
						<th><cf_get_lang dictionary_id='57657.Ürün'></th>
						<th><cf_get_lang dictionary_id='57635.Miktar'></th>
					</cfif>
					<cfif attributes.diff_type eq 11>
						<cfif attributes.list_type eq 1>
							<th><cf_get_lang dictionary_id='57397.Net Fiyat'></th>
							<th><cf_get_lang dictionary_id='57174.Net Maliyet'></th>
							<th><cf_get_lang dictionary_id='58583.Fark'></th>
							<th><cf_get_lang dictionary_id='58888.Döviz Fark'></th>
						<cfelse>
							<th><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57397.Net Fiyat'></th>
							<th><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57174.Net Maliyet'></th>
							<th><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='58583.Fark'></th>
						</cfif>
					<cfelse>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th><cf_get_lang dictionary_id='57279.Döviz Tutar'></th>
					</cfif>
					<cfif (attributes.diff_type eq 11 and attributes.list_type eq 1) or attributes.diff_type neq 11>
						<th><cf_get_lang dictionary_id='57639.KDV'></th>
						<cfif len(attributes.inv_purchase_sales) and (len(attributes.company_id) or len(attributes.consumer_id)) and len(attributes.company)>
							<!-- sil --><th width="20" align="center"><input type="Checkbox" class="money_class checkAll" name="all_view" id="all_view" value="1" onclick="hepsi_view();"></th><!-- sil -->
						</cfif>
					</cfif>
				</tr>
				</thead>
				<tbody>
					<cfif get_comparison.recordcount>
						<cfset record_emp_list = "">
						<cfset company_id_list = "">
						<cfset consumer_id_list = "">
						<cfset main_product_id_list = "">
						<cfset project_id_list = "">
						<cfoutput query="get_comparison" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif len(record_emp) and not listfind(record_emp_list, record_emp)>
								<cfset record_emp_list=listappend(record_emp_list, record_emp)>
							</cfif>
							<cfif len(company_id) and not listfind(company_id_list, company_id)>
								<cfset company_id_list=listappend(company_id_list, company_id)>
							</cfif>
							<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
								<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
							</cfif>
							<cfif len(project_id) and not listfind(project_id_list,project_id)>
								<cfset project_id_list=listappend(project_id_list,project_id)>
							</cfif>
							<cfif len(main_product_id) and not listfind(main_product_id_list, main_product_id)>
								<cfset main_product_id_list=listappend(main_product_id_list, main_product_id)>
							</cfif>
						</cfoutput>
						<cfif len(record_emp_list)>
							<cfset record_emp_list = listsort(record_emp_list,"numeric","ASC",",")>
							<cfquery name="get_record_detail" datasource="#dsn#">
								SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#record_emp_list#">) ORDER BY EMPLOYEE_ID
							</cfquery>
							<cfset record_emp_list = listsort(listdeleteduplicates(valuelist(get_record_detail.employee_id,',')),'numeric','ASC',',')>
						</cfif>
						<cfif len(project_id_list)>
							<cfset project_id_list = listsort(project_id_list,"numeric","ASC",",")>
							<cfquery name="get_pro_detail" datasource="#dsn#">
								SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#project_id_list#">) ORDER BY PROJECT_ID
							</cfquery>
							<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_pro_detail.project_id,',')),'numeric','ASC',',')>
						</cfif>
						<cfif len(company_id_list)>
							<cfset company_id_list = listsort(company_id_list,"numeric","ASC",",")>
							<cfquery name="get_company_detail" datasource="#dsn#">
								SELECT COMPANY_ID,NICKNAME FROM COMPANY WHERE COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#company_id_list#">) ORDER BY COMPANY_ID
							</cfquery>
							<cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
						</cfif>
						<cfif len(consumer_id_list)>
							<cfset consumer_id_list = listsort(consumer_id_list,"numeric","ASC",",")>
							<cfquery name="get_consumer_detail" datasource="#dsn#">
								SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#consumer_id_list#">) ORDER BY CONSUMER_ID
							</cfquery>
							<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
						</cfif>
						<cfif len(main_product_id_list)>
							<cfset main_product_id_list = listsort(main_product_id_list,"numeric","ASC",",")>
							<cfquery name="get_product_detail" datasource="#dsn1#">
								SELECT 
									PRODUCT_ID,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#main_product_id_list#">) ORDER BY PRODUCT_ID
							</cfquery>
							<cfset main_product_id_list = listsort(listdeleteduplicates(valuelist(get_product_detail.product_id,',')),'numeric','ASC',',')>
						</cfif>
						<!-- sil -->
						<cfoutput>
						<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
						<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
						<input type="hidden" name="partner_id" id="partner_id" value="#attributes.partner_id#">
						<input type="hidden" name="department_id" id="department_id" value="#GET_COMPARISON.DEPARTMENT_ID#">
						<input type="hidden" name="location_id" id="location_id" value="#GET_COMPARISON.LOCATION_ID#">
						</cfoutput>
						<!-- sil -->
						<cfscript>
							toplam1 = 0;
							toplam2 = 0;
							toplam3 = 0;
						</cfscript>
						<cfoutput query="get_comparison" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif attributes.diff_type eq 11>
								<cfscript>
									toplam1 = toplam1 + ROW_TOTAL;
									toplam2 = toplam2 + COST_PRICE;
									toplam3 = toplam3 + DIFF_AMOUNT;
								</cfscript>
							</cfif>
							<cfif (len(DIFF_AMOUNT) and DIFF_AMOUNT gt 0 or len(DIFF_RATE) and DIFF_RATE gt 0) or DIFF_TYPE eq 7 or DIFF_TYPE eq 9 or DIFF_TYPE eq 10 or DIFF_TYPE eq 11>
							<tr id="tr_invoice_row_#currentrow#">
								<td>#currentrow#</td>
								<td width="100">
									<cfif PURCHASE_SALES eq 0>
										<a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#main_invoice_id#" class="tableyazi">#main_invoice_number#</a>
									<cfelseif PURCHASE_SALES eq -1>
										<a href="#request.self#?fuseaction=health.expenses&event=upd&expense_id=#main_invoice_id#" class="tableyazi" target="_blank">#main_invoice_number#</a>
									<cfelse>
										<a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#main_invoice_id#" class="tableyazi">#main_invoice_number#</a>
									</cfif>
								</td>
								<td width="100"><cfif PURCHASE_SALES eq 0><cf_get_lang dictionary_id='58176.Alış'><cfelseif PURCHASE_SALES eq 1><cf_get_lang dictionary_id='57448.Satış'></cfif></td>
								<td>#dateformat(MAIN_INVOICE_DATE,dateformat_style)#</td>
								<cfif is_show_project eq 1>
									<td><cfif len(project_id)>#get_pro_detail.project_head[listfind(project_id_list,project_id,',')]#</cfif></td>
								</cfif>
								<td><cfif len(company_id)>
										<a href="javascript:// " onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');" class="tableyazi">
											#get_company_detail.NICKNAME[listfind(company_id_list,company_id,',')]#
										</a>
									<cfelse>
										<a href="javascript:// " onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">
											#get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,consumer_id,',')]#&nbsp;#get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,consumer_id,',')]#
										</a>
									</cfif>
								</td>
								<td><cfif INVOICE_TYPE eq 1><cf_get_lang dictionary_id='58488.Alınan'><cfelse><cf_get_lang dictionary_id='58490.Verilen'></cfif></td>
								<cfif is_show_control_type eq 1>
									<td><cfif DIFF_TYPE eq 1><cf_get_lang dictionary_id='57238.Koşul'><cfelseif DIFF_TYPE eq 2><cf_get_lang dictionary_id='57368.Aksiyon'><cfelseif DIFF_TYPE eq 3><cf_get_lang dictionary_id='57611.Sipariş'><cfelseif DIFF_TYPE eq 4><cf_get_lang dictionary_id='58084.Fiyat'><cfelseif DIFF_TYPE eq 5><cf_get_lang dictionary_id='57884.Kur Farkı'><cfelseif DIFF_TYPE eq 6><cf_get_lang dictionary_id='57335.Fiyat Koruma'><cfelseif DIFF_TYPE eq 7><cf_get_lang dictionary_id='58500.Manuel'><cfelseif DIFF_TYPE eq 8><cf_get_lang dictionary_id='58501.Vade Farkı'><cfelseif DIFF_TYPE eq 9><cf_get_lang dictionary_id="57398.Prim Hakedişi"><cfelseif DIFF_TYPE eq 10><cf_get_lang dictionary_id="57399.Mal Fazlası Hakedişi"></cfif></td>
								</cfif>
								<cfif is_show_controller eq 1>
									<td><cfif len(record_emp)>#get_record_detail.employee_name[listfind(record_emp_list,record_emp,',')]# #get_record_detail.employee_surname[listfind(record_emp_list,record_emp,',')]#</cfif></td>
								</cfif>
								<cfif is_show_control_date eq 1>
									<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
								</cfif>
								<cfif is_note>
									<td>#NOTE#</td>
								</cfif>
								<cfif (attributes.diff_type eq 11 and attributes.list_type eq 1) or attributes.diff_type neq 11>
									<td><cfif len(main_product_id)>#get_product_detail.PRODUCT_NAME[listfind(main_product_id_list,main_product_id,',')]#</cfif></td>
									<td style="text-align:right;">#TLFormat(AMOUNT)#</td>
								</cfif>
								<cfif attributes.diff_type eq 11>
									<td style="text-align:right;">#TLFormat(ROW_TOTAL)#</td>
									<td style="text-align:right;">#TLFormat(COST_PRICE)#</td>
									<td style="text-align:right;">#TLFormat(DIFF_AMOUNT)# #session.ep.money#</td>
									<cfif (attributes.diff_type eq 11 and attributes.list_type eq 1) or attributes.diff_type neq 11>
										<td style="text-align:right;">#TLFormat(DIFF_AMOUNT_OTHER)# #OTHER_MONEY#</td>
									</cfif>
								<cfelse>
									<td style="text-align:right;">#TLFormat(DIFF_AMOUNT)# #session.ep.money#</td>
									<td style="text-align:right;">#TLFormat(DIFF_AMOUNT_OTHER)# #OTHER_MONEY#</td>
								</cfif>
								<cfif (attributes.diff_type eq 11 and attributes.list_type eq 1) or attributes.diff_type neq 11>
									<td style="text-align:right;">#TAX#</td>
									<cfif len(attributes.inv_purchase_sales) and (len(attributes.company_id) or len(attributes.consumer_id)) and len(attributes.company) and ((DIFF_TYPE eq 5 and DIFF_TYPE eq attributes.diff_type) or DIFF_TYPE neq 5)>
										<!-- sil -->
										<td align="center">
											<cfif not len(DIFF_INVOICE_ID)>
												<input name="line_id" id="line_id" type="checkbox" class="money_class" total_value="#TLFormat(DIFF_AMOUNT)#" total_other_value="#TLFormat(DIFF_AMOUNT_OTHER)#" money_type="#other_money#" value="#currentrow#" <cfif attributes.diff_type eq 5>checked</cfif>>
											</cfif>
											<input name="tax_#currentrow#" id="tax_#currentrow#" type="hidden" value="#TAX#">
											<input name="project_id_#currentrow#" id="project_id_#currentrow#" type="hidden" value="#project_id#">
											<input name="project_name_#currentrow#" id="project_name_#currentrow#" type="hidden" value="<cfif len(project_id)>#get_pro_detail.project_head[listfind(project_id_list,project_id,',')]#</cfif>">
											<input name="contract_row_id_#currentrow#" id="contract_row_id_#currentrow#" type="hidden" value="#CONTRACT_COMPARISON_ROW_ID#">
											<input name="stock_id_#currentrow#" id="stock_id_#currentrow#" type="hidden" value="#MAIN_STOCK_ID#">
											<input name="product_id_#currentrow#" id="product_id_#currentrow#" type="hidden" value="#MAIN_PRODUCT_ID#">
											<input name="amount_#currentrow#" id="amount_#currentrow#" type="hidden" value="#AMOUNT#">
											<input name="invoice_id_#currentrow#" id="invoice_id_#currentrow#" type="hidden" value="#MAIN_INVOICE_ID#">
											<input name="invoice_number_#currentrow#" id="invoice_number_#currentrow#" type="hidden" value="#MAIN_INVOICE_NUMBER#">
											<input name="invoice_amount_#currentrow#" id="invoice_amount_#currentrow#" type="hidden" value="#DIFF_AMOUNT#">
											<input name="is_diff_price_#currentrow#" id="is_diff_price_#currentrow#" type="hidden" value="#is_diff_price#">
											<input name="is_diff_discount_#currentrow#" id="is_diff_discount_#currentrow#" type="hidden" value="#is_diff_discount#">
											<input name="diff_type_#currentrow#" id="diff_type_#currentrow#" type="hidden" value="#DIFF_TYPE#">
											<input name="invoice_row_id_#currentrow#" id="invoice_row_id_#currentrow#" type="hidden" value="#MAIN_INVOICE_ROW_ID#">
											<input name="invoice_date_#currentrow#" id="invoice_date_#currentrow#" type="hidden" value="#dateformat(MAIN_INVOICE_DATE,dateformat_style)#">
											<input name="invoice_amount_other_#currentrow#" id="invoice_amount_other_#currentrow#" type="hidden" value="#DIFF_AMOUNT_OTHER#">
											<input name="other_money_#currentrow#" id="other_money_#currentrow#" type="hidden" value="#OTHER_MONEY#">
											<input name="cost_id_#currentrow#" id="cost_id_#currentrow#" type="hidden" value="#COST_ID#">
											<input name="due_diff_id_#currentrow#" id="due_diff_id_#currentrow#" type="hidden" value="#DUE_DIFF_ID#">
											<input name="invoice_type_#currentrow#" id="invoice_type_#currentrow#" type="hidden" value="<cfif not len(INVOICE_TYPE)>0<cfelse>#INVOICE_TYPE#</cfif>">	
										</td>
										<!-- sil -->
									<cfelseif len(attributes.inv_purchase_sales) and (len(attributes.company_id) or len(attributes.consumer_id)) and len(attributes.company)>
										<input name="invoice_row_id_#currentrow#" id="invoice_row_id_#currentrow#" type="hidden" value="#MAIN_INVOICE_ROW_ID#">
										<input name="invoice_id_#currentrow#" id="invoice_id_#currentrow#" type="hidden" value="#MAIN_INVOICE_ID#">
										<input name="cost_id_#currentrow#" id="cost_id_#currentrow#" type="hidden" value="#COST_ID#">
										<input name="diff_type_#currentrow#" id="diff_type_#currentrow#" type="hidden" value="#DIFF_TYPE#">
										<!-- sil --><td></td><!-- sil -->
									</cfif>
								</cfif>
							</tr>
							</cfif>
						</cfoutput>
						<cfif attributes.diff_type eq 11>
							<cfset colspan_info = 13>
						<cfelse>
							<cfset colspan_info = 12>
						</cfif>
						<cfif is_show_project eq 1>
							<cfset colspan_info = colspan_info+1>
						</cfif>
						<cfif is_show_control_type eq 1>
							<cfset colspan_info = colspan_info+1>
						</cfif>
						<cfif is_show_controller eq 1>
							<cfset colspan_info = colspan_info+1>
						</cfif>
						<cfif is_show_control_date eq 1>
							<cfset colspan_info = colspan_info+1>
						</cfif>
						<cfif attributes.diff_type eq 11>
							<tr>
								<cfif (attributes.diff_type eq 11 and attributes.list_type eq 1)>
									<cfoutput>
									<td colspan="7" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="57492.Toplam"></td>
									<td class="txtboldblue" style="text-align:right;">#TLFormat(toplam1)#</td>
									<td class="txtboldblue" style="text-align:right;">#TLFormat(toplam2)#</td>
									<td class="txtboldblue" style="text-align:right;">#TLFormat(toplam3)# #session.ep.money#</td>
									<td colspan="4"></td>
									</cfoutput>
								<cfelseif (attributes.diff_type eq 11 and attributes.list_type eq 0)>
									<cfoutput>
									<td colspan="5" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="57492.Toplam"></td>
									<td class="txtboldblue" style="text-align:right;">#TLFormat(toplam1)#</td>
									<td class="txtboldblue" style="text-align:right;">#TLFormat(toplam2)#</td>
									<td class="txtboldblue" style="text-align:right;">#TLFormat(toplam3)# #session.ep.money#</td>
									</cfoutput>
								</cfif>
							</tr>
						</cfif>		
						<cfif not get_comparison.recordcount>
							<tr>
								<td colspan="<cfoutput>#colspan_info#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
							</tr>
						</cfif>
						<!-- sil -->
							<input type="hidden" name="inv_type" id="inv_type" value="">
						<!-- sil --> 
					<cfelse>
						<!-- sil -->
						<tr>
							<td colspan="23"><cfif isdefined('attributes.is_submitted')><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
						</tr>
						<!-- sil -->
					</cfif>
				</tbody>
			</cf_grid_list>
		</cfform>
	</cf_box>
</div>
<cfif len(attributes.inv_purchase_sales) and (len(attributes.company_id) or len(attributes.consumer_id)) and len(attributes.company)>
<div class="col col-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='60291.Fiyat ve Prim Farkı'></cfsavecontent>
	<cf_box title="#title#" closable="0">
		<div class="row">
			<div class="col col-6 col-md-12 col-sm-12 col-xs-12">
				<div class="col col-6 col-md-5 col-sm-6 col-xs-12">
					<div class="col col-12">
						<div class="form-group col col-6">
							<label><cf_get_lang dictionary_id='57489.Para Birimi'></label>
						</div>
						<cfoutput query="get_money">
							<div class="col col-12">
								<div class="form-group col col-6">
									<input value="#money#" readonly style="width:50px;">
								</div>
								<div class="form-group col col-6">
									<div class="input-group">
										<span class="input-group-addon"><strong>0</strong></span>
										<input id="deger_artis_#money#" name="deger_artis_#money#" value="0" class="moneybox" readonly>
									</div>
								</div>
							</div>
						</cfoutput>
						<div class="col col-12">
							<div class="form-group col col-12">
								<label><cf_get_lang dictionary_id='33046.Sistem Para Birimi'>- <cf_get_lang dictionary_id='57492.Toplam'></label>
							</div>
						</div>
						<div class="col col-12">
							<div class="form-group col col-6">
								<input value="<cfoutput>#session.ep.money#</cfoutput>" readonly style="width:50px;">
							</div>
							<div class="form-group col col-6">
								<div class="input-group">
									<span class="input-group-addon"><strong>0</strong></span>
									<input id="deger_artis_system" name="deger_artis_system" value="0" class="moneybox" readonly>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-2 col-xs-12">
						<div class="col col-12">
							<div class="form-group">
								<label><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
							</div>
						</div>
						<div class="col col-12">
							<div class="form-group">
								<label>
									<cfif len(attributes.company_id)>
										<cfquery name="get_company_detail" datasource="#dsn#">
											SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
										</cfquery>
										<cfoutput>#get_company_detail.NICKNAME#</cfoutput>
									<cfelseif len(attributes.consumer_id)>
										<cfquery name="get_consumer_detail" datasource="#dsn#">
											SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
										</cfquery>
										<cfoutput>#get_consumer_detail.CONSUMER_NAME# #get_consumer_detail.CONSUMER_SURNAME#</cfoutput>
									</cfif>
								</label>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<cf_box_footer>
			<div class="text-right">
				<cfif (attributes.diff_type eq 11 and attributes.list_type eq 1) or attributes.diff_type neq 11>
					<cfif len(attributes.inv_purchase_sales) and (len(attributes.company_id) or len(attributes.consumer_id)) and len(attributes.company)>
						<tr>
							<td height="20" colspan="<cfoutput>#colspan_info#</cfoutput>" class="color-row" id="row_info_1" style="text-align:right;">
								<cfif get_comparison.recordcount >
									<cfif attributes.diff_type eq 11><!--- fark kaydı oluşacak --->
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57401.Fark Kaydı Oluştur'></cfsavecontent>
										<input type="button" value="<cfoutput>#message#</cfoutput>" onClick="KontrolEt_Gonder(4);">
									<cfelseif attributes.diff_type neq 5><!--- kur farkı mı diger --->
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57281.Fark Faturası Oluştur'></cfsavecontent>
										<input type="button" value="<cfoutput>#message#</cfoutput>" onClick="KontrolEt_Gonder(1);">
									<cfelseif attributes.diff_type eq 8><!---Vade Farkı --->
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57402.Vade Farkı Faturası Oluştur'></cfsavecontent>
										<input type="button" value="<cfoutput>#message#</cfoutput>" onClick="KontrolEt_Gonder(3);">
									<cfelse>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57282.Kur Farkı Faturası Oluştur'></cfsavecontent>
										<input type="button" value="<cfoutput>#message#</cfoutput>" onClick="KontrolEt_Gonder(2);">
									</cfif>
								</cfif>
								<cfif not ListFind("9,10,11",attributes.diff_type) and len(attributes.inv_purchase_sales) and (len(attributes.company_id) or len(attributes.consumer_id)) and len(attributes.company)>
									<cfsavecontent variable="message_del"><cf_get_lang dictionary_id='57463.Sil'></cfsavecontent>
									<input type="button" value="<cfoutput>#message_del#</cfoutput>" onClick="if(confirm('<cf_get_lang dictionary_id="57533.Silmek İstediğinize Emin Misiniz?">')) sil_islem(); else return false;">
								</cfif>
							</td>
							<cfif attributes.diff_type eq 11>
								<cfoutput>
								<td colspan="#colspan_info#" style="text-align:right;" height="20" style="display:none;" id="row_info_2">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57281.Fark Faturası Oluştur'></cfsavecontent>
									<input type="button" value="#message#" onClick="KontrolEt_Gonder(1);">
								</td>
								</cfoutput>
							</cfif>
						</tr>
						<tr valign="top" id="quota_result_info" style="display:none">
							<td colspan="<cfoutput>#colspan_info#</cfoutput>"><div id="show_quota_result_info"></div></td>
						</tr>
					</cfif>	
				</cfif>	
			</div>
		</cf_box_footer>
	</cf_box>
</cfif>
	<!-- sil -->
		<form name="del_invoice" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=invoice.emptypopup_del_invoice_contract_comparisons">
			<input type="hidden" name="del_id_list" id="del_id_list" value="" /><!--- 1.invoice_id,2.invoice_row_id,3.cost_id --->
			<input type="hidden" name="del_url_list" id="del_url_list" value="" />
		</form>
	<!-- sil -->
	<!--- if icine dahil edilmesin, silme isleminde url kullaniliyor --->
	<cfset url_str = "&is_submitted=1">
	<cfif len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
	<cfif len(attributes.pur_sales_info)><cfset url_str = "#url_str#&pur_sales_info=#attributes.pur_sales_info#"></cfif>
	<cfif len(attributes.result_info)><cfset url_str = "#url_str#&result_info=#attributes.result_info#"></cfif>
	<cfif len(attributes.inv_purchase_sales)><cfset url_str = "#url_str#&inv_purchase_sales=#attributes.inv_purchase_sales#"></cfif>
	<cfif len(attributes.list_type)><cfset url_str = "#url_str#&list_type=#attributes.list_type#"></cfif>
	<cfif len(attributes.diff_type)><cfset url_str = "#url_str#&diff_type=#attributes.diff_type#"></cfif>
	<cfif len(attributes.company) and len(attributes.consumer_id)><cfset url_str = "#url_str#&company=#attributes.company#&consumer_id=#attributes.consumer_id#"></cfif>
	<cfif len(attributes.company) and len(attributes.partner_id)><cfset url_str = "#url_str#&company=#attributes.company#&company_id=#attributes.company_id#&partner_id=#attributes.partner_id#"></cfif>
	<cfif len(attributes.product_name) and len(attributes.product_id)><cfset url_str = "#url_str#&product_name=#attributes.product_name#&product_id=#attributes.product_id#"></cfif>
	<cfif len(attributes.project_head) and len(attributes.project_id)><cfset url_str = "#url_str#&project_head=#attributes.project_head#&project_id=#attributes.project_id#"></cfif>
	<cfif len(attributes.date1)><cfset url_str = "#url_str#&date1=#attributes.date1#"></cfif>
	<cfif len(attributes.date2)><cfset url_str = "#url_str#&date2=#attributes.date2#"></cfif>
	<cfif get_comparison.recordcount and (attributes.totalrecords gte attributes.maxrows)>
		<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#attributes.fuseaction##url_str#">
	</cfif>
</div>
<br/>
<script type="text/javascript">
document.getElementById('keyword').focus();
function input_control()
	{
		if(inv_form.diff_type.value == 11)
		{
			if((inv_form.consumer_id.value == "" || inv_form.company_id.value == "") &&  (inv_form.company.value == ""))
			{
				alert("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz'> !");
				return false;
			}
		}
		<cfif not session.ep.our_company_info.unconditional_list>
			if ((inv_form.date1.value == "" || inv_form.date2.value == "") && (inv_form.consumer_id.value == "" || inv_form.company_id.value == "" || inv_form.company.value == ""))
				{
					alert("<cf_get_lang dictionary_id='57526.En az bir alanda filtre etmelisiniz'>");
					return false;
				}
			else return true;
		<cfelse>
			return true;
		</cfif>
	}	
	function sil_islem()
	{
		var row_ = 0;
		var inv_id_list = 0;
		var inv_row_id_list = 0;
		var cost_id_list = 0;
		var all_id_list = "";
		<cfif get_comparison.recordcount>
			
			for (var i=0; i < <cfoutput>#get_comparison.recordcount#</cfoutput>; i++)
			{
				if((document.add_fark_faturasi.line_id[i]!=undefined && document.add_fark_faturasi.line_id[i].checked == true) || (document.add_fark_faturasi.line_id!=undefined && document.add_fark_faturasi.line_id.checked == true))
				{
					var row_ = i + 1;
					if(eval("document.add_fark_faturasi.invoice_id_" + row_ + ".value") != '')
						inv_id_list = eval("document.add_fark_faturasi.invoice_id_" + row_ + ".value");
						
					if(eval("document.add_fark_faturasi.invoice_row_id_" + row_ + ".value") != '')
						inv_row_id_list = eval("document.add_fark_faturasi.invoice_row_id_" + row_ + ".value");
						
					if(eval("document.add_fark_faturasi.cost_id_" + row_ + ".value") != '')
						cost_id_list = eval("document.add_fark_faturasi.cost_id_" + row_ + ".value");
					if(all_id_list == "")
						all_id_list = inv_id_list + '-' + inv_row_id_list + '-' + cost_id_list;
					else
						all_id_list = all_id_list + ';' + inv_id_list + '-' + inv_row_id_list + '-' + cost_id_list;
				}
			}
			if(row_ == 0)
			{
				alert("<cf_get_lang dictionary_id='54563.En Az Bir Satır Seçmelisiniz'>!");
				return false;
			}
			else if(all_id_list != "")
			{
				document.getElementById('del_id_list').value = all_id_list;
				document.getElementById('del_url_list').value = "<cfoutput>#url_str#</cfoutput>";
				document.del_invoice.submit();
			}
		</cfif>
	}	
	
	function hepsi_view()
	{
		if (document.add_fark_faturasi.all_view.checked)
		{
			if(<cfoutput>#get_comparison.recordcount#</cfoutput> == 1)
			{
				if(add_fark_faturasi.line_id!=undefined) document.add_fark_faturasi.line_id.checked = true;
			}
			else
			{
				for (var i=0; i < <cfoutput>#get_comparison.recordcount#</cfoutput>; i++) 
				{
					if(add_fark_faturasi.line_id[i]!=undefined) document.add_fark_faturasi.line_id[i].checked = true;
					
				}
			}
		}
		else
		{
			if(<cfoutput>#get_comparison.recordcount#</cfoutput> == 1)
			{
				if(add_fark_faturasi.line_id!=undefined) document.add_fark_faturasi.line_id.checked = false;
			}
			else
			{
				for (var i=0; i < <cfoutput>#get_comparison.recordcount#</cfoutput>; i++) 
					if(add_fark_faturasi.line_id[i]!=undefined)	document.add_fark_faturasi.line_id[i].checked = false;
			}
		}
	}	
	<cfif isdefined('attributes.is_submitted')>
		function KontrolEt_Gonder(i_type)	
		{
			var bool_i = 0 ;
			var inv_type_ ='';
			document.add_fark_faturasi.inv_type.value=i_type;
			<cfif get_comparison.recordcount eq 1>
				if(add_fark_faturasi.line_id.checked==false)
				{
					alert("<cf_get_lang dictionary_id='57280.Seçim Yapınız'>!");
					return false;
				} 
				else 
				{
					if(i_type != 4)//fark kaydı yapılmayacaksa
					{
						windowopen('','list','favourites_window');
						add_fark_faturasi.target='favourites_window';
						add_fark_faturasi.action="<cfoutput>#request.self#?fuseaction=invoice.popup_add_contract_compare_product</cfoutput>";
						add_fark_faturasi.submit();
						if(add_fark_faturasi.invoice_type_1.value == 0)
							window.location.href='<cfoutput>#request.self#?fuseaction=invoice.form_add_bill</cfoutput>';<!--- add_new_diff_invoice --->
						else
							window.location.href='<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchase</cfoutput>';
					}
					else
					{
						gizle_goster(quota_result_info);
						AjaxFormSubmit('add_fark_faturasi','show_quota_result_info',0,'<cf_get_lang dictionary_id="58889.Kaydediliyor">','<cf_get_lang dictionary_id="58890.Kaydedildi">!',"","",1);
						add_fark_faturasi.action="";
						row_info_2.style.display='';
						row_info_1.style.display='none';
					}
				}
			<cfelse>	
				for (var i=0; i < <cfoutput>#get_comparison.recordcount#</cfoutput>; i++) 
				{
					if(add_fark_faturasi.line_id[i]!=undefined && add_fark_faturasi.line_id[i].checked)
					{
						bool_i = 1;
						if(inv_type_!='' && eval('add_fark_faturasi.invoice_type_'+add_fark_faturasi.line_id[i].value).value != inv_type_)
						{
							alert("<cf_get_lang dictionary_id='57403.Fatura Tipler Uyuşmuyor'>");
							return false;		
						}
						inv_type_=eval('add_fark_faturasi.invoice_type_'+add_fark_faturasi.line_id[i].value).value;
					}
				}
				if (bool_i == 0)
				{
					alert("<cf_get_lang dictionary_id='57280.Seçim Yapınız'>!");
					return false;			
				} 
				else 
				{
					if(i_type != 4)//fark kaydı yapılmayacaksa
					{
						windowopen('','list','favourites_window');
						add_fark_faturasi.target='favourites_window';
						add_fark_faturasi.action="<cfoutput>#request.self#?fuseaction=invoice.popup_add_contract_compare_product</cfoutput>";
						add_fark_faturasi.submit();
						if(inv_type_ == 0)
							inv_form.action="<cfoutput>#request.self#?fuseaction=invoice.form_add_bill</cfoutput>";
						else
							inv_form.action="<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchase</cfoutput>";
						inv_form.submit();
						return true;
					}
					else
					{
						gizle_goster(quota_result_info);
						AjaxFormSubmit('add_fark_faturasi','show_quota_result_info',0,'<cf_get_lang dictionary_id="58889.Kaydediliyor">','<cf_get_lang dictionary_id="58890.Kaydedildi">!',"","",1);
						add_fark_faturasi.action="";
						row_info_2.style.display='';
						row_info_1.style.display='none';
					}
				}
			</cfif>
		}
	</cfif>

	$(".money_class").click(function(){

		deger_artis =  { <cfoutput query="get_money"> #money# : { money : 0.0, counter : 0 , system_money : 0.0 , system_money_counter : 0 } ,</cfoutput> };
		var default_deger = [];
			for(var i in deger_artis) default_deger.push([i, deger_artis[i]]);

			default_deger.forEach( (e) => {
				$('#deger_artis_'+e[0]).val(0).parent().find("span.input-group-addon > strong").html(0);
			});
		i=0;
		$('.money_class').each(function() {
			type = $(this).attr("money_type"); 
                if(this.checked && !$(this).hasClass("checkAll") ){
					deger_artis[type]["money"] += parseFloat($(this).attr("total_other_value"));
					deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"] += parseFloat(filterNum($(this).attr("total_value"))); 
					deger_artis[type]["counter"] ++;
					deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money_counter"]++;
                }
                if( !$(this).hasClass("checkAll") ) {
                    $('#deger_artis_'+type).val(commaSplit(deger_artis[type]["money"])).parent().find("span.input-group-addon > strong").html(deger_artis[type]["counter"]);
                }

		});
		$("#deger_artis_system").val(commaSplit(deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"],2)).parent().find("span.input-group-addon > strong").html(deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money_counter"]);

	});

	
</script>
