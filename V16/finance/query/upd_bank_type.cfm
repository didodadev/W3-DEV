<cfquery name="UPD_BANK_TYPE" datasource="#DSN#">
	UPDATE
		SETUP_BANK_TYPES
	SET
		BANK_NAME = '#attributes.bank_type#',
		DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		BANK_CODE = <cfif len(attributes.bank_code)>'#attributes.bank_code#'<cfelse>NULL</cfif>,
		EXPORT_TYPE = <cfif len(attributes.export_type)>#attributes.export_type#<cfelse>NULL</cfif>,
		SWIFT_CODE = <cfif len(attributes.swift_code)>'#attributes.swift_code#'<cfelse>NULL</cfif>,
		COMPANY_ID = <cfif len(attributes.company) and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_EMP = #session.ep.userid#,
		BANK_TYPE_GROUP_ID = <cfif len(attributes.bank_type_group)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type_group#"><cfelse>NULL</cfif>
	WHERE
		BANK_ID = #attributes.id#
</cfquery>
<cfquery name="bank_type" datasource="#dsn#">
	SELECT MAX(BANK_ID) AS BANK_ID FROM SETUP_BANK_TYPES
</cfquery>
<script type="text/javascript">	
	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_types&event=upd&id=#attributes.id#</cfoutput>';
</script>

