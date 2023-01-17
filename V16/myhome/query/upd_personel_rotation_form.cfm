<cfif len(attributes.new_start_date)>
	<CF_DATE tarih="attributes.new_start_date">
<cfelse>
	<cfset attributes.new_start_date="">
</cfif>
<cfif len(attributes.rotation_finish_date)>
	<CF_DATE tarih="attributes.rotation_finish_date">
<cfelse>
	<cfset attributes.rotation_finish_date="">
</cfif>
<cfquery name="add_per_rot_form" datasource="#dsn#">
	UPDATE
		PERSONEL_ROTATION_FORM
	SET            
		TOOL_EXIST='#attributes.tool_exist#',
		TOOL_REQUEST='#attributes.tool_request#',
		TEL_EXIST='#attributes.tel_exist#',
		TEL_REQUEST='#attributes.tel_request#',
		OTHER_EXIST='#attributes.other_exist#',
		OTHER_REQUEST='#attributes.other_request#',
		NEW_START_DATE=<cfif len(attributes.new_start_date)>#attributes.new_start_date#<cfelse>NULL</cfif>,
		ROTATION_FINISH_DATE=<cfif len(attributes.rotation_finish_date)>#attributes.rotation_finish_date#<cfelse>NULL</cfif>,
		FORM_STAGE=<cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>
	WHERE
		ROTATION_FORM_ID=#attributes.per_rot_id#
</cfquery>
<cf_workcube_process 
	is_upd='1' 
	process_stage='#attributes.process_stage#' 
	old_process_line='#attributes.old_process_line#'
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='PERSONEL_ROTATION_FORM'
	action_column='ROTATION_FORM_ID'
	action_id='#attributes.per_rot_id#'
	action_page='#request.self#?fuseaction=myhome.upd_personel_rotation_form&per_rot_id=#attributes.per_rot_id#' 
	warning_description = 'Terfi-Transfer-Rotasyon Talep Formu : #attributes.per_rot_id#'>
<cflocation url="#request.self#?fuseaction=myhome.upd_personel_rotation_form&per_rot_id=#attributes.per_rot_id#" addtoken="no">
