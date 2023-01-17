<cf_date tarih='attributes.action_date'>
<cfquery name="add_" datasource="#dsn3#" result="add_r">
	UPDATE
		WAREHOUSE_RATES
	SET
		COMPANY_ID = #attributes.company_id#,
		BILL_TO_COMPANY_ID = <cfif len(attributes.bill_to_company_id) and len(attributes.bill_to_company)>#attributes.bill_to_company#<cfelse>NULL</cfif>,
		ACTION_DATE = #attributes.action_date#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		UPDATE_DATE = #NOW()#
	WHERE
		RATE_ID = #attributes.rate_id#
</cfquery>

<cfquery name="del_" datasource="#dsn3#">
	DELETE FROM WAREHOUSE_RATES_ROWS WHERE RATE_ID = #attributes.rate_id#
</cfquery>

<cfloop from="1" to="#attributes.rowcount#" index="sira">
	<cfif evaluate("attributes.row_kontrol_#sira#") eq 1>
		<cfset WAREHOUSE_TASK_TYPE_ID_ = evaluate("attributes.warehouse_task_type_id_#sira#")>
		<cfset PRODUCT_ID_ = evaluate("attributes.product_id_#sira#")>
		<cfset UNIT_ID_ = evaluate("attributes.unit_id_#sira#")>
		<cfset PRICE_ = evaluate("attributes.price_#sira#")>
		<cfset PRICE_MONEY_ = evaluate("attributes.price_money_#sira#")>
		<cfif isdefined("attributes.is_bill_#sira#")>
			<cfset IS_BILL_ = 1>
		<cfelse>
			<cfset IS_BILL_ = 0>
		</cfif>
		<cfset RATE1_ = evaluate("attributes.rate1_#sira#")>
		<cfset RATE2_ = evaluate("attributes.rate2_#sira#")>
		<cfset RATE_UNIT_ID_ = evaluate("attributes.rate_unit_id_#sira#")>
		<cfset RATE_CODE_ = evaluate("attributes.rate_code_#sira#")>
		
		<cfset RATE_INFO_ = wrk_eval("attributes.rate_info_#sira#")>
		
		<cfquery name="add_rows_" datasource="#dsn3#">
			INSERT INTO
				WAREHOUSE_RATES_ROWS
				(
				RATE_ID,
				WAREHOUSE_TASK_TYPE_ID,
				PRODUCT_ID,
				UNIT_ID,
				PRICE,
				PRICE_MONEY,
				IS_BILL,
				RATE1,
				RATE2,
				RATE_UNIT_ID,
				RATE_INFO,
				RATE_CODE
				)
				VALUES
				(
				#attributes.rate_id#,
				#WAREHOUSE_TASK_TYPE_ID_#,
				<cfif len(PRODUCT_ID_)>#PRODUCT_ID_#<cfelse>NULL</cfif>,
				<cfif len(UNIT_ID_)>#UNIT_ID_#<cfelse>NULL</cfif>,
				<cfif len(PRICE_)>#filternum(PRICE_)#<cfelse>NULL</cfif>,
				'#PRICE_MONEY_#',
				#IS_BILL_#,
				<cfif len(RATE1_)>#filternum(RATE1_)#<cfelse>NULL</cfif>,
				<cfif len(RATE2_)>#filternum(RATE2_)#<cfelse>NULL</cfif>,
				'#RATE_UNIT_ID_#',
				'#RATE_INFO_#',
				<cfif len(RATE_CODE_)>#RATE_CODE_#<cfelse>NULL</cfif>
				)
		</cfquery>
	</cfif>
</cfloop>
<cfquery name="add_rows_" datasource="#dsn3#">
	UPDATE
		WAREHOUSE_RATES_ROWS
	SET
		RATE_CODE = ROW_ID
	WHERE
		RATE_CODE IS NULL
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.list_warehouse_rates&event=upd&rate_id=#attributes.rate_id#" addtoken="no">