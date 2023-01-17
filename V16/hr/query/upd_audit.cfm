<cfif len(attributes.AUDIT_DATE)>
	<cf_date tarih='attributes.AUDIT_DATE'>
</cfif>
<cfif len(attributes.AUDIT_RECHECK_DATE)>
	<cf_date tarih='attributes.AUDIT_RECHECK_DATE'>
</cfif>
<cfif len(attributes.TERM_DATE)>
	<cf_date tarih='attributes.TERM_DATE'>
</cfif>
<cfquery name="UPD_AUDIT" datasource="#dsn#">
	UPDATE
		EMPLOYEES_AUDIT
	SET
		AUDIT_BRANCH_ID = #attributes.AUDIT_BRANCH_ID#,
		AUDIT_DEPARTMENT_ID = <cfif len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,
		AUDIT_DATE = #attributes.AUDIT_DATE#,
		AUDITOR = '#attributes.AUDITOR#',
		AUDIT_TYPE = #attributes.AUDIT_TYPE#,
		AUDITOR_POSITION = '#attributes.AUDITOR_POSITION#',
		AUDIT_MISSINGS =<cfif len(attributes.AUDIT_MISSINGS)> '#attributes.AUDIT_MISSINGS#',<cfelse>null,</cfif>
		AUDIT_RECHECK_DATE =<cfif len(attributes.AUDIT_RECHECK_DATE)>#attributes.AUDIT_RECHECK_DATE#,<cfelse>NULL,</cfif>
		AUDIT_DETAIL =<cfif len(attributes.AUDIT_DETAIL)> '#attributes.AUDIT_DETAIL#',<cfelse>null,</cfif>
		AUDIT_RESULT =<cfif len(attributes.AUDIT_RESULT)> '#attributes.AUDIT_RESULT#',<cfelse>null,</cfif>
		PUNISHMENT_MONEY=<cfif len(attributes.punishment_money)>#attributes.punishment_money#,<cfelse>null,</cfif>
		PUNISHMENT_MONEY_TYPE=#attributes.punishment_money_type#,
		TERM_DATE=<cfif len(attributes.term_date)>#attributes.term_date#,<cfelse>null,</cfif>
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		UPDATE_DATE = #now()#
	WHERE
		AUDIT_ID = #attributes.audit_id#
</cfquery>
<script type="text/javascript">
		location.href = document.referrer;
</script>
