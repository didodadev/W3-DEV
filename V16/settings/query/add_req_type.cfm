<cfquery name="ADD_SETUP_REQ_TYPE" datasource="#DSN#"> 
	INSERT INTO 
    	SETUP_REQ_TYPE
	(
		REQ_NAME,
		REQ_DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
    ) 
    VALUES 
    (
		'#attributes.req_name#',
		'#attributes.req_detail#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#cgi.http_referer#" addtoken="no">
