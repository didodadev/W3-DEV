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
		<cfquery name="ADD_UPGRADE_NOTES" datasource="#DSN#">
			INSERT INTO 
				WRK_UPGRADE_NOTES
			(
				UPGRADE_NOTE_HEAD,
				UPGRADE_CAT_ID,
				VERSION,
				RELEASE,
				NOTE_STAGE,
				NOTE_DATE,
				NOTE_EMP_ID,
				DETAIL,
				CODE,
				MODULE_LEVEL_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			) 
			VALUES 
			(
				'#attributes.note_head#',
				#attributes.upgrade_cat_id#,
				#attributes.upgrade_version#,
				#attributes.upgrade_release#,
				#attributes.process_stage#,
				#attributes.note_date#,
				#attributes.note_emp_id#,
				'#attributes.detail#',
				'#attributes.code#',
				'#attributes.level_id#',
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.list_upgrade_note" addtoken="no">
