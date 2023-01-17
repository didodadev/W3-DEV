<cfif len(attributes.employee_password1)>
	<CF_CRYPTEDPASSWORD password="#attributes.employee_password1#" output="employee_password" mod="1">
</cfif>
<cfquery name="get_password_style" datasource="#dsn#">
		SELECT PASSWORD_HISTORY_CONTROL FROM PASSWORD_CONTROL WHERE PASSWORD_STATUS = 1
</cfquery>
<cfif get_password_style.PASSWORD_HISTORY_CONTROL gt 0>
	<cfquery name="get_olds" datasource="#dsn#" maxrows="#get_password_style.PASSWORD_HISTORY_CONTROL#">
		SELECT
			NEW_PASSWORD
		FROM
			EMPLOYEES_HISTORY
		WHERE
			IS_PASSWORD_CHANGE = 1 AND
			EMPLOYEE_ID = #SESSION.EP.USERID#
		ORDER BY
			EMPLOYEE_HISTORY_ID DESC			
	</cfquery>
	<cfif get_olds.recordcount>
		<cfoutput query="get_olds">
			<cfset pass_ = NEW_PASSWORD>
			<cfif pass_ is '#employee_password#'>
				<script type="text/javascript">
					document.account.pass_cont.value='1';
				</script>
				<cfabort>
			</cfif>
		</cfoutput>
	</cfif>
</cfif>
