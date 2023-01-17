<cftransaction>
	<cfquery name="DEL_CAMP_OPERATION" datasource="#DSN3#">
		DELETE FROM CAMPAIGN_OPERATION WHERE CAMP_ID = #attributes.camp_id#
	</cfquery>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#")>
			<cfset form_product_id = evaluate("attributes.product_id#i#")>
			<cfset form_product = evaluate("attributes.product#i#")>
			<cfset form_amount = evaluate("attributes.amount#i#")>
			<cfset form_unit_id = evaluate("attributes.unit_id#i#")>
			<cfset form_unit_name = evaluate("attributes.unit_name#i#")>
			<cfset form_price = evaluate("attributes.price#i#")>
			<cfset form_total_price = evaluate("attributes.total_price#i#")>
			<cfset form_discount = evaluate("attributes.discount#i#")>
			<cfset form_k_discount = evaluate("attributes.k_discount#i#")>
			<cfif isdefined("attributes.discount_amount#i#")>
				<cfset form_discount_amount = evaluate("attributes.discount_amount#i#")>
				<cfset form_k_discount_amount = evaluate("attributes.k_discount_amount#i#")>
			<cfelse>
				<cfset form_discount_amount = 0>
				<cfset form_k_discount_amount = 0>
			</cfif>
			<cfset form_money = evaluate("attributes.money#i#")>
			<cfset form_period = evaluate("attributes.period#i#")>
            <cfset form_repeat_number = evaluate("attributes.repeat_number#i#")>
			<cfset form_free_repeat_number = evaluate("attributes.free_repeat_number#i#")>
            <cfset form_wrk_row_id = evaluate("attributes.wrk_row_id#i#")>
            <cfset form_row_rate = evaluate("attributes.row_rate#i#")>
			<cfif isdefined("attributes.paymethod#i#")>
				<cfset form_paymethod = evaluate("attributes.paymethod#i#")>
				<cfset form_paymethod_id = evaluate("attributes.paymethod_id#i#")>
				<cfset form_card_paymethod_id = evaluate("attributes.card_paymethod_id#i#")>
			<cfelse>
				<cfset form_paymethod = ''>
				<cfset form_paymethod_id = ''>
				<cfset form_card_paymethod_id = ''>
			</cfif>
			<cfquery name="ADD_CAMPAIGN_OPERATION" datasource="#DSN3#">
				INSERT INTO
					CAMPAIGN_OPERATION
				(
					CAMP_ID,
				 	PRODUCT_ID,
					PRODUCT_NAME,
					AMOUNT,
					UNIT_ID,
					UNIT,
					PRICE, 
					TOTAL_PRICE,
					DISCOUNT,
					K_DISCOUNT,
					DISCOUNT_AMOUNT,
					K_DISCOUNT_AMOUNT,
					CURRENCY,
					PERIOD,
                    REPEAT_NUMBER,
					FREE_REPEAT_NUMBER,
                    WRK_ROW_ID, 
					PAYMETHOD_ID,
					CARD_PAYMETHOD_ID,
					RECORD_MEMBER,
					RECORD_IP,
					RECORD_DATE,
                    RATE					
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">,
					<cfif len(form_product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_product_id#"><cfelse>NULL</cfif>,
					<cfif len(form_product)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#form_product#"><cfelse>NULL</cfif>,
					<cfif len(form_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#form_amount#"><cfelse>NULL</cfif>,
					<cfif len(form_unit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_unit_id#"><cfelse>NULL</cfif>,
					<cfif len(form_unit_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#form_unit_name#"><cfelse>NULL</cfif>,
					<cfif len(form_price)><cfqueryparam cfsqltype="cf_sql_float" value="#form_price#"><cfelse>NULL</cfif>, 
					<cfif len(form_total_price)><cfqueryparam cfsqltype="cf_sql_float" value="#form_total_price#"><cfelse>NULL</cfif>, 
					<cfif len(form_discount)><cfqueryparam cfsqltype="cf_sql_float" value="#form_discount#"><cfelse>NULL</cfif>,
					<cfif len(form_k_discount)><cfqueryparam cfsqltype="cf_sql_float" value="#form_k_discount#"><cfelse>NULL</cfif>,
					<cfif len(form_discount_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#form_discount_amount#"><cfelse>NULL</cfif>,
					<cfif len(form_k_discount_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#form_k_discount_amount#"><cfelse>NULL</cfif>,
					<cfif len(form_money)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#form_money#"><cfelse>NULL</cfif>,
					<cfif len(form_period)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_period#"><cfelse>NULL</cfif>,
                    <cfif len(form_repeat_number)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_repeat_number#"><cfelse>NULL</cfif>,
					<cfif len(form_free_repeat_number)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_free_repeat_number#"><cfelse>NULL</cfif>,
                    <cfif len(form_wrk_row_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#form_wrk_row_id#"><cfelse>NULL</cfif>, 
					<cfif len(form_paymethod_id) and len(form_paymethod)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_paymethod_id#"><cfelse>NULL</cfif>,
					<cfif len(form_card_paymethod_id) and len(form_paymethod)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_card_paymethod_id#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfif len(form_row_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#form_row_rate#"><cfelse>NULL</cfif>
			   )
			</cfquery>
		</cfif>
	</cfloop>
</cftransaction>

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#attributes.camp_id#</cfoutput>';
</script>
