
<cfquery name="ADD_BANK_TYPE" datasource="#DSN#">
	INSERT INTO
		SETUP_BANK_TYPES
	(
		BANK_NAME,
		DETAIL,
		BANK_CODE,
		EXPORT_TYPE,
		SWIFT_CODE,
		COMPANY_ID,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
		BANK_TYPE_GROUP_ID
	)
	VALUES
	(
		'#attributes.bank_type#',
		<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		<cfif len(attributes.bank_code)>'#attributes.bank_code#'<cfelse>NULL</cfif>,
		<cfif len(attributes.export_type)>#attributes.export_type#,<cfelse>NULL,</cfif>
		<cfif len(attributes.swift_code)>'#attributes.swift_code#'<cfelse>NULL</cfif>,
		<cfif len(attributes.company) and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
		#session.ep.userid#,
		#now()#,
		'#cgi.remote_addr#',
		<cfif len(attributes.bank_type_group)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type_group#"><cfelse>NULL</cfif>
	)
</cfquery>
<cfquery name="bank_type" datasource="#dsn#">
	SELECT MAX(BANK_ID) AS BANK_ID FROM SETUP_BANK_TYPES
</cfquery>
<script type="text/javascript">	
	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_types&event=upd&id=#bank_type.BANK_ID#</cfoutput>';
</script>

