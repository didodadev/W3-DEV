<cfif len(attributes.sms_startdate)>
	<CF_DATE TARIH="attributes.sms_startdate">
	<cfset SMS_WARNING_DATE = date_add('H',attributes.SMS_START_CLOCK-session.ep.time_zone,attributes.SMS_startdate)>
	<cfset SMS_WARNING_DATE = date_add('M',attributes.START_MIN-session.ep.time_zone,attributes.SMS_startdate)>

<cfelse>
	<cfset SMS_WARNING_DATE = "NULL">
</cfif>
<cfif len(attributes.email_startdate)>
	<CF_DATE TARIH="attributes.email_startdate">
	<cfset EMAIL_WARNING_DATE = date_add('H',attributes.EMAIL_START_CLOCK-session.ep.time_zone,attributes.email_startdate)>
    <cfset EMAIL_WARNING_DATE = date_add('M',attributes.START_MIN1-session.ep.time_zone,attributes.email_startdate)>

<cfelse>
	<cfset EMAIL_WARNING_DATE = "NULL">
</cfif>

<cfif isDefined("attributes.response_date") and len(attributes.response_date)>
  <cf_date tarih="attributes.response_date">
	<cfset RESPONSE_DATE = date_add('h',attributes.response_clock-session.ep.time_zone,attributes.response_date)>
	<cfset RESPONSE_DATE = date_add('n',attributes.response_min,RESPONSE_DATE)>
<cfelse>
	<cfset RESPONSE_DATE = "NULL">
</cfif>

<cfquery name="upd_warning" datasource="#dsn#">
	UPDATE
		PAGE_WARNINGS
	SET
		WARNING_HEAD = '#ListGetAt(attributes.WARNING_HEAD,1,"--")#',
		SETUP_WARNING_ID = #ListGetAt(attributes.WARNING_HEAD,2,"--")#,
		WARNING_DESCRIPTION = '#attributes.WARNING_DESCRIPTION#',
		LAST_RESPONSE_DATE = #RESPONSE_DATE#,
		SMS_WARNING_DATE = #SMS_WARNING_DATE#,
		EMAIL_WARNING_DATE = #EMAIL_WARNING_DATE#,
	<cfif isDefined("attributes.POSITION_CODE") AND isDefined("attributes.EMPLOYEE") and len(attributes.EMPLOYEE) and len(attributes.POSITION_CODE)>
		POSITION_CODE = #attributes.POSITION_CODE#
	<cfelse>
		POSITION_CODE = NULL
	</cfif>
	WHERE
		W_ID = #attributes.W_ID#
</cfquery>

<script type="text/javascript">
	window.close();
</script>
