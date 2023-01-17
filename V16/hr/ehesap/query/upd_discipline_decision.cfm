<cfif isdefined("attributes.is_del")>
	 <cfquery datasource="#DSN#">
 		DELETE
		FROM
		 	EMPLOYEE_DISCIPLINE_DECISION
		WHERE
			EVENT_ID=#attributes.del_id#
	</cfquery>

	<script type="text/javascript">
		window.close();
		wrk_opener_reload();
	</script>	
	<cfabort>
</cfif>
<cfif LEN(attributes.MEETING_DATE)>
	<cf_date tarih='attributes.MEETING_DATE'>
</cfif>
<cfif LEN(attributes.DECISION_DATE)>
	<cf_date tarih='attributes.DECISION_DATE'>
</cfif>
 <cfquery datasource="#DSN#">
 	UPDATE
		 EMPLOYEE_DISCIPLINE_DECISION
	SET
		MEETING_NO='#attributes.MEETING_NO#',
		MEETING_DATE=<cfif LEN(attributes.MEETING_DATE)>#attributes.MEETING_DATE#,<cfelse>NULL,</cfif>
		EVENT_ID=#attributes.EVENT_ID#,
		DECISION_NO='#attributes.DECISION_NO#',
		DECISION_DATE=<cfif LEN(attributes.DECISION_DATE)>#attributes.DECISION_DATE#,<cfelse>NULL,</cfif>
		DECISION_DETAIL=<cfif LEN(attributes.DECISION_DETAIL)>'#attributes.DECISION_DETAIL#',<cfelse>NULL,</cfif>
		MEMBER1=<cfif LEN(attributes.MEMBER1_ID)>#attributes.MEMBER1_ID#,<cfelse>NULL,</cfif>
		MEMBER2=<cfif LEN(attributes.MEMBER2_ID)>#attributes.MEMBER2_ID#,<cfelse>NULL,</cfif>
		CHAIRMAN=<cfif LEN(attributes.CHAIRMAN_ID)>#attributes.CHAIRMAN_ID#,<cfelse>NULL,</cfif>
		FOLDER_NO='#attributes.FOLDER_NO#',
		DELIVER_DATE=<cfif LEN(attributes.DELIVER_DATE)>#attributes.DELIVER_DATE#<cfelse>NULL</cfif>
	WHERE
		DISCIPLINE_ID=#attributes.DISCIPLINE_ID#
</cfquery>

<script type="text/javascript">
	window.close();
</script>
