<cfquery name="add_reason" datasource="#dsn#"> 
	INSERT 
	INTO 
		SETUP_ALLOCATE_REASON
		(
			ALLOCATE_REASON,
			ALLOCATE_REASON_DETAIL,
			RECORD_IP,
			RECORD_DATE,
			RECORD_EMP
		) 
		VALUES 
		(
			'#attributes.allocate_reason#',
			<cfif len(attributes.allocate_reason_detail)>'#attributes.allocate_reason_detail#'<cfelse>null</cfif>,
			'#cgi.remote_addr#',
			#now()#,
			#session.ep.userid#
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_assetp_allocate_reason" addtoken="no">
