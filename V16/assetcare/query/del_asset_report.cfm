<cfif isdefined("attributes.care_id") and len(attributes.care_id)>
	<cfquery name="del_asset" datasource="#dsn#">
        DELETE FROM CARE_STATES WHERE CARE_ID=#attributes.care_id#
    </cfquery>
</cfif>
<script type="text/javascript">
	window.location.href ='<cfoutput>#request.self#?fuseaction=assetcare.list_assetp_period&form_submitted=1</cfoutput>';
</script>
