<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">

<cfset startdate = date_add('n',attributes.start_min, attributes.startdate)>
<cfset startdate = date_add('h',attributes.start_hour, startdate)>
<cfset finishdate = date_add('n',attributes.finish_min, attributes.finishdate)>
<cfset finishdate = date_add('h',attributes.finish_hour, finishdate)>

<cfif listfirst(attributes.fuseaction,'.') is 'hr'> 
	<cfquery name="upd_emp_daily_in_out" datasource="#dsn#">
		UPDATE
			EMPLOYEE_DAILY_IN_OUT
		SET
			EMPLOYEE_ID = #attributes.employee_id#,
			IN_OUT_ID = <cfif len(attributes.in_out_id)>#attributes.in_out_id#,<cfelse>NULL,</cfif>
			BRANCH_ID = <cfif len(attributes.branch_id)>#attributes.branch_id#,<cfelse>NULL,</cfif>
			IS_WEEK_REST_DAY = <cfif Len(attributes.is_week_rest_day)>#attributes.is_week_rest_day#<cfelse>NULL</cfif>,
			START_DATE = <cfif len(startdate)>#startdate#,<cfelse>NULL,</cfif>
			FINISH_DATE = <cfif len(finishdate)>#finishdate#,<cfelse>NULL,</cfif>
			DETAIL = '#attributes.detail#',
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE
			ROW_ID = #attributes.row_id#
	</cfquery>
<cfelse>
	<cfquery name="upd_emp_daily_in_out" datasource="#dsn#">
		UPDATE
			EMPLOYEE_DAILY_IN_OUT
		SET
			PARTNER_ID = #attributes.partner_id#,
			IS_WEEK_REST_DAY = <cfif Len(attributes.is_week_rest_day)>#attributes.is_week_rest_day#<cfelse>NULL</cfif>,
			START_DATE = <cfif len(startdate)>#startdate#,<cfelse>NULL,</cfif>
			FINISH_DATE = <cfif len(finishdate)>#finishdate#,<cfelse>NULL,</cfif>
			DETAIL = '#attributes.detail#',
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE
			ROW_ID = #attributes.row_id#
	</cfquery>
</cfif>
<cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEE_DAILY_IN_OUT" target_table="EMPLOYEE_DAILY_IN_OUT_HISTORY" record_id= "#attributes.row_id#" record_name="ROW_ID">

<cfset attributes.actionId = attributes.row_id>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=hr.list_emp_daily_in_out_row&event=upd&ROW_ID=#attributes.actionId#</cfoutput>';
</script>
