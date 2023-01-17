<cfif len(attributes.TERM_DATE)>
	<cf_date tarih='attributes.TERM_DATE'>
</cfif>
<cfif len(attributes.AUDIT_DATE)>
	<cf_date tarih='attributes.AUDIT_DATE'>
</cfif>
<cfif len(attributes.AUDIT_RECHECK_DATE)>
	<cf_date tarih='attributes.AUDIT_RECHECK_DATE'>
</cfif>
<cfquery name="ADD_AUDIT" datasource="#dsn#">
	INSERT INTO
		EMPLOYEES_AUDIT
		(
			AUDIT_BRANCH_ID,
			AUDIT_DEPARTMENT_ID,
			AUDIT_DATE,
			AUDITOR,
			AUDIT_TYPE,
			AUDITOR_POSITION,
			AUDIT_MISSINGS,
			AUDIT_RECHECK_DATE,
			AUDIT_DETAIL,
			AUDIT_RESULT,
			PUNISHMENT_MONEY,
			PUNISHMENT_MONEY_TYPE,
			TERM_DATE,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
	VALUES
		(
			#attributes.AUDIT_BRANCH_ID#,
			<cfif len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,
			#attributes.AUDIT_DATE#,
			'#attributes.AUDITOR#',
			#attributes.AUDIT_TYPE#,
			'#attributes.AUDITOR_POSITION#',
			<cfif len(attributes.AUDIT_MISSINGS)>'#attributes.AUDIT_MISSINGS#',<cfelse>null,</cfif>
			<cfif len(attributes.AUDIT_RECHECK_DATE)>#attributes.AUDIT_RECHECK_DATE#,<cfelse>null,</cfif>
			<cfif len(attributes.AUDIT_DETAIL)>'#attributes.AUDIT_DETAIL#',<cfelse>null,</cfif>
			<cfif len(attributes.AUDIT_RESULT)>'#attributes.AUDIT_RESULT#',<cfelse>null,</cfif>
			<cfif len(attributes.punishment_money)>#attributes.punishment_money#,<cfelse>null,</cfif>
			#attributes.punishment_money_type#,
			<cfif len(attributes.term_date)>#attributes.term_date#,<cfelse>null,</cfif>
			#session.ep.userid#,
			'#cgi.REMOTE_ADDR#',
			#now()#
		)
</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>
