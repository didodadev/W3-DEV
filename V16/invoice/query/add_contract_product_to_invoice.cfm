<cfquery name="get_add_process_type" datasource="#DSN3#">
	SELECT
		SPC.PROCESS_CAT_ID
	FROM
		SETUP_PROCESS_CAT_ROWS AS SPCR,
		#dsn_alias#.EMPLOYEE_POSITIONS AS EP,
		SETUP_PROCESS_CAT SPC
	WHERE
		SPC.PROCESS_TYPE=
		<cfif attributes.inv_type eq 8>
			<cfif attributes.invoice_type eq 0>50<cfelse>51</cfif> AND
		<cfelse>
			<cfif attributes.invoice_type eq 0>58<cfelse>63</cfif> AND
		</cfif>
		SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID AND
		EP.POSITION_CODE=#session.ep.position_code# AND
		(
			SPCR.POSITION_CODE=EP.POSITION_CODE OR
			SPCR.POSITION_CAT_ID=EP.POSITION_CAT_ID
		)
</cfquery>
<cfif NOT get_add_process_type.RECORDCOUNT>
	<script type="text/javascript">
		alert('Fiyat Farkı Faturası İşlem Kategorisine Yetkiniz Yok!');
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_ROW_ALL" datasource="#dsn3#">
	SELECT 
		DISTINCT
		STOCKS.STOCK_ID,
		STOCKS.STOCK_CODE,
		STOCKS.BARCOD,
		STOCKS.MANUFACT_CODE,
		PRODUCT_PERIOD.ACCOUNT_PRICE ACCOUNT_CODE,
		PRODUCT_PERIOD.ACCOUNT_CODE_PUR,
		PRODUCT.IS_SERIAL_NO,
		STOCKS.PRODUCT_UNIT_ID,
		PRODUCT.PRODUCT_NAME,
		<cfif attributes.inv_type neq 8 and attributes.invoice_type eq 0><!---alış için verilen fiyat farkı faturası kesiliyorsa--->
			PRODUCT.TAX_PURCHASE AS TAX,
		<cfelse>
			PRODUCT.TAX,
		</cfif> 
		PRODUCT.PRODUCT_ID,
		PRODUCT.IS_PRODUCTION
	FROM
		STOCKS,
		PRODUCT_PERIOD,
		PRODUCT
	WHERE
		PRODUCT_PERIOD.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		PRODUCT_PERIOD.PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		PRODUCT.PRODUCT_ID IN (<cfloop from="1" to="#listlen(attributes.line_id)#" index="i">#Evaluate("attributes.product_id_#ListGetAt(attributes.line_id,i)#")#,</cfloop>0)
</cfquery>
<cfif not GET_ROW_ALL.RECORDCOUNT>
	<script type="text/javascript">
		alert('Ürünün Muhasebe Kodları Seçilmemiş');
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfquery name="get_add_unit_all" datasource="#DSN3#">
	SELECT ADD_UNIT,PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID IN (#ListDeleteDuplicates(ValueList(GET_ROW_ALL.PRODUCT_UNIT_ID))#)
</cfquery>

<cfset member_name = attributes.company_name>
<cfset partner_name=attributes.partner_name>
<cfset attributes.adres=replace(attributes.adres,chr(13)&chr(10),' ','all')>
<script type="text/javascript">
	opener.form_basket.comp_name.value = '<cfoutput>#member_name#</cfoutput>';
	opener.form_basket.partner_name.value='<cfoutput>#partner_name#</cfoutput>';
	opener.form_basket.consumer_id.value = '<cfoutput>#attributes.consumer_id#</cfoutput>';
	opener.form_basket.company_id.value = '<cfoutput>#attributes.company_id#</cfoutput>';
	opener.form_basket.partner_id.value = '<cfoutput>#attributes.partner_id#</cfoutput>';	
	opener.form_basket.member_account_code.value = '<cfoutput><cfif len(attributes.company_id)>#get_company_period(attributes.company_id)#<cfelse>#get_consumer_period(attributes.consumer_id)#</cfif></cfoutput>';
	opener.form_basket.department_id.value = '<cfoutput>#attributes.department_id#</cfoutput>';
	opener.form_basket.location_id.value = '<cfoutput>#attributes.department_location#</cfoutput>';
	opener.form_basket.department_name.value = '<cfoutput>#attributes.department_head#</cfoutput>';
	opener.form_basket.branch_id.value = '<cfoutput>#attributes.branch_id#</cfoutput>';
	<cfif attributes.invoice_type eq 0>
		opener.form_basket.adres.value = '<cfoutput>#attributes.adres#</cfoutput>';
		opener.form_basket.city_id.value = '<cfoutput>#attributes.city_id#</cfoutput>';
		opener.form_basket.county_id.value = '<cfoutput>#attributes.county_id#</cfoutput>';
	</cfif>
	<cfif listlen(attributes.line_id) eq 1>
		opener.form_basket.project_id.value = '<cfoutput>#attributes.proj_id#</cfoutput>';
		opener.form_basket.project_head.value = '<cfoutput>#attributes.proj_head#</cfoutput>';
	</cfif>
	opener.form_basket.process_cat.value = <cfoutput>#get_add_process_type.PROCESS_CAT_ID#</cfoutput>;
</script>
<cfloop from="1" to="#listlen(attributes.line_id)#" index="i">
		<cfset my_tax = Evaluate("tax_#ListGetAt(attributes.line_id,i)#")>
		<cfquery name="GET_ROW" dbtype="query" maxrows="1">
			SELECT * FROM GET_ROW_ALL WHERE PRODUCT_ID = #Evaluate("attributes.product_id_#ListGetAt(attributes.line_id,i)#")#
		</cfquery>
		<cfset p_unit_id = GET_ROW.PRODUCT_UNIT_ID>
		<cfquery name="get_add_unit" dbtype="query">
			SELECT ADD_UNIT FROM get_add_unit_all WHERE PRODUCT_UNIT_ID = #p_unit_id#
		</cfquery>
		<cfscript>
			if(len(Evaluate("attributes.amount_#ListGetAt(attributes.line_id,i)#")))
				amount=Evaluate("attributes.amount_#ListGetAt(attributes.line_id,i)#");
			if(not isdefined('amount') or not amount gt 0)amount=1;
			price = Evaluate("invoice_amount_#ListGetAt(attributes.line_id,i)#")/amount;
			price_other = Evaluate("invoice_amount_other_#ListGetAt(attributes.line_id,i)#")/amount;
			product_id = Evaluate("attributes.product_id_#ListGetAt(attributes.line_id,i)#"); //attributes.PRODUCT_ID
			stock_id = Evaluate("attributes.stock_id_#ListGetAt(attributes.line_id,i)#");
			due_diff_id = Evaluate("attributes.due_diff_id_#ListGetAt(attributes.line_id,i)#");
			stock_code = GET_ROW.BARCOD;
			manufact_code = GET_ROW.MANUFACT_CODE;
			name_product = Evaluate("attributes.product_detail_#ListGetAt(attributes.line_id,i)#");//GET_ROW.PRODUCT_NAME & " #Evaluate("invoice_date_#ListGetAt(attributes.line_id,i)#")# #Evaluate("invoice_number_#ListGetAt(attributes.line_id,i)#")# no lu ff #Evaluate("product_name#ListGetAt(attributes.line_id,i)#")#" ;
			unit_id = GET_ROW.PRODUCT_UNIT_ID;
			unit = get_add_unit.ADD_UNIT;
			tax = GET_ROW.TAX;
			account_code = GET_ROW.ACCOUNT_CODE;
			barcod = GET_ROW.BARCOD;
			invoice_row_id = Evaluate("invoice_row_id_#ListGetAt(attributes.line_id,i)#");
			cost_id = Evaluate("cost_id_#ListGetAt(attributes.line_id,i)#");
			is_production=GET_ROW.IS_PRODUCTION;
			other_money = Evaluate("attributes.other_money_#ListGetAt(attributes.line_id,i)#");
			temp_related_action_id_=Evaluate("contract_row_id_#ListGetAt(attributes.line_id,i)#");
			temp_related_table_='INVOICE_CONTRACT_COMPARISON';
			row_project_id = Evaluate("attributes.project_id_#ListGetAt(attributes.line_id,i)#");
			row_project_name = Evaluate("attributes.project_name_#ListGetAt(attributes.line_id,i)#");
		</cfscript>
		<script type="text/javascript">
			toplam_hesap=1;
			<cfoutput>	
				opener.form_basket.contract_row_ids.value = opener.form_basket.contract_row_ids.value + ',#temp_related_action_id_#';
				opener.add_basket_row('#product_id#', '#stock_id#', '#stock_code#', '#barcod#', '#manufact_code#', '#name_product#', '#unit_id#', '#unit#', '', '', '#price#', '#price_other#', '#tax#', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '', '', '', '#other_money#', 0,'#amount#','#account_code#',0,'#is_production#',0,0,0,'','','','','','','0','','','','0','','','',toplam_hesap,0,'','','','',0,'','','',0,'','#temp_related_action_id_#','#temp_related_table_#',0,0,0,'','#row_project_id#','#row_project_name#',0,'','','','','','','','','','','','','','');																																					 																																																								
			</cfoutput>
		</script>
</cfloop>
 <script type="text/javascript">
	window.close();
</script>
