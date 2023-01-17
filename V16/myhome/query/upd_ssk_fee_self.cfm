<cf_date tarih="attributes.DATE">
<cf_date tarih="attributes.DATEOUT">
<cfset attributes.sal_mon = month(attributes.DATE)>
<cfset attributes.sal_year = year(attributes.DATE)>
<cfif isDefined("attributes.workcheck") and isDefined("attributes.ILLNESS")>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1222.İş kazası veya meslek hastalığından birini seçiniz '>!");
		history.back();
	</script>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="get_in_out" datasource="#DSN#">
	SELECT
		START_DATE,
		BRANCH_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		IN_OUT_ID = #attributes.in_out_id#
</cfquery>

<cfif not get_in_out.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1224.Çalışanın Seçilen Şube İçin Giriş Çıkış Kaydı Bulunamadı'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfif len(attributes.DATEEVENT) and isdate(attributes.DATEEVENT)>
	<cf_date tarih="attributes.DATEEVENT">
</cfif>

<cfquery name="ADD_SSK_FEE" datasource="#DSN#">
	UPDATE
		EMPLOYEES_SSK_FEE
	SET
		EMPLOYEE_ID = #attributes.employee_id#,
		IN_OUT_ID = #attributes.in_out_id#,
		FEE_DATE = #attributes.DATE#,
		FEE_HOUR = #attributes.HOUR#,
		FEE_DATEOUT = #attributes.DATEOUT#,
		FEE_HOUROUT = #attributes.HOUROUT#,
		ACCIDENT = <cfif isdefined("attributes.workcheck")>1,<cfelse>0,</cfif>
		TOTAL_EMP = <cfif isdefined("attributes.workcheck") and len(attributes.TOTAL_EMP)>#attributes.TOTAL_EMP#,<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>EMP_WORK = '#attributes.EMP_WORK#',<cfelse>EMP_WORK = NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>EVENT = '#attributes.EVENT#',<cfelse>EVENT = NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>PLACE = '#attributes.PLACE#',<cfelse>PLACE = NULL,</cfif>
		<cfif isdefined("attributes.workcheck") and len(attributes.DATEEVENT)>EVENT_DATE = #attributes.DATEEVENT#,<cfelse>EVENT_DATE = NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>EVENT_HOUR = #attributes.HOUREVENT#,<cfelse>EVENT_HOUR = NULL,</cfif> 
		<cfif isdefined("attributes.workcheck")>EVENT_MIN = '#attributes.EVENT_MIN#',<cfelse>EVENT_MIN = NULL,</cfif> 
		<cfif isdefined("attributes.workcheck")>WORKSTART = '#attributes.WORKSTART#',<cfelse>WORKSTART = NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>WITNESS1 = '#attributes.WITNESS1#',<cfelse>WITNESS1 = NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>WITNESS2 = '#attributes.WITNESS2#',<cfelse>WITNESS2 = NULL,</cfif>
		<cfif isdefined("attributes.accident_type_id") and len(attributes.accident_type_id)>ACCIDENT_TYPE_ID = #attributes.ACCIDENT_TYPE_ID#,<cfelse>ACCIDENT_TYPE_ID = NULL,</cfif>
		<cfif isdefined("attributes.accident_security_id") and len(attributes.accident_security_id)>ACCIDENT_SECURITY_ID = #attributes.ACCIDENT_SECURITY_ID#,<cfelse>ACCIDENT_SECURITY_ID = NULL,</cfif>
		ILLNESS = <cfif isdefined("attributes.illness")> 1, <cfelse> 0 ,</cfif>
		BRANCH_ID = #get_in_out.BRANCH_ID#,
		DETAIL = '#FORM.DETAIL#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #NOW()#
	WHERE
		FEE_ID = #attributes.FEE_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
