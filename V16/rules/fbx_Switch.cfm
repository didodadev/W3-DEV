<cfinclude template="../fbx_switch_query.cfm">
<cfif get_fuseactions.recordcount>
    <cfinclude template="#get_fuseactions.folder#/#get_fuseactions.file_name#">
<cfelse>
	<cfset hata="5">
	<cfinclude template="../dsp_hata.cfm">
</cfif>