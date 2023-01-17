<cfsetting showdebugoutput="no">
<cfquery name="add_member_team" datasource="#dsn#">
	INSERT INTO 
		WORKGROUP_EMP_PAR
	(
		COMPANY_ID,
		OUR_COMPANY_ID,
		PARTNER_ID,
		ROLE_ID,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES
	(
		#attributes.company_id#,
		#session.pp.our_company_id#,
		#session.pp.userid#,
		#attributes.role_name#,
		'#cgi.remote_addr#',
		#now()#
	)
</cfquery>
