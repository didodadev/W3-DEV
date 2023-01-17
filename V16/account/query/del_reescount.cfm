<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="del_reescount" datasource="#dsn2#">
			DELETE FROM REESCOUNT WHERE REESCOUNT_ID = #attributes.reescount_id#
		</cfquery>
		<cfquery name="del_reescount_rows" datasource="#dsn2#">
			DELETE FROM REESCOUNT_ROWS WHERE REESCOUNT_ID = #attributes.reescount_id#
		</cfquery>
		<cfscript>
			muhasebe_sil(action_id:attributes.reescount_id, process_type:302);
		</cfscript>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=account.list_reescount</cfoutput>';
</script>
