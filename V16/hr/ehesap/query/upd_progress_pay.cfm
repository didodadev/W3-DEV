<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>
<cfquery name="upd_progress_payment" datasource="#dsn#">
UPDATE
	EMPLOYEE_PROGRESS_PAYMENT
SET
	EMPLOYEE_ID=#attributes.employee_id#,
	RELATED_COMPANY = '#attributes.related_company#',
	COMP_ID=#listgetat(attributes.branch_id,2,'-')#,
	BRANCH_ID=#listgetat(attributes.branch_id,1,'-')#,
	IS_KIDEM_PAY = <cfif isdefined("attributes.IS_KIDEM_PAY")>1,<cfelse>0,</cfif>
	KIDEM_AMOUNT = <cfif len(attributes.KIDEM_AMOUNT)>#attributes.KIDEM_AMOUNT#,<cfelse>NULL,</cfif>
	STARTDATE=#attributes.startdate#,
	FINISHDATE=#attributes.finishdate#,
	PROGRESS_DETAIL='#attributes.detail#',
	USED_OFFTIME = <cfif len(attributes.USED_OFFTIME)>#attributes.USED_OFFTIME#<cfelse>NULL</cfif>,
	WORKED_DAY=<cfif len(attributes.worked_day)>#attributes.worked_day#<cfelse>#datediff("d",attributes.startdate,attributes.finishdate)#</cfif>,
	UPDATE_EMP=#session.ep.userid#,
	UPDATE_IP='#cgi.REMOTE_ADDR#',
	UPDATE_DATE=#now()#
WHERE
	PROGRESS_ID=#attributes.progress_id#
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.event_type") and attributes.event_type eq 'popupUpd'>
		window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_emp_progress_payment&event=popupUpd&progress_id=#attributes.progress_id#</cfoutput>';
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_emp_progress_payment&event=upd&progress_id=#attributes.progress_id#</cfoutput>';
	</cfif>
	wrk_opener_reload();
	window.close();
</script>
