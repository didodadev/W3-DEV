 <cf_date tarih='attributes.SIGN_DATE'>
<cf_date tarih='attributes.EVENT_DATE'>
 <cfquery datasource="#DSN#" result="MAX_ID">
 	INSERT INTO EMPLOYEES_EVENT_REPORT
	(
		TO_CAUTION,  
		SIGN_DATE,
		EVENT_DATE,
		WITNESS_1,
		WITNESS_2,
		WITNESS_3,
		DETAIL,
		EVENT_TYPE, 
		BRANCH_ID
	)
	VALUES
	(
		#attributes.caution_to_id#,
		#attributes.SIGN_DATE#,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.event_date_#">,
		<cfif LEN(attributes.witness1_id)>#attributes.witness1_id#,<cfelse>NULL,</cfif>
		<cfif LEN(attributes.witness2_id)>#attributes.witness2_id#,<cfelse>NULL,</cfif>
		<cfif LEN(attributes.witness3_id)>#attributes.witness3_id#,<cfelse>NULL,</cfif>
		'#attributes.DETAIL#',
		'#attributes.EVENT_TYPE#',
		#attributes.BRANCH_ID#
	)
</cfquery>

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_discipline_event&event=upd&event_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>
