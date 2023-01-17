<cfif isdefined("attributes.is_del")>
	 <cfquery datasource="#DSN#">
 		DELETE
		FROM
		 	EMPLOYEE_PUNISHMENT_PAPER
		WHERE
			EVENT_ID=#attributes.del_id#
	</cfquery>
	<script type="text/javascript">
		window.close();
		wrk_opener_reload();
	</script>	
	<cfabort>
</cfif>
<cfif LEN(attributes.PUNISHMENT_DATE)>
	<cf_date tarih='attributes.PUNISHMENT_DATE'>
</cfif>

<cfquery name="add_rec" datasource="#DSN#">
	UPDATE	
		EMPLOYEE_PUNISHMENT_PAPER
	SET
			PUNISHMENT_SUBJECT='#attributes.PUNISHMENT_SUBJECT#',
			PUNISHMENT_DATE=<cfif LEN(attributes.PUNISHMENT_DATE)>#attributes.PUNISHMENT_DATE#,<cfelse>NULL,</cfif>
			MANAGER_ID=#attributes.MANAGER_ID#,
			PUNISHMENT_DETAIL='#attributes.PUNISHMENT_DETAIL#',
			EVENT_ID=#attributes.EVENT_ID#,
			FROM_WHO='#attributes.FROM_WHO#'
	WHERE
		PUNISHMENT_PAPER_ID=#attributes.PUNISHMENT_PAPER_ID#
</cfquery>
<script type="text/javascript">
	window.close();
</script>
