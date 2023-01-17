<cfquery name="ADD_PROFITABILITY_CAT" datasource="#DSN#">
	INSERT INTO
		SETUP_PROFITABILITY_CAT
	(
		PROFITABILITY_CAT,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	 ) 
	 VALUES 
	 (
		'#attributes.profitability_cat#',
		'#attributes.detail#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	 )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_profitability_cat" addtoken="no">
