<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="add_project_rate" datasource="#dsn#">
			UPDATE
				PROJECT_ACCOUNT_RATES
			SET
				ACCOUNT_BILL_TYPE=#attributes.period_code_cat#,
				MONTH=#attributes.sal_mon#,
				YEAR=#attributes.sal_year#,
				UPDATE_DATE=#NOW()#,
				UPDATE_EMP=#SESSION.EP.USERID#,
				UPDATE_IP='#CGI.REMOTE_ADDR#'
			WHERE
				PROJECT_RATE_ID = #attributes.project_rate_id#
		</cfquery>	
		<cfset new_payroll_id = attributes.project_rate_id>
		<cfquery name="del_row" datasource="#dsn#">
			DELETE FROM PROJECT_ACCOUNT_RATES_ROW WHERE PROJECT_RATE_ID = #attributes.project_rate_id#
		</cfquery>
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
<cfset attributes.actionId = attributes.project_rate_id>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
		location.reload();
	</cfif>
</script>
