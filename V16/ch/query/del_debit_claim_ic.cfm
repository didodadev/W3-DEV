<cfscript>
	cari_sil(action_id:attributes.action_id,process_type:attributes.process_type);
	muhasebe_sil(action_id:attributes.action_id,process_type:attributes.process_type);
	butce_sil(action_id:attributes.action_id,process_type:attributes.process_type);
</cfscript>	
<cfquery name="DEL_CARI_ACTION_MONEY" datasource="#dsn2#">
	DELETE FROM CARI_ACTION_MONEY WHERE ACTION_ID = #attributes.action_id#
</cfquery>
<cfquery name="DEL_FROM_CARI_ACTIONS" datasource="#dsn2#">
	DELETE FROM CARI_ACTIONS WHERE ACTION_ID = #attributes.action_id#
</cfquery>
