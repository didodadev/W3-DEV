<cflock timeout="60">
	<cftransaction>
		<cfquery name="DEL_RISK_LIMIT_DEFINITION" datasource="#DSN#">
			DELETE FROM RISK_LIMIT_DEFINITION 
		</cfquery>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfscript>
				form_row_kontrol = evaluate("attributes.row_kontrol#i#");
				form_definition_id = evaluate("attributes.definition_id#i#");
				form_branch_cat = evaluate("attributes.branch_cat#i#");
				form_companycat_id = evaluate("attributes.companycat_id#i#");
				form_amount = evaluate("attributes.amount#i#");
				form_opening_upper_risk_limit = evaluate("attributes.opening_upper_risk_limit#i#");
			</cfscript>		
			<cfif form_row_kontrol eq 1>
				<cfquery name="ADD_RISK_LIMIT_DEFINITION" datasource="#DSN#">
					INSERT INTO
						RISK_LIMIT_DEFINITION
					(
						BRANCH_CAT_ID,
						COMPANY_CAT_ID,
						AMOUNT,
						OPENING_UPPER_RISK_LIMIT,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP						
					)
					VALUES
					(
						#form_branch_cat#,
						'#form_companycat_id#',
						'#form_amount#',
						#form_opening_upper_risk_limit#,
						#now()#,
						#session.ep.userid#,
						'#cgi.remote_addr#'
					)
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<script>
	location.href = document.referrer;
</script>
