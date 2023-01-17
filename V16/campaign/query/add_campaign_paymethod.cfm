<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="DEL_PAYMETHOD" datasource="#dsn3#">
			DELETE FROM CAMPAIGN_PAYMETHODS WHERE CAMPAIGN_ID = #attributes.campaign_id#
		</cfquery>
		<cfloop from="1" to="#attributes.total_record#" index="i">
			<cfquery name="ADD_PAYMENT_PLAN_ROW" datasource="#dsn3#">
				INSERT INTO
					CAMPAIGN_PAYMETHODS
					(
						CAMPAIGN_ID,
						PAYMETHOD_ID,
						COMMISSION_RATE,
						SERVICE_COMM_PRODUCT_ID,
						SERVICE_COMM_STOCK_ID,
						SERVICE_COMM_MULTIPLIER,
						DAY_TO_ACC,
						USED_IN_CAMPAIGN,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP
					)
				VALUES
					(
						#attributes.campaign_id#,
						#evaluate("attributes.paymethod_id#i#")#,
						<cfif len(evaluate("attributes.comm_rate#i#"))>#evaluate("attributes.comm_rate#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.product_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.product_id#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.stock_id#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.stock_id#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.comm_multiplier#i#"))>#evaluate("attributes.comm_multiplier#i#")#,<cfelse>NULL,</cfif>
						<cfif len(evaluate("attributes.day_to_acc#i#"))>#evaluate("attributes.day_to_acc#i#")#,<cfelse>0,</cfif>
						<cfif isDefined("attributes.used_in_campaign#i#")>1,<cfelse>0,</cfif>
						#now()#,
						'#cgi.remote_addr#',
						#session.ep.userid#
					)
			</cfquery>
		</cfloop>
		<cfquery name="add_campaign_payment" datasource="#dsn3#">
			UPDATE 
				CAMPAIGNS 
			SET 
				IS_BEFORE_PAYMENT = <cfif isdefined("attributes.is_before_payment")and len(attributes.is_before_payment)>1<cfelse>0</cfif>
			WHERE
				CAMP_ID = #attributes.campaign_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
		 closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
</script>
