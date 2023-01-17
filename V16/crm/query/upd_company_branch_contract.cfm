<cflock name="#createUUID()#" timeout="100">
	<cftransaction>
		<cfif (attributes.old_customer_type neq attributes.customer_type) or (attributes.old_endorsement_cat neq attributes.endorsement_cat) or
			(attributes.old_main_location_cat neq attributes.main_location_cat) or (attributes.old_profitability_cat neq attributes.profitability_cat) or
			(attributes.old_risk_cat neq attributes.risk_cat) or (attributes.old_special_state_cat neq attributes.special_state_cat) or
			(attributes.old_target_customer_type neq attributes.target_customer_type)>
	
			<cfquery name="INSERT_COMPANY_BRANCH_RELATED" datasource="#DSN#">
				INSERT INTO
					COMPANY_BRANCH_RELATED_HISTORY
				(
					RELATED_ID,
					CUSTOMER_TYPE_ID,
					TARGET_CUSTOMER_TYPE_ID,
					MAIN_LOCATION_CAT_ID,
					ENDORSEMENT_CAT_ID,
					PROFITABILITY_CAT_ID,
					RISK_CAT_ID,
					SPECIAL_STATE_CAT_ID,
					IS_CONTRACT_REQUIRED,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP							
				)
				VALUES
				(
					#attributes.related_id#,
					<cfif len(attributes.old_customer_type)>#attributes.old_customer_type#<cfelse>NULL</cfif>,
					<cfif len(attributes.old_target_customer_type)>#attributes.old_target_customer_type#<cfelse>NULL</cfif>,
					<cfif len(attributes.old_main_location_cat)>#attributes.old_main_location_cat#<cfelse>NULL</cfif>,
					<cfif len(attributes.old_endorsement_cat)>#attributes.old_endorsement_cat#<cfelse>NULL</cfif>,
					<cfif len(attributes.old_profitability_cat)>#attributes.old_profitability_cat#<cfelse>NULL</cfif>,
					<cfif len(attributes.old_risk_cat)>#attributes.old_risk_cat#<cfelse>NULL</cfif>,
					<cfif len(attributes.old_special_state_cat)>#attributes.old_special_state_cat#<cfelse>NULL</cfif>,
					#attributes.is_contract_req#,
					#CreateODBCDateTime(attributes.record_date)#,
					#attributes.record_emp#,
					'#attributes.record_ip#'	
				)
			</cfquery>
		</cfif>

		<cfquery name="ADD_COMPANY_RELATED" datasource="#DSN#">
			UPDATE
				COMPANY_BRANCH_RELATED
			SET
				CUSTOMER_TYPE_ID = <cfif len(attributes.customer_type)>#attributes.customer_type#<cfelse>NULL</cfif>,
				TARGET_CUSTOMER_TYPE_ID = <cfif len(attributes.target_customer_type)>#attributes.target_customer_type#<cfelse>NULL</cfif>,
				MAIN_LOCATION_CAT_ID = <cfif len(attributes.main_location_cat)>#attributes.main_location_cat#<cfelse>NULL</cfif>,
				ENDORSEMENT_CAT_ID = <cfif len(attributes.endorsement_cat)>#attributes.endorsement_cat#<cfelse>NULL</cfif>,
				PROFITABILITY_CAT_ID = <cfif len(attributes.profitability_cat)>#attributes.profitability_cat#<cfelse>NULL</cfif>,
				RISK_CAT_ID = <cfif len(attributes.risk_cat)>#attributes.risk_cat#<cfelse>NULL</cfif>,
				SPECIAL_STATE_CAT_ID = <cfif len(attributes.special_state_cat)>#attributes.special_state_cat#<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'		
			WHERE
				RELATED_ID = #attributes.related_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.opener.location.href='<cfoutput>#request.self#?fuseaction=crm.popup_list_consumer_branch&cpid=#attributes.cpid#&iframe=1</cfoutput>';
	window.close();
</script>
