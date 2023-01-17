<cfquery name="GET_MODULE_ID" datasource="#DSN#">
	SELECT MAX(MODULE_ID) AS MODULE_ID FROM MODULES ORDER BY MODULE_ID 
</cfquery>
<cfscript>
	attributes.level_id = "";
	for (loop_level=1; loop_level lte get_module_id.module_id; loop_level=loop_level+1)
		if (IsDefined("attributes.level_id_#loop_level#"))
			attributes.level_id = ListAppend(attributes.level_id,Evaluate("attributes.level_id_#loop_level#"));
		else
			attributes.level_id = ListAppend(attributes.level_id,0);
</cfscript>

<cf_date tarih="attributes.note_date">
<cflock timeout="60">
	<cftransaction>
		<cfquery name="UPD_UPGRADE_NOTES" datasource="#DSN#">
			UPDATE 
				WRK_UPGRADE_NOTES
			SET 
				UPGRADE_NOTE_HEAD = '#attributes.note_head#',
				UPGRADE_CAT_ID = #attributes.upgrade_cat_id#,
				VERSION = #attributes.upgrade_version#,
				RELEASE = #attributes.upgrade_release#,
				NOTE_STAGE = #attributes.process_stage#,
				NOTE_DATE = #attributes.note_date#,
				NOTE_EMP_ID = #attributes.note_emp_id#,
				DETAIL = '#attributes.detail#',
				CODE = '#attributes.code#',
				MODULE_LEVEL_ID = '#attributes.level_id#',
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE 
				UPGRADE_NOTE_ID = #attributes.upgrade_note_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.list_upgrade_note" addtoken="no">
