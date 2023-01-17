<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="add_project_rate" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				PROJECT_ACCOUNT_RATES
				(
					ACCOUNT_BILL_TYPE,
					MONTH,
					YEAR,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES
				(
					#attributes.period_code_cat#,
					#attributes.sal_mon#,
					#attributes.sal_year#,
					#NOW()#,
					#SESSION.EP.USERID#,
				   '#CGI.REMOTE_ADDR#'
				)
		</cfquery>
		<cfset new_payroll_id = MAX_ID.IDENTITYCOL>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol_#i#") and evaluate("attributes.row_kontrol_#i#") eq 1>
				<cfscript>
					attributes.project_id = Evaluate("attributes.project_id#i#");
					attributes.rate = filterNum(Evaluate("attributes.rate#i#"));
				</cfscript>
				<cfquery name="add_payroll_accounts_row" datasource="#dsn#">
					INSERT INTO PROJECT_ACCOUNT_RATES_ROW
					(
						PROJECT_RATE_ID,
						PROJECT_ID,
						RATE
					)
					VALUES
					(	
						#new_payroll_id#,
						#attributes.project_id#,
						#attributes.rate#
					)
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cfset attributes.actionId = MAX_ID.IDENTITYCOL>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
		location.reload();
	</cfif>
</script>
