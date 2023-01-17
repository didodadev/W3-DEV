<cfquery name="ADD_SPECIAL_STATE_CAT" datasource="#DSN#">
	INSERT INTO
		SETUP_SPECIAL_STATE_CAT
	(
		SPECIAL_STATE_CAT,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	 ) 
	 VALUES 
	 (
		'#attributes.special_state_cat#',
		'#attributes.detail#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	 )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_special_state_cat" addtoken="no">
