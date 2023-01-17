<cfquery name="ADD_SETUP_COMPUTER_INFO" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_TRANSPORT_TYPES
		(
			UPPER_TRANSPORT_TYPE_ID,
			TRANSPORT_TYPE,
			TRANSPORT_TYPE_DETAIL,
			BRANCH_ID,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		) 
	VALUES 
		(
			<cfif isdefined("attributes.upper_transport_type_id")>#attributes.upper_transport_type_id#,<cfelse>NULL,</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TRANSPORT_type#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TRANSPORT_type_detail#">,
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
			#SESSION.EP.USERID#,
			#NOW()#,
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<script>
	location.href=document.referrer;
</script>

