<cfif LEN(attributes.PAPER_DATE)>
	<cf_date  tarih='attributes.PAPER_DATE'>
<cfelse>
	<cfset attributes.PAPER_DATE=now()>	
</cfif>
<cfquery name="add_rec" datasource="#DSN#">
	INSERT INTO EMPLOYEE_DEFENCE_DEMAND_PAPER
	(	WRITER_ID,
		DETAIL,
		EVENT_ID,
		PAPER_DATE
	)
	VALUES
	(
		#attributes.writer_id#,
		'#attributes.DETAIL#',
		#attributes.event_id#,
		#attributes.PAPER_DATE#
	)
</cfquery>

<script type="text/javascript">
	window.close();
</script>
