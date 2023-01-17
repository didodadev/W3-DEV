<cfquery name="ADD_BRANCH_CAT" datasource="#DSN#">
	INSERT INTO
		SETUP_BRANCH_CAT
	(
		BRANCH_CAT,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	 ) 
	 VALUES 
	 (
		'#attributes.branch_cat#',
		'#attributes.detail#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	 )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_branch_cat" addtoken="no">
