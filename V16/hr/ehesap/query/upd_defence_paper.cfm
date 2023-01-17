<cfif isdefined("attributes.is_del")>
	 <cfquery datasource="#DSN#">
 		DELETE
		FROM
		 	EMPLOYEE_DEFENCE_DEMAND_PAPER
		WHERE
			EVENT_ID=#attributes.del_id#
	</cfquery>
	<script type="text/javascript">
		window.close();
		wrk_opener_reload();
	</script>	
	<cfabort>
</cfif>
<cfif LEN(attributes.PAPER_DATE)>
	<cf_date  tarih='attributes.PAPER_DATE'>
<cfelse>
	<cfset attributes.PAPER_DATE=now()>	
</cfif>

<cfquery name="add_rec" datasource="#DSN#">
	UPDATE 
		EMPLOYEE_DEFENCE_DEMAND_PAPER
	SET
		WRITER_ID=#attributes.writer_id#,
		DETAIL='#attributes.DETAIL#',
		<cfif isdefined("attributes.event_id")>
			EVENT_ID=#attributes.event_id#,
		<cfelse>
			DEFENCE_ID=#attributes.DEFENCE_id#,
		</cfif>
		PAPER_DATE=#attributes.PAPER_DATE#
	WHERE
		DEFENCE_ID=#attributes.DEFENCE_ID#
</cfquery>

<script type="text/javascript">
	window.close();
</script>
