<cfquery name="UPD_ASSET_STATE" datasource="#DSN#">
	UPDATE 
		ASSET_STATE
	SET
		ASSET_STATE = '#attributes.asset_state#',
		DETAIL = '#attributes.detail#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#		
	WHERE 
		ASSET_STATE_ID = #url.asset_state_id#	 
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_asset_state" addtoken="no">
