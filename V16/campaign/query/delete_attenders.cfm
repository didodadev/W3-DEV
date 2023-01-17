<cfquery name="UPD_CLASS" datasource="#DSN#">
	DELETE FROM
		ORGANIZATION_ATTENDER
	WHERE
		<cfif url.type eq 'employee'>
		EMP_ID = #url.id#
		<cfelseif url.type eq 'partner'>
		PAR_ID = #url.id#
		<cfelseif url.type eq 'consumer'>
		CON_ID =  #url.id#
		<cfelseif url.type eq 'group'> 
		GRP_ID = #url.id#
		</cfif>
		AND ORGANIZATION_ID = #url.organization_id#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

