<cfquery name="DEL_SMS_CONT" datasource="#dsn3#">
	DELETE
		CAMPAIGN_SMS_CONT
	WHERE
		SMS_CONT_ID = #attributes.SMS_CONT_ID#
</cfquery>	
<script type="text/javascript">
	<cfif isdefined('attributes.draggable')>
		location.href = document.referrer;
	<cfelse>
		window.close();
	</cfif>
</script>
