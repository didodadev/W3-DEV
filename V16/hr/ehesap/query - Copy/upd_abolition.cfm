<cfif isdefined("attributes.is_del")>
	 <cfquery datasource="#DSN#">
 		DELETE
		FROM
		 	EMPLOYEE_ABOLITION
		WHERE
			EVENT_ID=#attributes.del_id#
	</cfquery>
	<script type="text/javascript">
		window.close();
		wrk_opener_reload();
	</script>	
	<cfabort>
</cfif>
<cfif LEN(attributes.ABOLITION_DATE)>
	<cf_date tarih='attributes.ABOLITION_DATE'>
</cfif>
<cfquery name="add_rec" datasource="#DSN#">
	UPDATE
		EMPLOYEE_ABOLITION
	SET
		ABOLITION_SUBJECT='#attributes.ABOLITION_SUBJECT#',
		INTEREST='#attributes.INTEREST#',
		ABOLITION_DATE=<cfif LEN(attributes.ABOLITION_DATE)>#attributes.ABOLITION_DATE#,<cfelse>NULL,</cfif>
		MANAGER_ID=#attributes.HEAD_QUATER_ID#,
		EVENT_ID=#attributes.EVENT_ID#,
		ABOLITION_DETAIL='#attributes.ABOLITION_DETAIL#',
		FROM_WHO='#attributes.FROM_WHO#'
	WHERE
		ABOLITION_ID=#attributes.ABOLITION_ID#
</cfquery>
<script type="text/javascript">
	window.close();
</script>
