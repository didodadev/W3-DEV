<cfquery name="ADD_DUTY_UNIT_CAT" datasource="#DSN#">
	INSERT INTO
		SETUP_DUTY_UNIT_CAT
	(
		DUTY_UNIT_CAT,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	 ) 
	 VALUES 
	 (
		'#attributes.duty_unit_cat#',
		'#attributes.detail#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	 )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_duty_unit_cat" addtoken="no">
