<cfif LEN(attributes.MEETING_DATE)>
	<cf_date tarih='attributes.MEETING_DATE'>
</cfif>
<cfif LEN(attributes.DECISION_DATE)>
	<cf_date tarih='attributes.DECISION_DATE'>
</cfif>
 <cfquery datasource="#DSN#">
 	INSERT INTO EMPLOYEE_DISCIPLINE_DECISION
	(
		MEETING_NO,
		MEETING_DATE,
<!--- 		PARTICIPATIONS, --->
		EVENT_ID,
		DECISION_NO,
		DECISION_DATE,
		DECISION_DETAIL,
		MEMBER1,
		MEMBER2,
		CHAIRMAN,
		FOLDER_NO,
		DELIVER_DATE
	)
	VALUES
	(
		'#attributes.MEETING_NO#',
		<cfif LEN(attributes.MEETING_DATE)>#attributes.MEETING_DATE#,<cfelse>NULL,</cfif>
		<!--- katilimcilar --->
		#attributes.EVENT_ID#,
		'#attributes.DECISION_NO#',
		<cfif LEN(attributes.DECISION_DATE)>#attributes.DECISION_DATE#,<cfelse>NULL,</cfif>
		'#attributes.DECISION_DETAIL#',
		<cfif LEN(attributes.MEMBER1_ID)>#attributes.MEMBER1_ID#,<cfelse>NULL,</cfif>
		<cfif LEN(attributes.MEMBER2_ID)>#attributes.MEMBER2_ID#,<cfelse>NULL,</cfif>
		<cfif LEN(attributes.CHAIRMAN_ID)>#attributes.CHAIRMAN_ID#,<cfelse>NULL,</cfif>
		'#attributes.FOLDER_NO#',
		<cfif LEN(attributes.DELIVER_DATE)>#attributes.DELIVER_DATE#<cfelse>NULL</cfif>
	)
</cfquery>

<script type="text/javascript">
	window.close();
</script>
