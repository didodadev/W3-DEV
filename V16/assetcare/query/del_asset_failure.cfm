<cfif isdefined("attributes.failure_id") and len(attributes.failure_id)>
	<cfquery name="del_asset" datasource="#dsn#">
        DELETE FROM ASSET_FAILURE_NOTICE  WHERE FAILURE_ID=#attributes.failure_id#
    </cfquery>
</cfif>
<script type="text/javascript">
	window.location.href ='<cfoutput>#request.self#?fuseaction=<cfif isdefined("attributes.correspondence")>correspondence<cfelse>assetcare</cfif>.list_asset_failure&form_submitted=1</cfoutput>';
</script>
