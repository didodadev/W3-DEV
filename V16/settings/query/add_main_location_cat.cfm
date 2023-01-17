<cfquery name="ADD_MAIN_LOCATION_CAT" datasource="#DSN#">
	INSERT INTO
		SETUP_MAIN_LOCATION_CAT
	(
		MAIN_LOCATION_CAT,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	 ) 
	 VALUES 
	 (
		'#attributes.main_location_cat#',
		'#attributes.detail#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	 )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_main_location_cat" addtoken="no">
