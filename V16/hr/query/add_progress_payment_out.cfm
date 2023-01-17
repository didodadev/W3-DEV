<cf_date tarih='attributes.start_date'>
	<cfif len(attributes.finish_date)>
		<cf_date tarih='attributes.finish_date'>
		<cfset fark_ = datediff("d",attributes.start_date,attributes.finish_date)+1>
	</cfif>
<cfquery name="add_progress_payment_out" datasource="#dsn#">
	INSERT INTO
		EMPLOYEE_PROGRESS_PAYMENT_OUT
		(
			EMP_ID,
			START_DATE,
			FINISH_DATE,
			DETAIL,
			PROGRESS_TIME,
			IS_YEARLY,
			IS_KIDEM,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
	VALUES
		(
			#attributes.emp_id#,
			#attributes.start_date#,
			<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
			'#attributes.detail#',
			<cfif isdefined("fark_") and len(fark_)>#fark_#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.is_yearly")>1,<cfelse>0,</cfif>
			<cfif isdefined("attributes.is_kidem")>1,<cfelse>0,</cfif>
			#session.ep.userid#,
			'#cgi.REMOTE_ADDR#',
			#now()#
		)
</cfquery>
<script type="text/javascript">
	opener.window.location.reload();
	window.close();
</script>
