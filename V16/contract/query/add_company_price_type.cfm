<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<!--- Bu cariye ait onceki hareketler siliniyor --->
		<cfquery name="DEL_PRICE_CAT_EXCEPTIONS" datasource="#DSN3#">
			DELETE FROM
				PRICE_CAT_EXCEPTIONS
			WHERE
				ACT_TYPE = 2 AND
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>	
				COMPANY_ID = #attributes.company_id#
			<cfelse>
				CONSUMER_ID = #attributes.consumer_id#
			</cfif>
			<cfquery name="upd_company_credit" datasource="#DSN3#">
				UPDATE
					#dsn_alias#.COMPANY_CREDIT
				SET
					PRICE_CAT = NULL,
                    PRICE_CAT_PURCHASE = NULL
				WHERE
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>	
					COMPANY_ID = #attributes.company_id#
					AND OUR_COMPANY_ID = #session.ep.company_id#
			<cfelse>
					CONSUMER_ID = #attributes.consumer_id#
					AND OUR_COMPANY_ID = #session.ep.company_id#
			</cfif>
			</cfquery>
		</cfquery>
		<cfloop from="1" to="#attributes.record_num_2#" index="i">
			<cfif evaluate("attributes.row_kontrol_2#i#") neq 0 and len(evaluate("attributes.price_cat_2#i#"))>
				<cfif isdefined("attributes.is_default#i#") and evaluate("attributes.is_default#i#") and evaluate("attributes.purchase_sales#i#") eq 1>
					<cfquery name="upd_default" datasource="#DSN3#">
						UPDATE
							PRICE_CAT_EXCEPTIONS
						SET
							IS_DEFAULT = 0
						WHERE
							<cfif isdefined("attributes.company_id") and len(attributes.company_id)>	
								COMPANY_ID = #attributes.company_id#
								AND PURCHASE_SALES = 1
							<cfelse>
								CONSUMER_ID = #attributes.consumer_id#
								AND PURCHASE_SALES = 1
							</cfif>
					</cfquery>
					<cfquery name="upd_company_credit" datasource="#DSN3#">
						UPDATE
							#dsn_alias#.COMPANY_CREDIT
						SET
							PRICE_CAT = #evaluate("attributes.price_cat_2#i#")#
						WHERE
							<cfif isdefined("attributes.company_id") and len(attributes.company_id)>	
								COMPANY_ID = #attributes.company_id#
								AND OUR_COMPANY_ID = #session.ep.company_id#
							<cfelse>
								CONSUMER_ID = #attributes.consumer_id#
								AND OUR_COMPANY_ID = #session.ep.company_id#
							</cfif>

					</cfquery>
				</cfif>
                <cfif isdefined("attributes.is_default#i#") and evaluate("attributes.is_default#i#") and evaluate("attributes.purchase_sales#i#") eq 0>
					<cfquery name="upd_default" datasource="#DSN3#">
						UPDATE
							PRICE_CAT_EXCEPTIONS
						SET
							IS_DEFAULT = 0
						WHERE
							<cfif isdefined("attributes.company_id") and len(attributes.company_id)>	
								COMPANY_ID = #attributes.company_id#
								AND PURCHASE_SALES = 0
							<cfelse>
								CONSUMER_ID = #attributes.consumer_id#
								AND PURCHASE_SALES = 0
							</cfif>
					</cfquery>
					<cfquery name="upd_company_credit" datasource="#DSN3#">
						UPDATE
							#dsn_alias#.COMPANY_CREDIT
						SET
							PRICE_CAT_PURCHASE = #evaluate("attributes.price_cat_2#i#")#
						WHERE
							<cfif isdefined("attributes.company_id") and len(attributes.company_id)>	
								COMPANY_ID = #attributes.company_id#
								AND OUR_COMPANY_ID = #session.ep.company_id#
							<cfelse>
								CONSUMER_ID = #attributes.consumer_id#
								AND OUR_COMPANY_ID = #session.ep.company_id#
							</cfif>
					</cfquery>
				</cfif>
				<cfquery name="add_price_list_for_company" datasource="#DSN3#">
					<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
						INSERT INTO
							PRICE_CAT_EXCEPTIONS
						(
							COMPANY_ID,
							PRICE_CATID,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							ACT_TYPE,
							IS_DEFAULT,
							PURCHASE_SALES
						)
						VALUES
						(
							<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
							#evaluate("attributes.price_cat_2#i#")#,
							#session.ep.userid#,
							'#remote_addr#',
							#now()#,
							2,
							<cfif isdefined("attributes.is_default#i#") and evaluate("attributes.is_default#i#")>1<cfelse>0</cfif>,
							<cfif isdefined("attributes.purchase_sales#i#") and len(evaluate("attributes.purchase_sales#i#"))>#evaluate("attributes.purchase_sales#i#")#<cfelse>NULL</cfif>
						)
					<cfelse>
						INSERT INTO
							PRICE_CAT_EXCEPTIONS
						(
							CONSUMER_ID,
							PRICE_CATID,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							ACT_TYPE,
							IS_DEFAULT,
							PURCHASE_SALES
						)
						VALUES
						(
							<cfif  len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
							#evaluate("attributes.price_cat_2#i#")#,
							#session.ep.userid#,
							'#remote_addr#',
							#now()#,
							2,
							<cfif isdefined("attributes.is_default#i#") and evaluate("attributes.is_default#i#")>1<cfelse>0</cfif>,
							<cfif isdefined("attributes.purchase_sales#i#") and len(evaluate("attributes.purchase_sales#i#"))>#evaluate("attributes.purchase_sales#i#")#<cfelse>NULL</cfif>
						)
					</cfif>
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
<cfelse>
	<cfset attributes.actionId = attributes.consumer_id>
    <script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=contract.list_contracts&event=upd&consumer_id=#attributes.consumer_id#</cfoutput>"
    </script>
</cfif>