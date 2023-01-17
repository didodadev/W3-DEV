<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<!--- Bu cariye ait onceki hareketler siliniyor --->
		<cfif isDefined("attributes.form_upd_")>
			<cfquery name="DEL_PRICE_CAT_EXCEPTIONS" datasource="#DSN3#">
				DELETE FROM
					PRICE_CAT_EXCEPTIONS
				WHERE
					ISNULL(ACT_TYPE,1) IN(1,3) AND
				<cfif len(attributes.company_id)>	
					COMPANY_ID = #attributes.company_id#
				<cfelse>
					CONSUMER_ID = #attributes.consumer_id#
				</cfif>
			</cfquery>
		</cfif>
		<cfloop from="1" to="#attributes.record_num#" index="i">
		  <cfif evaluate("attributes.row_kontrol#i#") neq 0>
			<cfquery name="add_price_list_for_company" datasource="#DSN3#">
				INSERT INTO
					PRICE_CAT_EXCEPTIONS
				(
					COMPANY_ID,
					PRODUCT_CATID, 
					BRAND_ID, 
					PRODUCT_ID,
					PRICE_CATID,
					DISCOUNT_RATE,
					DISCOUNT_RATE_2,
					DISCOUNT_RATE_3,
					DISCOUNT_RATE_4,
					DISCOUNT_RATE_5,
					SHORT_CODE_ID,
					PAYMENT_TYPE_ID,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					ACT_TYPE
				)
				VALUES
				(
					<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.PRODUCT_CAT_ID#i#")) and len(evaluate("attributes.product_cat_name#i#"))>#evaluate("attributes.PRODUCT_CAT_ID#i#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.brand_id#i#")) and len(evaluate("attributes.brand_name#i#"))>#evaluate("attributes.brand_id#i#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.PRODUCT_ID#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.PRODUCT_ID#i#")#<cfelse>NULL</cfif>,
					#evaluate("attributes.price_cat#i#")#,
					<cfif len(evaluate("attributes.discount_info_#i#"))>#filternum(evaluate("attributes.discount_info_#i#"))#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.discount_info2_#i#"))>#filternum(evaluate("attributes.discount_info2_#i#"))#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.discount_info3_#i#"))>#filternum(evaluate("attributes.discount_info3_#i#"))#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.discount_info4_#i#"))>#filternum(evaluate("attributes.discount_info4_#i#"))#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.discount_info5_#i#"))>#filternum(evaluate("attributes.discount_info5_#i#"))#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.short_code_id#i#") and len(evaluate("attributes.short_code_id#i#")) and isdefined("attributes.short_code#i#") and len(evaluate("attributes.short_code#i#"))>#evaluate("attributes.short_code_id#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.payment_type_id#i#") and len(evaluate("attributes.payment_type_id#i#")) and isdefined("attributes.payment_type#i#")>#evaluate("attributes.payment_type_id#i#")#<cfelse>NULL</cfif>,
					#session.ep.userid#,
					'#remote_addr#',
					#now()#,
					1
				)
			</cfquery>
		  </cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset attributes.actionId = attributes.company_id>
    <script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=contract.list_contracts&event=upd&company_id=#attributes.company_id#</cfoutput>"
    </script>
	<cflocation addtoken="no" url="">
<cfelse>
	<cfset attributes.actionId = attributes.consumer_id>
    <script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=contract.list_contracts&event=upd&consumer_id=#attributes.consumer_id#</cfoutput>"
    </script>
</cfif>
