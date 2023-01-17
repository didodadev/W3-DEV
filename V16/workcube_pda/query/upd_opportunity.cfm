<cfinclude template="add_opportunity_history.cfm">
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_OPPORTUNITY" datasource="#DSN3#">
			UPDATE
				OPPORTUNITIES
			SET
				OPPORTUNITY_TYPE_ID = <cfif len(attributes.opportunity_type_id)>#attributes.opportunity_type_id#<cfelse>NULL</cfif>,
				<cfif attributes.member_type is 'partner'>
					PARTNER_ID = #attributes.member_id#,
					COMPANY_ID = #attributes.company_id#,
					CONSUMER_ID = NULL,
				<cfelseif attributes.member_type is 'consumer'>
					PARTNER_ID = NULL,
					COMPANY_ID = NULL,
					CONSUMER_ID = #attributes.member_id#,
				</cfif>
				<cfif attributes.ref_member_type is 'partner'>
					REF_PARTNER_ID = #attributes.ref_partner_id#,
					REF_COMPANY_ID = #attributes.ref_company_id#,
					REF_CONSUMER_ID = NULL,
					REF_EMPLOYEE_ID = NULL,
				<cfelseif attributes.ref_member_type is 'consumer'>
					REF_PARTNER_ID = NULL,
					REF_COMPANY_ID = NULL,
					REF_CONSUMER_ID = #attributes.ref_consumer_id#,
					REF_EMPLOYEE_ID = NULL,
				<cfelseif attributes.ref_member_type is 'employee'>
					REF_PARTNER_ID = NULL,
					REF_COMPANY_ID = NULL,
					REF_CONSUMER_ID = NULL,
					REF_EMPLOYEE_ID = #attributes.ref_employee_id#,
				<cfelse>
					REF_PARTNER_ID = NULL,
					REF_COMPANY_ID = NULL,
					REF_CONSUMER_ID = NULL,
					REF_EMPLOYEE_ID = NULL,
				</cfif>
				OPP_STAGE = <cfif isdefined("attributes.process_stage")>#attributes.process_stage#,<cfelse>NULL,</cfif>		
				OPP_DETAIL = <cfif len(attributes.opp_detail)>'#attributes.opp_detail#'<cfelse>NULL</cfif>,
				OPP_CURRENCY_ID = <cfif len(attributes.opp_currency_id)>#attributes.opp_currency_id#<cfelse>NULL</cfif>,
				OPP_HEAD = '#attributes.opp_head#',
				SALE_ADD_OPTION_ID = <cfif len(attributes.sales_add_option)>#attributes.sales_add_option#<cfelse>NULL</cfif>,
				UPDATE_EMP = #session.pda.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()#
			WHERE
				OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_id#">
		</cfquery>
	</cftransaction>
</cflock>

<cflocation addtoken="no" url="#request.self#?fuseaction=pda.form_upd_opportunity&opp_id=#attributes.opp_id#">

