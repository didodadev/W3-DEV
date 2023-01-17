

<cfquery name="upd_social_media" datasource="#dsn#">
	UPDATE 
		  SOCIAL_MEDIA_REPORT 
    SET
		  PROCESS_ROW_ID=#attributes.process_stage#,
		  UPDATE_DATE = #now()#,
		  UPDATE_EMP = #session.ep.userid#,
		  UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		  SID=#attributes.sid#
</cfquery>	

	<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#'
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_page='#request.self#?fuseaction=worknet.upd_social_media&sid=#attributes.sid#' 
			action_id='#attributes.sid#'>			
				
<cflocation url="#request.self#?fuseaction=worknet.upd_social_media&sid=#attributes.sid#" addtoken="no">	
				
				
				
