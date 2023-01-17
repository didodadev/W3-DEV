<!--- PUNISHMENT_ID 
PUNISHMENT_SUBJECT 
PUNISHMENT_DATE  
MANAGER_ID  
PUNISHMENT_DETAIL  
 --->
 
<cfif LEN(attributes.PUNISHMENT_DATE)>
	<cf_date tarih='attributes.PUNISHMENT_DATE'>
</cfif>

<cfquery name="add_rec" datasource="#DSN#">
	INSERT INTO
		EMPLOYEE_PUNISHMENT_PAPER
		(
			PUNISHMENT_SUBJECT,
			PUNISHMENT_DATE,
			MANAGER_ID,
			PUNISHMENT_DETAIL,
			EVENT_ID,
			FROM_WHO
			
		)
	VALUES
		(
			'#attributes.PUNISHMENT_SUBJECT#',
			<cfif LEN(attributes.PUNISHMENT_DATE)>#attributes.PUNISHMENT_DATE#,<cfelse>NULL,</cfif>
			#attributes.MANAGER_ID#,
			'#attributes.PUNISHMENT_DETAIL#',
			#attributes.EVENT_ID#,
			'#attributes.FROM_WHO#'
		)
</cfquery>
<script type="text/javascript">
	window.close();
</script>
