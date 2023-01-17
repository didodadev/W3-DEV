
<cfset flex_component = createObject("component","V16.myhome.cfc.flexible_worktime")>
<cfset upd_flexible_worktime = flex_component.approve_flexible(approve_id : approve_id, valid_type : valid_type)>
<script type="text/javascript">
	<cfif isdefined('approve_id') and valid_type eq 1>
		document.getElementById('approve_valid<cfoutput>#approve_id#</cfoutput>').innerHTML = '<cf_get_lang dictionary_id ="58699.Onaylandı">';
		document.getElementById('is_approve<cfoutput>#approve_id#</cfoutput>').value = 1;
	<cfelseif isdefined('approve_id') and valid_type eq -1>
		document.getElementById('approve_valid<cfoutput>#approve_id#</cfoutput>').innerHTML = '<cf_get_lang dictionary_id ="54645.Red Edildi">';
		document.getElementById('is_approve<cfoutput>#approve_id#</cfoutput>').value = '-1';
	</cfif>
</script>