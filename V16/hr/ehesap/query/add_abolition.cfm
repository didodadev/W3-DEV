<cfif LEN(attributes.ABOLITION_DATE)>
	<cf_date tarih='attributes.ABOLITION_DATE'>
</cfif>

<cfquery name="add_rec" datasource="#DSN#">
	INSERT INTO
		EMPLOYEE_ABOLITION
		(
			ABOLITION_SUBJECT,
			INTEREST,
			ABOLITION_DATE,
			MANAGER_ID,
			ABOLITION_DETAIL,
			EVENT_ID,
			FROM_WHO
		)
	VALUES
		(
			'#attributes.ABOLITION_SUBJECT#',
			'#attributes.INTEREST#',
			<cfif LEN(attributes.ABOLITION_DATE)>#attributes.ABOLITION_DATE#,<cfelse>NULL,</cfif>
			#attributes.HEAD_QUATER_ID#,
			'#attributes.ABOLITION_DETAIL#',
			#attributes.EVENT_ID#,
			'#attributes.FROM_WHO#'
		)
</cfquery>
<script type="text/javascript">
	window.close();
</script>
