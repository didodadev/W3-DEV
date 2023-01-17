<cfif isdefined("attributes.is_del")>
	<cftransaction>
		 <cfquery datasource="#DSN#">
			DELETE
			FROM
				EMPLOYEE_DISCIPLINE_DECISION
			WHERE
				EVENT_ID=#attributes.event_id#
		</cfquery>
		 <cfquery datasource="#DSN#">
			DELETE
			FROM
				EMPLOYEE_ABOLITION
			WHERE
				EVENT_ID=#attributes.event_id#
		</cfquery>
		 <cfquery datasource="#DSN#">
			DELETE
			FROM
				EMPLOYEE_DEFENCE_DEMAND_PAPER
			WHERE
				EVENT_ID=#attributes.event_id#
		</cfquery>
		 <cfquery datasource="#DSN#">
			DELETE
			FROM
				EMPLOYEE_PUNISHMENT_PAPER
			WHERE
				EVENT_ID=#attributes.event_id#
		</cfquery>
		 <cfquery datasource="#DSN#">
			DELETE
			FROM
				EMPLOYEES_EVENT_REPORT
			WHERE
				EVENT_ID=#attributes.event_id#
		</cfquery>		
	</cftransaction>			
	<script type="text/javascript">
		window.close();
		wrk_opener_reload();
	</script>	
	<cfabort>
</cfif>
<cf_date tarih='attributes.SIGN_DATE'>
	<cf_date tarih='attributes.EVENT_DATE_'>
<cfquery datasource="#DSN#">
		UPDATE EMPLOYEES_EVENT_REPORT
		SET
			TO_CAUTION=#attributes.caution_to_id#,
			SIGN_DATE=#attributes.SIGN_DATE#,
			EVENT_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.event_date_#">,
			WITNESS_1=<cfif LEN(attributes.witness1_id)>#attributes.witness1_id#,<cfelse>NULL,</cfif>
			WITNESS_2=<cfif LEN(attributes.witness2_id)>#attributes.witness2_id#,<cfelse>NULL,</cfif>
			WITNESS_3=<cfif LEN(attributes.witness3_id)>#attributes.witness3_id#,<cfelse>NULL,</cfif>
			DETAIL='#attributes.DETAIL#',
			EVENT_TYPE='#attributes.EVENT_TYPE#',
			BRANCH_ID=#attributes.BRANCH_ID#
		WHERE EVENT_ID=#attributes.EVENT_ID#
			
</cfquery>

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_discipline_event&event=upd&event_id=#attributes.event_id#</cfoutput>';
</script>