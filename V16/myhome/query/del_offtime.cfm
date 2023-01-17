<cfquery name="DEL_OFFTIME" datasource="#DSN#">
	DELETE FROM OFFTIME WHERE OFFTIME_ID=#attributes.OFFTIME_ID#
</cfquery>
<cfquery name="DEL_EVENT" datasource="#DSN#">
	DELETE FROM EVENT WHERE OFFTIME_ID=#attributes.OFFTIME_ID#
</cfquery>
<!--- Belge Silindiginde Bagli Uyari/Onaylar pasif hale gelir Esma R. Uysal 02/06/2020 --->
<cfset process_component = createObject("component","V16.objects.cfc.process_is_active")>
<cfset passive_process = process_component.PROCESS_IS_ACTIVE(action_table : 'OFFTIME', action_id : attributes.offtime_id, is_active : 0)>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=myhome.my_offtimes</cfoutput>';
</script>
