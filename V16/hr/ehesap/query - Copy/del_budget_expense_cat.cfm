<cfquery name="DEL_EXPENSE_CAT" datasource="#dsn2#">
	DELETE
	FROM 
		EXPENSE_CATEGORY
	WHERE 
		EXPENSE_CAT_ID=#URL.CAT_ID#
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		self.close();
	</cfif>	
</script>
