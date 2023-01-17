<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>
<cfquery name="add_progress_payment" datasource="#dsn#" result="MAX_ID">
INSERT INTO 
	EMPLOYEE_PROGRESS_PAYMENT
	(
		EMPLOYEE_ID,
		RELATED_COMPANY,
		COMP_ID,
		BRANCH_ID,
		IS_KIDEM_PAY,
		KIDEM_AMOUNT,
		STARTDATE,
		FINISHDATE,
		WORKED_DAY,
		USED_OFFTIME,
		PROGRESS_DETAIL,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES 
	(
		#attributes.employee_id#,
		'#attributes.RELATED_COMPANY#',
		#listgetat(attributes.branch_id,2,'-')#,
		#listgetat(attributes.branch_id,1,'-')#,
		<cfif isdefined("attributes.IS_KIDEM_PAY")>1,<cfelse>0,</cfif>
		<cfif len(attributes.KIDEM_AMOUNT)>#attributes.KIDEM_AMOUNT#,<cfelse>NULL,</cfif>
		#attributes.startdate#,
		#attributes.finishdate#,
		<cfif len(attributes.worked_day)>#attributes.worked_day#<cfelse>#datediff("d",attributes.startdate,attributes.finishdate)#</cfif>,
		<cfif len(attributes.USED_OFFTIME)>#attributes.USED_OFFTIME#<cfelse>NULL</cfif>,
		'#attributes.detail#',
		#session.ep.userid#,
		'#cgi.REMOTE_ADDR#',
		#now()#
	)
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event eq 'popupAdd'>
		window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_emp_progress_payment&event=popupUpd&progress_id=#MAX_ID.IDENTITYCOL#</cfoutput>';		
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_emp_progress_payment&event=upd&progress_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
	</cfif>
</script>
