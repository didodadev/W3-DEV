<cf_date tarih='attributes.start_date'>
	<cfif len(attributes.finish_date)>
		<cf_date tarih='attributes.finish_date'>
		<cfset fark_ = datediff("d",attributes.start_date,attributes.finish_date)+1>
	</cfif>
<cfquery name="upd_progress_payment_out" datasource="#dsn#">
	UPDATE
		EMPLOYEE_PROGRESS_PAYMENT_OUT
	SET
		EMP_ID = #attributes.emp_id#,
		IS_YEARLY = <cfif isdefined("attributes.is_yearly")>1,<cfelse>0,</cfif>
		IS_KIDEM = <cfif isdefined("attributes.is_kidem")>1,<cfelse>0,</cfif>
		START_DATE = #attributes.start_date#,
		FINISH_DATE = <cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
		DETAIL = '#attributes.detail#',
		PROGRESS_TIME = <cfif isdefined("fark_") and len(fark_)>#fark_#<cfelse>NULL</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		UPDATE_DATE = #now()#
	WHERE
		PROGRESS_PAYMENT_OUT_ID = #attributes.progress_payment_out_id#
</cfquery>
<script type="text/javascript">
	opener.window.location.reload();
	window.close();
</script>
