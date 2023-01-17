<cfquery name="del_credit_limit" datasource="#DSN3#">
	DELETE FROM CREDIT_LIMIT WHERE CREDIT_LIMIT_ID = #attributes.credit_limit_id#		
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>
