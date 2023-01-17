<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="DELBRANCH" datasource="#dsn#">
		DELETE FROM BRANCH	WHERE BRANCH_ID=#BRANCH_ID#
	</cfquery>
	<cf_add_log  log_type="-1" action_id="#attributes.branch_id#" action_name="#attributes.head#">
	</cftransaction>
</cflock>
<cfif isdefined("attributes.hr")>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_branches&hr=1';
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_branches';
	</script>
</cfif>

