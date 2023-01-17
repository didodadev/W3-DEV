<cfquery name="ADD_ASSETP_CAT" datasource="#DSN#">
	INSERT INTO
		SETUP_ENDORSEMENT_CAT
	(
		ENDORSEMENT_CAT,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	 ) 
	 VALUES 
	 (
		'#attributes.endorsement_cat#',
		'#attributes.detail#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	 )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_endorsement_cat" addtoken="no">
