<cfquery name="ADD_INVOICE" datasource="#dsn2#" result="MAX_ID">
	INSERT INTO 
		INVOICE
	(
		WRK_ID,
		PURCHASE_SALES,
		INVOICE_NUMBER,
		INVOICE_CAT,
		INVOICE_DATE,
		NETTOTAL,
		GROSSTOTAL,
		TAXTOTAL,
		OTV_TOTAL,
		SA_DISCOUNT,
		SALE_EMP,
		DEPARTMENT_ID,
		DEPARTMENT_LOCATION,
		UPD_STATUS,
		OTHER_MONEY,
		OTHER_MONEY_VALUE,
		IS_WITH_SHIP,
		PROCESS_CAT,
		POS_CASH_ID,
		NOTE,
		EXPENSE_CENTER_ID,
		EXPENSE_ITEM_ID,
		RECORD_DATE,
		RECORD_EMP
	)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
		1,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
		#INVOICE_CAT#,
		#attributes.invoice_date#,
		#form.basket_net_total#,
		#form.basket_gross_total#,
		#form.basket_tax_total#,
		<cfif len(form.basket_otv_total)>#form.basket_otv_total#<cfelse>NULL</cfif>,
		#form.genel_indirim#,
		<cfif isDefined("attributes.employee_id") and len(attributes.employee_name)>#attributes.employee_id#,<cfelse>NULL,</cfif>
		#attributes.department_id#,
		#attributes.location_id#,
		1,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#">,
		#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
		0,
		#FORM.PROCESS_CAT#,
		#attributes.pos_cash_id#,
		<cfif isDefined("attributes.note") and len(attributes.note)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.note#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.expense_center") and len(attributes.expense_center) and len(attributes.expense_center_id)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)>#attributes.expense_item_id#<cfelse>NULL</cfif>,
		#NOW()#,
		#SESSION.EP.USERID#
	)
</cfquery>
<cfset get_invoice_id.max_id = MAX_ID.IDENTITYCOL>
<cfset karma_product_list="">
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfif isdefined('attributes.row_total#i#') and len(evaluate("attributes.row_total#i#"))>
		<cfset discount_amount = evaluate("attributes.row_total#i#")-evaluate("attributes.row_nettotal#i#") >
	<cfelse>
		<cfset discount_amount = 0>
	</cfif>
	<cfquery name="GET_MULTIPLIER" datasource="#dsn2#">
		SELECT MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = #evaluate("attributes.unit_id#i#")#
	</cfquery>
	<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and (not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#')))>
		<cfset dsn_type=dsn2>
		<cfinclude template="../../objects/query/add_basket_spec.cfm">
	</cfif>
	<cfinclude template="../../invoice/query/get_dis_amount.cfm">
	<cfquery name="ADD_INVOICE_ROW" datasource="#dsn2#">
		INSERT INTO
			INVOICE_ROW_POS
		(
			PRODUCT_ID,
			INVOICE_ID,
			STOCK_ID,
			<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
				SPECT_VAR_ID,
				SPECT_VAR_NAME,
			</cfif>
			AMOUNT,
			UNIT,
			UNIT_ID,				
			PRICE,
			DISCOUNTTOTAL,
			GROSSTOTAL,
			NETTOTAL,
			TAXTOTAL,
			TAX,
			OTHER_MONEY,
			OTHER_MONEY_VALUE,
			PRICE_OTHER,
			OTHER_MONEY_GROSS_TOTAL,
			MULTIPLIER,
			DISCOUNT1,
			DISCOUNT2,
			DISCOUNT3,
			DISCOUNT4,
			DISCOUNT5,
			DISCOUNT6,
			DISCOUNT7,
			DISCOUNT8,
			DISCOUNT9,
			DISCOUNT10,			
			IS_PROM
		)
		VALUES
		(
			#evaluate("attributes.product_id#i#")#,
			#MAX_ID.IDENTITYCOL#,
			#evaluate("attributes.stock_id#i#")#,
			<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
				#evaluate("attributes.spect_id#i#")#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.spect_name#i#")#'>,
			</cfif>
			#evaluate("attributes.amount#i#")#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.unit#i#")#'>,
			#evaluate("attributes.unit_id#i#")#,			
			#evaluate("attributes.price#i#")#,
			#discount_amount#,
			#evaluate("attributes.row_lasttotal#i#")#,
			#evaluate("attributes.row_nettotal#i#")#,
			#evaluate("attributes.row_taxtotal#i#")#,
			#evaluate("attributes.tax#i#")#,
			<cfif isdefined('attributes.other_money_#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.price_other#i#") and len(evaluate("attributes.price_other#i#"))>#evaluate("attributes.price_other#i#")#<cfelse>0</cfif>,
			<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
			#GET_MULTIPLIER.MULTIPLIER#,
			#indirim1#,
			#indirim2#,
			#indirim3#,
			#indirim4#,
			#indirim5#,
			#indirim6#,
			#indirim7#,
			#indirim8#,
			#indirim9#,
			#indirim10#,
			0
		)
	</cfquery>
	<cfset karma_product_list=listappend(karma_product_list,evaluate("attributes.product_id#i#"))>
</cfloop>
<cfif isdefined("attributes.tevkifat_box") and isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>
	<cfloop from="1" to="#form.basket_tax_count#" index="tax_i">
		<cfquery name="ADD_INVOICE_TAXES" datasource="#dsn2#">
			INSERT INTO
				INVOICE_TAXES
			(
				INVOICE_ID,
				TAX,
				TEVKIFAT_TUTAR,
				BEYAN_TUTAR					
			)
			VALUES
			(
				#MAX_ID.IDENTITYCOL#,
				#evaluate("attributes.basket_tax_#tax_i#")#,
				#evaluate("attributes.tevkifat_tutar_#tax_i#")#,
				#evaluate("attributes.basket_tax_value_#tax_i#")#   
			)
		</cfquery>
	</cfloop>
</cfif>
