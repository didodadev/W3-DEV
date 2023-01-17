<cfquery name="DEL_USERS" datasource="#dsn#">
	DELETE 
	FROM
		USERS
	WHERE
		GROUP_ID = #attributes.GROUP_ID#
</cfquery>		
<cfif not len(attributes.process)>
<cflocation url="#request.self#?fuseaction=settings.form_add_users" addtoken="No">
<cfelse>
<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
</cfif>
