<cfif fusebox.use_period eq true>
    <cfset dsn_expense = dsn2>
<cfelse>
    <cfset dsn_expense = dsn>
</cfif>
<cfquery name="DEL_EXPENSE" datasource="#dsn_expense#">
	DELETE
	FROM 
		EXPENSE_CENTER
	WHERE 
		EXPENSE_ID=#URL.EXPENSE_ID#
</cfquery>
<script type="text/javascript">
location.href = document.referrer;
	wrk_opener_reload();
	self.close();
</script>
