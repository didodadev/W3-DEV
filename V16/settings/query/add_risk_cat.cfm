<cfquery name="ADD_ASSETP_CAT" datasource="#DSN#">
	INSERT INTO
		SETUP_RISK_CAT
	(
		RISK_CAT,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	 ) 
	 VALUES 
	 (
		'#attributes.risk_cat#',
		'#attributes.detail#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	 )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_risk_cat" addtoken="no">
